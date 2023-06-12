import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:convert';

import '../../../auth/repository/user_model.dart';
import '../../../auth/repository/user_provider.dart';

class CepWidget extends StatefulWidget {
  const CepWidget({Key? key}) : super(key: key);

  @override
  State<CepWidget> createState() => _CepWidgetState();
}

class _CepWidgetState extends State<CepWidget> {
  TextEditingController cepController = TextEditingController();
  late String cep;
  late String city;
  late UserProvider userProvider;
  late User user;

  @override
  void initState() {
    super.initState();
    cep = '';
    city = '';
    fetchUserCep();
  }

  void fetchUserCep() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.user!;

    cep = user.cep ?? '';
    city = user.city ?? '';
  }

  void saveCep(String value) async {
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$value/json/'));
      if (response.statusCode == 200) {
        fetchCepData(value, user);

        await userProvider.saveUserInfo(user);
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Informe seu CEP'),
          content: TextField(
            controller: cepController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              MaskTextInputFormatter(mask: '#####-###'),
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

  void fetchCepData(String value, User user) async {
    if (value.isEmpty) return;
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$value/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          user.cep = value;
          user.city = data['localidade'];
        });
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (city.isEmpty)
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
        if (city.isNotEmpty)
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
                        '$city, $cep',
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