import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/components/my_text_form_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  String _typedEmail = '';
  String _typedPassword = '';
  String _typedUsername = '';
  String _typedFullname = '';

  Future<void> _register() async {
    _typedEmail = _emailController.text;
    _typedPassword = _passwordController.text;
    _typedUsername = _usernameController.text;
    _typedFullname = _fullnameController.text;
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _typedEmail,
        password: _typedPassword,
      );

      if(mounted) {
        Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (_) {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: const Text('Unable to register'),
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
        title: const Text('Register Page'),
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
            MyTextFormField(
                labelText: 'Username',
                controller: _usernameController),
            MyTextFormField(
                labelText: 'Full Name',
                controller: _fullnameController),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Text(_obscurePassword ? 'Show Password' : 'Hide Password'),
                ),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}