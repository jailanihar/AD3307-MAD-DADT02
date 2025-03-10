import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/components/my_text_form_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController emailController = TextEditingController();

  Future<void> _forgotPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    } on FirebaseAuthException catch (_) {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          MyTextFormField(labelText: "Email", controller: emailController),
          ElevatedButton(onPressed: _forgotPassword, child: const Text('Send Email')),
        ],
      ),
    );
  }
  
}