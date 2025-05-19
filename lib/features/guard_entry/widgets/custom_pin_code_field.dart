import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCodeField extends StatelessWidget {
  final BuildContext appContext;
  final int length;
  final Function(String) onChanged;
  final Function(String)? onCompleted;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool readOnly;

  const CustomPinCodeField({
    super.key,
    required this.appContext,
    required this.length,
    required this.onChanged,
    this.onCompleted,
    this.keyboardType = TextInputType.number,
    this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: appContext,
      controller: controller,
      length: length,
      readOnly: readOnly,
      keyboardType: keyboardType,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      onChanged: onChanged,
      onCompleted: onCompleted,
      pinTheme: PinTheme(
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
        fieldWidth: 50,
        shape: PinCodeFieldShape.box,
        borderWidth: 2,
        borderRadius: BorderRadius.circular(12),
        activeColor: Colors.blue,
        inactiveColor: Colors.grey.shade300,
        selectedColor: Colors.lightBlueAccent,
        activeFillColor: Colors.blue.shade50,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.blue.shade100,
      ),
      boxShadows: [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 8,
          color: Colors.black.withValues(alpha: 0.1),
        ),
      ],
      cursorColor: Colors.blue,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
      enablePinAutofill: true,
      backgroundColor: Colors.transparent,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    );
  }
}