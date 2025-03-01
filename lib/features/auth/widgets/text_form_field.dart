import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String errorMsg;
  final Icon? icon;
  final bool obscureText;
  final int inputLength;
  final TextInputType inputType;
  const AuthTextField({super.key, required this.hintText, required this.controller, required this.errorMsg, this.icon, required this.obscureText, this.inputLength = 100, this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(inputLength)
      ],
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        fillColor: Colors.blue.withOpacity(0.1),
        filled: true,
        prefixIcon: icon,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMsg;
        }else if(value.length!=10 && inputLength == 10 || value.length!=6 && inputLength == 6){
          return errorMsg;
        }else if(value.length==10 && inputType == TextInputType.datetime){
          // Regex for dd/mm/yyyy
          RegExp dateRegExp = RegExp(
            r'^([0-2][0-9]|(3)[0-1])\/([0][0-9]|(1)[0-2])\/\d{4}$',
          );

          if (!dateRegExp.hasMatch(value)) {
            return errorMsg;
          }else{
            return null;
          }
        }else{
          return null;
        }
      },
    );
  }
}
