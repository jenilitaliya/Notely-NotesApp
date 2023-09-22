import 'package:flutter/material.dart';

class CommonTextFormField extends StatefulWidget {
  final String hintText;
  final bool obSecure;
  final TextEditingController controller;
  final validator;
  final prefixIcon;
  final suffixIcon;
  final readOnly;

  const CommonTextFormField({
    Key? key,
    required this.obSecure,
    required this.controller,
    this.validator,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly,
  }) : super(key: key);

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 18),
      readOnly: widget.readOnly,
      obscureText: widget.obSecure,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(20),
            left: Radius.circular(20),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(20),
            left: Radius.circular(20),
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}

// decoration: InputDecoration(
// hintText: widget.hintText,
// enabledBorder: const OutlineInputBorder(
// borderSide: BorderSide(color: Colors.white),
// ),
// focusedBorder: OutlineInputBorder(
// borderSide: BorderSide(color: Colors.grey.shade400),
// ),
// ),
