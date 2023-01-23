// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotAMember extends StatelessWidget {
  const NotAMember({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('Not a member Sign up',
          style: TextStyle(color: Color(0xFFE6B325), fontSize: 12)),
      onPressed: () => context.replace('/signup'),
    );
  }
}
