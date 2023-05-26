import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../entity/server.dart';
import '../entity/user_profile.dart';
import '../widget/app_bars.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoginForm = true;
  bool _isLoading = false;

  String? _username,
      _email,
      _password,
      _confirmPassword,
      _phoneNumber,
      _verificationCode;

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
          queryParameters: {'phone': _phoneNumber, 'password': _password});

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
            msg: "登陆成功。",
            toastLength: Toast.LENGTH_SHORT,
          );
          if (context.mounted) {
            Navigator.pop(context);
          }
          return;
        } else {
          Fluttertoast.showToast(
            msg: "登陆失败，${data['message']}。",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "登陆失败，请检查网络。",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (exception) {
      Fluttertoast.showToast(
        msg: "登陆失败，应用错误。",
        toastLength: Toast.LENGTH_SHORT,
      );
      print(exception);
    }
    Fluttertoast.showToast(
      msg: "登陆失败，请检查网络。",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Future<void> _register(BuildContext context) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.get('/user/register', queryParameters: {
        'phone': _phoneNumber,
        'password': _password,
        'name': _username,
        'email': _email,
        'verCode': _verificationCode,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString());
        if (data['success'] = true) {
          Fluttertoast.showToast(
            msg: "注册成功，现在可以登陆了。",
            toastLength: Toast.LENGTH_SHORT,
          );
          _toggleFormMode();
        } else {
          Fluttertoast.showToast(
            msg: "注册失败，${data['message']}。",
            toastLength: Toast.LENGTH_SHORT,
          );
        }
        return;
      } else {}
    } catch (exception) {
      print(exception);
    }
    Fluttertoast.showToast(
      msg: "注册失败，请检查网络。",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Widget _showUsernameInput() {
    return _isLoginForm
        ? Container()
        : TextFormField(
            onSaved: (val) => _username = val,
            validator: (val) {
              RegExp regExp = RegExp(
                r'^[\u4e00-\u9fa5a-zA-Z\d]+$',
                caseSensitive: false,
                multiLine: false,
              );
              RegExp noChinese = RegExp(
                r'^[a-zA-Z\d]+$',
                caseSensitive: false,
                multiLine: false,
              );
              if (val == null || val.isEmpty) {
                return '用户名不能为空';
              } else if (!regExp.hasMatch(val)) {
                return '用户名只能包含汉字、英文字母或数字';
              } else if (noChinese.hasMatch(val) && val.length < 6) {
                return '用户名应至少包含2个汉字或6个字母';
              } else if (!noChinese.hasMatch(val) && val.length < 2) {
                return '用户名应至少包含2个汉字或6个字母';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: '用户名',
              hintText: '输入用户名',
              icon: Icon(Icons.person),
            ),
          );
  }

  Widget _showEmailInput() {
    return _isLoginForm
        ? Container()
        : TextFormField(
            onSaved: (val) => _email = val,
            validator: (val) =>
                val == null || !val.contains('@') ? '邮箱格式有误' : null,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: '电子邮箱',
              hintText: '输入一个有效的电子邮箱地址',
              icon: Icon(Icons.email),
            ),
          );
  }

  Widget _showPhoneNumberInput() {
    return TextFormField(
      onSaved: (val) => _phoneNumber = val,
      validator: (val) => val == null || val.length != 11
          ? '电话号码格式有误，仅支持中国内地手机号，不支持固定电话、海外及港澳台电话号码。'
          : null,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: '电话号码',
        hintText: '输入您的电话号码',
        icon: Icon(Icons.phone),
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
          return '密码不能为空';
        } else if (!regExp.hasMatch(val)) {
          return '密码应当至少包括8个字符，可以使用大写、小写字母、数字、特殊符号。';
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        labelText: '密码',
        hintText: '输入您的密码',
        icon: Icon(Icons.lock),
      ),
    );
  }

  Widget _showConfirmPasswordInput() {
    return _isLoginForm
        ? Container()
        : TextFormField(
            onSaved: (val) => _confirmPassword = val,
            validator: (val) =>
                val == null || val != _password ? '密码不匹配' : null,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: '确认密码',
              hintText: '再次输入您的密码',
              icon: Icon(Icons.lock),
            ),
          );
  }

  Widget _showVerificationCodeInput() {
    return _isLoginForm
        ? Container()
        : TextFormField(
            onSaved: (val) => _verificationCode = val,
            validator: (val) => val == null || val.isEmpty ? '验证码不能为空' : null,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '验证码',
              hintText: '输入验证码',
              icon: Icon(Icons.code),
            ),
          );
  }

  Widget _showFormActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => _submitForm(context),
          child: Text(_isLoginForm ? '登陆' : '注册'),
        ),
        ElevatedButton(
          onPressed: _toggleFormMode,
          child: Text(_isLoginForm ? '还没有账号? 注册' : '已有账号? 请登录'),
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
      appBar: anAppBar(
        title: Text(_isLoginForm ? '登陆' : '注册'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _showUsernameInput(),
              _showEmailInput(),
              _showPhoneNumberInput(),
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
