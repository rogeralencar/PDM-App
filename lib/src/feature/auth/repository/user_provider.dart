import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../common/exceptions/http_exception.dart';
import '../../../common/utils/constants.dart';
import 'user_model.dart';

class UserProvider with ChangeNotifier {
  final String _token;
  final String _userId;
  User? _user;
  User? get user => _user;

  UserProvider([
    this._token = '',
    this._userId = '',
    this._user,
  ]);

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> saveUserInfo(User user, {bool isImageUrl = true}) async {
    var image = '';
    if (isImageUrl) {
      image = user.image.toString();
    } else {
      image = user.image
          .toString()
          .replaceAll("'", "")
          .replaceFirst('F', '')
          .replaceFirst('i', '')
          .replaceFirst('l', '')
          .replaceFirst('e', '')
          .replaceFirst(':', '')
          .replaceFirst(' ', '');
    }

    user.image = image;
    try {
      final response = await http.put(
        Uri.parse('${Constants.userInfo}/$_userId.json?auth=$_token'),
        body: jsonEncode(user.toJson()),
      );

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

  Future<User?> loadUser(
      {String userId = '', bool isAnotherUser = false}) async {
    try {
      if (!isAnotherUser) userId = _userId;
      final response = await http
          .get(Uri.parse('${Constants.userInfo}/$userId.json?auth=$_token'));

      if (response.statusCode == 200) {
        final String responseData = response.body;

        if (responseData.isEmpty || responseData == 'null') {
          return null;
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

        if (isAnotherUser) {
          return user;
        } else {
          setUser(user);
        }
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
    return null;
  }

  Future<void> deleteUserInfo() async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.userInfo}/$_userId.json?auth=$_token'),
      );

      if (response.statusCode == 200) {
        setUser(User());
      } else {
        throw HttpException(
          msg: 'Failed to delete user: ${response.statusCode}',
          statusCode: 1,
        );
      }
    } catch (error) {
      throw HttpException(
        msg: 'Failed to delete user: $error',
        statusCode: 1,
      );
    }
  }
}
