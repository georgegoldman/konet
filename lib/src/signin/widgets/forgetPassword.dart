// ignore: file_names
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      onPressed: () => context.replace('/resetenteremail'),
    );
  }
}
