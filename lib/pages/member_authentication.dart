import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widget/app_bars.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _phoneNumber;
  String? _email;
  String? _workplace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: anAppBar(
        title: const Text('用户认证'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: '用户名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入用户名';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _username = value!;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: '电话号码'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入电话号码';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _phoneNumber = value!;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: '手机号'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入手机号';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _email = value!;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(hintText: '工作单位（可选）', labelText: ''),
                onSaved: (value) {
                  setState(() {
                    _workplace = value!;
                  });
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Process data.
                      _formKey.currentState!.save();
                      if (kDebugMode) {
                        print(_username);
                        print(_phoneNumber);
                        print(_email);
                        print(_workplace);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '认证成功！\n$_username\n$_phoneNumber\n$_email\n$_workplace')));
                    }
                  },
                  child:
                      const Text('提交', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
