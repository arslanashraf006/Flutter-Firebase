import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget({
    Key? key,
    required this.emailController,
    required this.hintText,
    required this.validator,
    required this.prefixIcon,
    required this.textInputType,
  }) : super(key: key);

  final TextEditingController emailController;
  final String hintText;
  final Widget prefixIcon;
  final TextInputType textInputType;
  final validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: emailController,
      decoration:  InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      validator: validator,
    );
  }
}
