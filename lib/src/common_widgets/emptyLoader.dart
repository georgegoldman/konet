// ignore_for_file: file_names

import 'package:flutter/widgets.dart';

class EmptyLoader extends StatelessWidget {
  const EmptyLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  }
}
