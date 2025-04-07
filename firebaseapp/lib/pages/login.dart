import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebaseapp/components/my_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _typedEmail = '';
  String _typedPassword = '';

  Future<void> _login() async {
    _typedEmail = _emailController.text;
    _typedPassword = _passwordController.text;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _typedEmail,
        password: _typedPassword,
      );
      if(mounted) {
        Navigator.of(context).pushReplacementNamed('/homepage');
      }
    } on FirebaseException catch (_) {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: const Text('Invalid email or password'),
        duration: const Duration(seconds: 3),
      );
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.loginPage),
        backgroundColor: Color.fromRGBO(147, 124, 206, 1.0),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyTextFormField(labelText: AppLocalizations.of(context)!.email, controller: _emailController),
            MyTextFormField(
                labelText: AppLocalizations.of(context)!.password,
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
                Text(AppLocalizations.of(context)!.hidePassword),
              ],
            ),
            ElevatedButton(onPressed: _login, child: Text(AppLocalizations.of(context)!.login)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: Text(AppLocalizations.of(context)!.register),
            ),
            TextButton(onPressed: () {
                Navigator.of(context).pushNamed('/forgotpassword');
              },
              child: Text(AppLocalizations.of(context)!.forgotPassword)
            ),
          ],
        ),
      ),
    );
  }
}
