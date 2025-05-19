import 'package:flutter/material.dart';

class CustomServiceDialog extends StatelessWidget {
  final String labelText;
  final String image;
  final TextEditingController nameController;
  final void Function() onNext;

  const CustomServiceDialog({
    super.key,
    required this.labelText,
    required this.image,
    required this.nameController,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.deepPurple,
      insetPadding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                image,
                height: 100,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(color: Colors.white70),
                  fillColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onNext();
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}