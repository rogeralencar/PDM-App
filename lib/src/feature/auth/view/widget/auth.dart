import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:localization/localization.dart';

import '../../repository/user_store.dart';
import '../../../../common/exceptions/auth_exception.dart';
import '../../../../common/utils/constants.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _refreshTimer;
  String? _refreshToken;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=${Constants.webApiKey}';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _refreshToken = body['refreshToken'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      UserStore.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'refreshToken': _refreshToken,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoRefreshToken();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> resetPassword(String email) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=${Constants.webApiKey}';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'requestType': 'PASSWORD_RESET',
        'email': email,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await UserStore.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _refreshToken = userData['refreshToken'];
    _expiryDate = expiryDate;

    _autoRefreshToken();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _refreshToken = null;
    _clearRefreshTimer();
    UserStore.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _autoRefreshToken() {
    if (_expiryDate == null || _refreshToken == null) return;

    final refreshDuration =
        _expiryDate!.difference(DateTime.now()) - const Duration(minutes: 5);

    _clearRefreshTimer();
    _refreshTimer = Timer(refreshDuration, () async {
      try {
        final refreshResponse = await http.post(
          Uri.parse(
              'https://securetoken.googleapis.com/v1/token?key=${Constants.webApiKey}'),
          body: {
            'grant_type': 'refresh_token',
            'refresh_token': _refreshToken!,
          },
        );

        final refreshData = jsonDecode(refreshResponse.body);

        if (refreshData['error'] != null) {
          throw AuthException(refreshData['error']['message']);
        } else {
          _token = refreshData['id_token'];
          _expiryDate = DateTime.now().add(
            Duration(seconds: int.parse(refreshData['expires_in'])),
          );

          UserStore.saveMap('userData', {
            'token': _token,
            'email': _email,
            'userId': _userId,
            'refreshToken': _refreshToken,
            'expiryDate': _expiryDate!.toIso8601String(),
          });

          _autoRefreshToken();
          notifyListeners();
        }
      } catch (error) {
        Modular.to.navigate('/auth/');
        throw AuthException('token_refresh_error'.i18n());
      }
    });
  }

  void _clearRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> deleteUserAuth() async {
    if (!isAuth) {
      throw AuthException('authentication_error'.i18n());
    }

    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=${Constants.webApiKey}';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'idToken': _token,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      logout();
    }
  }
}
