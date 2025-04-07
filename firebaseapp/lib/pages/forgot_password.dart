import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseapp/components/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.forgotPasswordPage),
        centerTitle: true,
      ),
      body: Column(
        children: [
          MyTextFormField(labelText: AppLocalizations.of(context)!.email, controller: emailController),
          ElevatedButton(onPressed: _forgotPassword, child: Text(AppLocalizations.of(context)!.sendEmail)),
        ],
      ),
    );
  }
  
}