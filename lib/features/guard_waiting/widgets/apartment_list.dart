import 'package:flutter/material.dart';

class ApartmentList extends StatelessWidget {
  final List<String> apartments;

  const ApartmentList({super.key, required this.apartments});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(5.0),
          child: Icon(Icons.home, size: 20, color: Colors.white70),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: apartments
                .map((apt) => Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                apt,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ))
                .toList(),
          ),
        ),
      ],
    );
  }
}