import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ReadOnlyPinCodeField extends StatelessWidget {
  final String initialValue;
  final int length;
  final BuildContext context;

  const ReadOnlyPinCodeField({
    super.key,
    required this.initialValue,
    required this.context,
    this.length = 4,
  });

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: TextEditingController(text: initialValue),
      appContext: this.context,
      length: length,
      readOnly: true,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      pinTheme: PinTheme(
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
        fieldWidth: 50,
        shape: PinCodeFieldShape.box,
        borderWidth: 2,
        activeColor: Colors.blue,
        inactiveColor: Colors.grey.shade300,
        selectedColor: Colors.lightBlueAccent,
        activeFillColor: Colors.blue.shade50,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      boxShadows: [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 8,
          color: Colors.black.withOpacity(0.1),
        ),
      ],
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
