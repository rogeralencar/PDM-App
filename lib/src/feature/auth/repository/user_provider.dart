import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../common/exceptions/http_exception.dart';
import '../../../common/utils/constants.dart';
import '../../../main.dart';
import '../view/widget/auth.dart';
import 'user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  final BuildContext? context = navigatorKey.currentContext;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> saveUserInfo(User user) async {
    final BuildContext? context = navigatorKey.currentContext;
    Auth auth = Provider.of<Auth>(context!, listen: false);
    try {
      final response = await http.put(
        Uri.parse(
            '${Constants.userInfo}/${auth.userId}.json?auth=${auth.token}'),
        body: jsonEncode(user.toJson()),
      );
      setUser(user);

      if (response.statusCode >= 400) {
        throw HttpException(
          msg: 'Failed to save user information: ${response.statusCode}',
          statusCode: 1,
        );
      }
    } catch (error) {
      throw HttpException(
        msg: 'Failed to save user information: $error',
        statusCode: 1,
      );
    }
  }

  Future<void> loadUser() async {
    final BuildContext? context = navigatorKey.currentContext;
    Auth auth = Provider.of<Auth>(context!, listen: false);

    try {
      final response = await http.get(Uri.parse(
          '${Constants.userInfo}/${auth.userId}.json?auth=${auth.token}'));

      if (response.statusCode == 200) {
        final String responseData = response.body;

        if (responseData.isEmpty || responseData == 'null') {
          return;
        }

        final Map<String, dynamic> jsonData = json.decode(responseData);

        final User user = User(
          age: jsonData['age'] ?? 0,
          bio: jsonData['bio'] ?? '',
          cep: jsonData['cep'] ?? '',
          city: jsonData['city'] ?? '',
          cpf: jsonData['cpf'] ?? '',
          email: jsonData['email'] ?? '',
          gender: jsonData['gender'] ?? '',
          image: jsonData['image'] ?? '',
          name: jsonData['name'] ?? '',
          phoneNumber: jsonData['phoneNumber'] ?? '',
          socialName: jsonData['socialName'] ?? '',
        );

        setUser(user);
      } else {
        throw HttpException(
          msg: 'Failed to load user information: ${response.statusCode}',
          statusCode: 1,
        );
      }
    } catch (error) {
      throw HttpException(
        msg: 'Failed to load user information: $error',
        statusCode: 1,
      );
    }
  }
}
