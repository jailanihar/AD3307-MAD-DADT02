import 'package:flutter/material.dart';
import 'package:myfirstmobileapp/components/MyTextFormField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _typedEmail = '';
  String _typedPassword = '';

  void _login() {
    print('Login button pressed');
    print('Email typed: ${_emailController.text}');
    print('Password typed: ${_passwordController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Color.fromRGBO(147, 124, 206, 1.0),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyTextFormField(labelText: 'Email', controller: _emailController),
            MyTextFormField(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: _obscurePassword),
            Row(
              children: [
                Checkbox(
                  value: _obscurePassword,
                  onChanged: (value) {
                    setState(() {
                      _obscurePassword = value!;
                    });
                  },
                ),
                const Text('Obscure Password'),
              ],
            ),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
          ],
        ),
      ),
    );
  }
}
