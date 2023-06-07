import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';
import 'package:provider/provider.dart';

class CepWidget extends StatefulWidget {
  const CepWidget({Key? key}) : super(key: key);

  @override
  State<CepWidget> createState() => _CepWidgetState();
}

class _CepWidgetState extends State<CepWidget> {
  TextEditingController cepController = TextEditingController();
  late String cep;
  late String city;
  late String cepNumber;
  late UserProvider userProvider;
  late User user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cep = '';
    city = '';
    cepNumber = '';
    fetchUserCep();
  }

  void fetchUserCep() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.user!;

    cep = user.cep ?? '';

    setState(() {
      isLoading = true;
    });

    fetchCepData(cep);
  }

  void saveCep(String value) async {
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$value/json/'));
      if (response.statusCode == 200) {
        final user = userProvider.user;

        if (user != null) {
          setState(() {
            user.cep = value;
          });
          await userProvider.saveUserInfo(user);
          fetchCepData(value);
        }
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao obter os dados do CEP.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void openCepDialog() {
    cepController.text = cep;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informe seu CEP'),
          content: TextField(
            controller: cepController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            decoration: const InputDecoration(
              hintText: 'Digite seu CEP',
            ),
            onSubmitted: (value) {
              saveCep(value);
              Navigator.of(context).pop();
            },
            onChanged: (value) {
              cep = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                saveCep(cepController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void fetchCepData(String value) async {
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$value/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          city = data['localidade'];
          cepNumber = data['cep'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isLoading || cep.isEmpty)
          InkWell(
            onTap: () {
              openCepDialog();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 32,
                  ),
                  Text(
                    'Informe seu CEP',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!isLoading && cep.isNotEmpty)
          InkWell(
            onTap: () {
              openCepDialog();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 32,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enviar para',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$city, $cepNumber',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cepRegex = RegExp(r'^(\d{0,5})-?(\d{0,3})$');
    final match = cepRegex.firstMatch(newValue.text);

    if (match != null) {
      final formattedText =
          '${match.group(1)}${match.group(2)!.isNotEmpty ? '-' : ''}${match.group(2)}';

      return TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }

    return oldValue;
  }
}
