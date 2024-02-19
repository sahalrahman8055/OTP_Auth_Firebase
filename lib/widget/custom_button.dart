import 'package:flutter/material.dart';
import 'package:otp_auth/constants/border_radius.dart';
import 'package:otp_auth/helper/colors.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;
  const CustomButton({super.key, required this.text, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(cWhiteColor),
        backgroundColor: MaterialStateProperty.all<Color>(cPurpleColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: cRadius25,
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
