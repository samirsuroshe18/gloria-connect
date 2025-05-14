import 'package:flutter/material.dart';

class BlockCard extends StatelessWidget {
  final void Function() onFunctionCall;
  final String blockName;

  const BlockCard({super.key, required this.blockName, required this.onFunctionCall});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onFunctionCall,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Icon(Icons.apartment, color: Colors.white70),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  blockName,
                  style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}