import 'dart:convert';

import 'package:birdart/l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../entity/server.dart';
import '../entity/user_profile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoginForm = true;
  final bool _isLoading = false;

  String? _username, _email, _password, _verificationCode;

  void _toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void _submitForm(BuildContext context) {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      FocusManager.instance.primaryFocus?.unfocus();
      if (_isLoginForm) {
        _login(context);
      } else {
        _register(context);
      }
    }
  }

  Future<void> _login(BuildContext context) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.get('/user/login',
          queryParameters: {'email': _email, 'password': _password});

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString());
        if (data['success'] = true) {
          Map<String, dynamic> userInfo = data['data'];
          UserProfile.id = userInfo['id'];
          UserProfile.phone = userInfo['phone'];
          UserProfile.password = userInfo['password'];
          UserProfile.email = userInfo['email'];
          UserProfile.name = userInfo['name'];
          UserProfile.session = userInfo['token'];
          UserProfile.role = userInfo['role'];
          UserProfile.status = userInfo['status'];
          UserProfile.number = userInfo['number'];

          Fluttertoast.showToast(
            msg: BdL10n.current.loginSuccess,
            toastLength: Toast.LENGTH_SHORT,
          );
          if (context.mounted) {
            Navigator.pop(context);
          }
          return;
        } else {
          Fluttertoast.showToast(
            msg: BdL10n.current.loginFailed + data['message'],
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: BdL10n.current.loginFailed + BdL10n.current.loginNetworkError,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (exception, stackTrace) {
      Fluttertoast.showToast(
        msg: BdL10n.current.loginFailed + BdL10n.current.loginAppError,
        toastLength: Toast.LENGTH_SHORT,
      );
      debugPrint(exception.toString());
      debugPrintStack(stackTrace: stackTrace);
    }
    Fluttertoast.showToast(
      msg: BdL10n.current.loginFailed + BdL10n.current.loginNetworkError,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<void> _register(BuildContext context) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.get('/user/register', queryParameters: {
        'password': _password,
        'name': _username,
        'email': _email,
        'verCode': _verificationCode,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString());
        if (data['success'] = true) {
          Fluttertoast.showToast(
            msg: BdL10n.current.registerSuccess,
            toastLength: Toast.LENGTH_SHORT,
          );
          _toggleFormMode();
        } else {
          Fluttertoast.showToast(
            msg: BdL10n.current.registerFailed + data['message'],
            toastLength: Toast.LENGTH_SHORT,
          );
        }
        return;
      } else {}
    } catch (exception, stackTrace) {
      debugPrint(exception.toString());
      debugPrintStack(stackTrace: stackTrace);
    }
    Fluttertoast.showToast(
      msg: BdL10n.current.registerFailed + BdL10n.current.loginNetworkError,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Widget _showUsernameInput() {
    return _isLoginForm
        ? Container()
        : TextFormField(
            onSaved: (val) => _username = val,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return BdL10n.current.registerNameNotEmpty;
              } else if (val.length < 6) {
                return BdL10n.current.registerNameLength;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: BdL10n.current.loginFormUsername,
              hintText: BdL10n.current.loginFormUsernameHint,
              icon: const Icon(Icons.person),
            ),
          );
  }

  Widget _showEmailInput() {
    return TextFormField(
      onSaved: (val) => _email = val,
      validator: (val) => val == null || !val.contains('@')
          ? BdL10n.current.loginFormEmailFormat
          : null,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: BdL10n.current.loginFormEmail,
        hintText: BdL10n.current.loginFormEmailHint,
        icon: const Icon(Icons.email),
      ),
    );
  }

  Widget _showPasswordInput() {
    return TextFormField(
      onSaved: (val) => _password = val,
      validator: (val) {
        _password = val;
        RegExp regExp = RegExp(
          r'^[a-zA-Z\d]+$',
          caseSensitive: false,
          multiLine: false,
        );
        if (val == null || val.isEmpty) {
          return BdL10n.current.loginFormPasswordNotEmpty;
        } else if (!regExp.hasMatch(val)) {
          return BdL10n.current.loginFormPasswordFormat;
        }
        return null;
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: BdL10n.current.loginFormPassword,
        hintText: BdL10n.current.loginFormPasswordHint,
        icon: const Icon(Icons.lock),
      ),
    );
  }

  Widget _showConfirmPasswordInput() {
    return _isLoginForm
        ? Container()
        : TextFormField(
            validator: (val) => val == null || val != _password
                ? BdL10n.current.loginFormConfirmNotMatch
                : null,
            obscureText: true,
            decoration: InputDecoration(
              labelText: BdL10n.current.loginFormConfirmPassword,
              hintText: BdL10n.current.loginFormConfirmPasswordHint,
              icon: const Icon(Icons.lock),
            ),
          );
  }

  Widget _showVerificationCodeInput() {
    return _isLoginForm
        ? Container()
        : TextFormField(
            onSaved: (val) => _verificationCode = val,
            validator: (val) => val == null || val.isEmpty
                ? BdL10n.current.loginFormVerFormat
                : null,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: BdL10n.current.loginFormVer,
              hintText: BdL10n.current.loginFormVerHint,
              icon: const Icon(Icons.code),
            ),
          );
  }

  Widget _showFormActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => _submitForm(context),
          child: Text(_isLoginForm
              ? BdL10n.current.myLogin
              : BdL10n.current.myRegister),
        ),
        ElevatedButton(
          onPressed: _toggleFormMode,
          child: Text(_isLoginForm
              ? BdL10n.current.registerHint
              : BdL10n.current.loginHint),
        )
      ],
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return const SizedBox(height: 0.0, width: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isLoginForm ? BdL10n.current.myLogin : BdL10n.current.myRegister),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _showUsernameInput(),
              _showEmailInput(),
              _showPasswordInput(),
              _showConfirmPasswordInput(),
              _showVerificationCodeInput(),
              const SizedBox(
                height: 8.0,
              ),
              _showFormActions(context),
              _showCircularProgress(),
            ],
          ),
        ),
      ),
    );
  }
}
