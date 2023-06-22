import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cep = '';
    city = '';
    fetchUserCep();

    userProvider.addListener(userProviderListener);
  }

  @override
  void dispose() {
    userProvider.removeListener(userProviderListener);
    super.dispose();
  }

  void userProviderListener() {
    setState(() {
      user = userProvider.user!;
      cep = user.cep ?? '';
      city = user.city ?? '';
    });
  }

  void fetchUserCep() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.user!;

    cep = user.cep ?? '';
    city = user.city ?? '';
  }

  void saveCep(String value) async {
    try {
      setState(() {
        isLoading = true;
      });
      await fetchCepData(value, user);

      userProvider.setUser(user);
    } catch (e) {
      _showErrorDialog();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCepData(String value, User user) async {
    if (value.isEmpty) return;
    try {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$value/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        user.cep = value;
        user.city = data['localidade'];
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
          title: Text('error'.i18n()),
          content: Text('error_getting_cep_data'.i18n()),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('ok'.i18n()),
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
          title: Text('enter_your_cep'.i18n()),
          content: TextField(
            controller: cepController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              MaskTextInputFormatter(mask: '#####-###'),
            ],
            decoration: InputDecoration(
              hintText: 'enter_cep'.i18n(),
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
                cep = cepController.text;
                saveCep(cep);
                Navigator.of(context).pop();
              },
              child: Text('save'.i18n()),
            ),
          ],
        );
      },
    );
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 32,
                  ),
                  Text(
                    'enter_your_cep'.i18n(),
                    style: const TextStyle(
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
                      Text(
                        'send_to'.i18n(),
                        style: const TextStyle(
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
        if (isLoading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
      ],
    );
  }
}
