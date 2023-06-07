// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput(
      {Key? key,
      required this.textEditingController,
      required this.hintText,
      this.isPass = false,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusedInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
    );
    final enabledInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        focusedBorder: focusedInputBorder,
        enabledBorder: enabledInputBorder,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.all(20),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
