import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;

  const CustomInput({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
