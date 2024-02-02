import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../entity/server.dart';
import '../entity/user_profile.dart';
import '../l10n/l10n.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isButtonEnabled = true;
int seconds = 60;
Timer? t;
bool _isLoginForm = true;

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _verSmsCode = false;
  bool _isResetting = false;

  String? _username, _email, _password, _phoneNumber, _verificationCode;

  void _toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void _toggleFindingMode() {
    setState(() {
      _isResetting = !_isResetting;
    });
  }

  void _submitForm(BuildContext context) {
    _verSmsCode = true;
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        _isLoading = true;
      });

      _verSmsCode = false;
      if (_isResetting) {
        _reset(context);
      } else if (_isLoginForm) {
        _login(context);
      } else {
        _register(context);
      }
    }
  }

  Future<void> _login(BuildContext context) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.post('/user/login', data: FormData.fromMap({'phone': _phoneNumber, 'password': _password}));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString());

        Map<String, dynamic> userInfo = data['data'];
        UserProfile.id = userInfo['id'];
        UserProfile.phone = userInfo['phone'];
        // UserProfile.password = userInfo['password'];
        UserProfile.email = userInfo['email'];
        UserProfile.name = userInfo['name'];
        UserProfile.session = userInfo['session'];
        UserProfile.role = userInfo['role'];
        UserProfile.status = userInfo['status'];

        Fluttertoast.showToast(
          msg: BdL10n.current.loginSuccess,
          toastLength: Toast.LENGTH_SHORT,
        );

        seconds = 0;
        isButtonEnabled = true;
        if (context.mounted) {
          Navigator.pop(context, true);
        }

        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        Fluttertoast.showToast(
          msg: BdL10n.current.loginFailed + response.toString(),
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (exception, stack) {
      Fluttertoast.showToast(
        msg: BdL10n.current.loginFailed + BdL10n.current.loginAppError,
        toastLength: Toast.LENGTH_SHORT,
      );
      if (kDebugMode) {
        print(exception.toString() + stack.toString());
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _register(BuildContext context) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.post('/user/register', data: FormData.fromMap({
        'phone': _phoneNumber,
        'password': _password,
        'name': _username,
        'email': _email,
        'sms_code': _verificationCode,
      }));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: BdL10n.current.registerSuccess,
          toastLength: Toast.LENGTH_SHORT,
        );

        seconds = 0;
        isButtonEnabled = true;
        _toggleFormMode();

        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        Fluttertoast.showToast(
          msg: BdL10n.current.registerFailed + response.toString(),
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (exception) {
      Fluttertoast.showToast(
        msg: BdL10n.current.registerFailed + BdL10n.current.loginAppError,
        toastLength: Toast.LENGTH_SHORT,
      );
      if (kDebugMode) {
        print(exception);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _reset(BuildContext context) async {
    Dio dio = Server.dio;

    try {
      var response = await dio.post('/user/resetpass', data: FormData.fromMap({
        'phone': _phoneNumber,
        'password': _password,
        'sms_code': _verificationCode,
      }));

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: BdL10n.current.resetPasswordSuccessful,
          toastLength: Toast.LENGTH_SHORT,
        );

        seconds = 0;
        isButtonEnabled = true;
        _toggleFindingMode();

        setState(() {
          _isLoading = false;
        });

        return;
      } else {
        Fluttertoast.showToast(
          msg: BdL10n.current.resetPasswordFailed + response.toString(),
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (exception) {
      Fluttertoast.showToast(
        msg: BdL10n.current.resetPasswordFailed + BdL10n.current.loginAppError,
        toastLength: Toast.LENGTH_SHORT,
      );

      if (kDebugMode) {
        print(exception);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _sendSMS(BuildContext context) async {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
    } else {
      return;
    }

    Dio dio = Server.dio;

    try {
      var response = await dio.post('/user/smscode', data: FormData.fromMap({
            'phone': _phoneNumber,
          }));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.toString());
        print(data);

        UserProfile.session = data['data'];
        Fluttertoast.showToast(
          msg: BdL10n.current.smsCodeSendSuccessful,
          toastLength: Toast.LENGTH_SHORT,
        );
        _verSmsCode = true;

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          setState(() {
            isButtonEnabled = false;
          });
          seconds = 60;
          _startTimer();
        }

        return;
      } else {
        Fluttertoast.showToast(
          msg: BdL10n.current.smsCodeSendFailed + response.toString(),
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (exception) {
      Fluttertoast.showToast(
        msg: BdL10n.current.smsCodeSendFailed + BdL10n.current.loginAppError,
        toastLength: Toast.LENGTH_SHORT,
      );

      if (kDebugMode) {
        print(exception);
      }
      return;
    }
  }

  Widget _showUsernameInput() {
    return (_isLoginForm || _isResetting)
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

  Widget _showPhoneNumberInput() {
    return TextFormField(
      onSaved: (val) => _phoneNumber = val,
      validator: (val) => val == null || val.length != 11 ? '电话号码格式有误，仅支持中国内地手机号，不支持固定电话、港澳台及海外电话号码，敬请谅解。' : null,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: BdL10n.current.loginFormPhone,
        hintText: BdL10n.current.loginFormPhoneHint,
        icon: const Icon(Icons.phone),
      ),
    );
  }

  Widget _showPasswordInput() {
    return TextFormField(
      onSaved: (val) => _password = val,
      validator: (val) {
        _password = val;
        RegExp regExp = RegExp(
          r'^[\u0020-\u007E]+$',
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
    return (_isLoginForm && !_isResetting)
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
    return (_isLoginForm && !_isResetting)
        ? Container()
        : Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextFormField(
            onSaved: (val) => _verificationCode = val,
            validator: (val) => _verSmsCode && (val == null || val.isEmpty)
                ? BdL10n.current.loginFormVerFormat
                : null,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: BdL10n.current.loginFormVer,
              hintText: BdL10n.current.loginFormVerHint,
              icon: const Icon(Icons.code),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: isButtonEnabled
              ? () {
            _sendSMS(context);
          }
              : null,
          child: isButtonEnabled ? Text(BdL10n.current.smsCodeButton) : countdownWidget(),
        )
      ],
    );
  }

  _startTimer() {
    t = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds == 0) {
        t?.cancel(); //清除定时器
        setState(() {
          isButtonEnabled = true;
        });
        seconds = 60;
      }
    });
  }

  @override
  void initState() {
    if (!isButtonEnabled) {
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  countdownWidget() => GestureDetector(
    onTap: () {
      final snackBar = SnackBar(
        content: Text(BdL10n.current.smsTooFrequently),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    },
    child: Text(BdL10n.current.smsRetryInSeconds(seconds)),
  );

  Widget _showFormActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => _submitForm(context),
          child: Text(_isResetting
              ? BdL10n.current.myResetPassword
              : _isLoginForm
              ? BdL10n.current.myLogin
              : BdL10n.current.myRegister),
        ),
        if (!_isResetting)
          ElevatedButton(
            onPressed: _toggleFormMode,
            child: Text(_isLoginForm
                    ? BdL10n.current.registerHint
                    : BdL10n.current.loginHint),
          ),
        if (_isLoginForm)
          ElevatedButton(
            onPressed: _toggleFindingMode,
            child: Text(_isResetting ? BdL10n.current.loginFromReset : BdL10n.current.forgetPassword),
          ),
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
