import 'package:flutter/material.dart';
import 'package:gloria_connect/features/guard_profile/widgets/flat_chip.dart';

class AddFlatsSection extends StatelessWidget {
  final List<String> selectedFlats;
  final VoidCallback onAddFlat;
  final void Function(int index) onRemoveFlat;

  const AddFlatsSection({
    super.key,
    required this.selectedFlats,
    required this.onAddFlat,
    required this.onRemoveFlat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(onAdd: onAddFlat),
        if (selectedFlats.isNotEmpty)
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedFlats.length,
              itemBuilder: (context, index) {
                return FlatChip(
                  flatName: selectedFlats[index],
                  onRemove: () => onRemoveFlat(index),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onAdd;

  const _Header({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Add Flats',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, color: Colors.white70),
          label: const Text(
            'Add',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
