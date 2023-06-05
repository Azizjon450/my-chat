import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _userData = {'email': '', 'username': '', 'password': ''};
  var _isLogin = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_userData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Email address'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please, enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userData['email'] = newValue!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length <= 4) {
                          return 'Username must be more than 4 characters';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _userData['username'] = newValue!;
                      },
                    ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length <= 7) {
                        return 'Password must be more than 7 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userData['password'] = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple)),
                    child: Text(_isLogin ?
                      'Log In' : 'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin ? 'Sign Up' : 'Log In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
