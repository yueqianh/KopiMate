import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/user_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text('Password reset link sent!'),
              );
            });
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 208, 185, 174),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter your email for your password reset link',
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 10),
          //email textfield
          UserTextField(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
          ),

          MaterialButton(
              onPressed: passwordReset,
              color: const Color.fromARGB(255, 208, 185, 174),
              child: const Text('Reset password'))
        ],
      ),
    );
  }
}
