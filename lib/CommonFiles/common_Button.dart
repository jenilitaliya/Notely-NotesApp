import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  const CommonButton({
    super.key,
    required this.text,
    this.onTap,
  });
  final String text;
  final Function()? onTap;
  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return MaterialButton(
      onPressed: widget.onTap,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height * 0.01),
          side: const BorderSide(color: Colors.transparent)),
      minWidth: width * 0.9,
      height: height * 0.075,
      color: const Color(0xff435B66),
      child: Text(
        widget.text,
        style: TextStyle(fontSize: 25, color: Colors.white),
      ),
    );
  }
}
