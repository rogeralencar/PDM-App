import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../common/exceptions/http_exception.dart';
import '../../../common/utils/constants.dart';
import 'user_provider.dart';

class User {
  String? name;
  String? nomeSocial;
  int? idade;
  String? cpf;
  String? genero;
  String? bio;
  String? userId;
  String? email;
  String? numeroTelefone;
  String? cep;
  String? image;

  User({
    this.name,
    this.nomeSocial,
    this.idade,
    this.cpf,
    this.genero,
    this.bio,
    this.userId,
    this.email,
    this.numeroTelefone,
    this.cep,
    this.image,
  });

  Future<void> saveUserInfo(String token) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.productBaseUrl}/$userId.json?auth=$token'),
        body: jsonEncode(toJson(token)),
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

  Map<String, dynamic> toJson(String token) {
    return {
      'name': name,
      'nomeSocial': nomeSocial,
      'idade': idade,
      'cpf': cpf,
      'genero': genero,
      'bio': bio,
      'userId': userId,
      'email': email,
      'numeroTelefone': numeroTelefone,
      'cep': cep,
      'authToken': token,
      'image': image,
    };
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.productBaseUrl}/$userId.json'));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body) as Map<String, dynamic>?;
        return userData ?? {};
      } else {
        throw HttpException(
          msg: 'Failed to get user information: ${response.statusCode}',
          statusCode: 1,
        );
      }
    } catch (error) {
      throw HttpException(
        msg: 'Failed to get user information: $error',
        statusCode: 1,
      );
    }
  }

  Future<void> loadUser(String userId, String email, String token) async {
    try {
      final response = await http.get(Uri.parse(
          '${Constants.productBaseUrl}/$userId.json?orderBy="email"&equalTo="$email"&auth=$token'));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body) as Map<String, dynamic>?;
        if (userData != null && userData.isNotEmpty) {
          final String userId = userData.keys.first;
          final Map<String, dynamic> userInfo = userData[userId];
          final User user = User(
            userId: userId,
            name: userInfo['name'],
            email: userInfo['email'],
          );

          final userProvider = UserProvider();
          userProvider.setUser(user);
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
  }
}
