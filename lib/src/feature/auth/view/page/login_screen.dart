import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_text_field.dart';
import '../../../../common/exceptions/auth_exception.dart';
import '../widget/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      await auth.login(
        _authData['email']!,
        _authData['password']!,
      );

      Modular.to.pushNamed('/home');
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error, stackTrace) {
      debugPrint('Erro inesperado: $error');
      debugPrint('StackTrace: $stackTrace');
      _showErrorDialog('Ocorreu um erro inesperado!');
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.1,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'lib/assets/images/SNAP_LOGO.PNG.png',
                      height: screenSize.height * 0.15,
                    ),
                    Text(
                      'Login Account',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenSize.height * 0.06),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomTextField(
                              labelText: 'Enter your E-mail',
                              focusNode: _emailFocus,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, insira o e-mail';
                                }
                                return null;
                              },
                              onSaved: (email) =>
                                  _authData['email'] = email ?? '',
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.016),
                          Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomTextField(
                              labelText: 'Enter Password',
                              focusNode: _passwordFocus,
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Por favor, insira a senha';
                                }
                                return null;
                              },
                              onSaved: (password) =>
                                  _authData['password'] = password ?? '',
                              onFieldSubmitted: (_) {
                                _submit();
                              },
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.008),
                          TextButton(
                            onPressed: () {
                              Modular.to.navigate('/auth/forgotPassword');
                            },
                            style: const ButtonStyle(
                              alignment: Alignment.centerRight,
                            ),
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: screenSize.width * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    _isLoading
                        ? CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.outline,
                          )
                        : CustomButton(
                            buttonText: 'LOG IN',
                            onPressed: _submit,
                          ),
                    SizedBox(height: screenSize.height * 0.12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account ? ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: screenSize.width * 0.04,
                          ),
                        ),
                        CustomButton(
                          buttonText: 'SIGN UP',
                          onPressed: () {
                            Modular.to.navigate('/auth/signup');
                          },
                          isBig: false,
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
