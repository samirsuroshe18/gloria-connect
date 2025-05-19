import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasActiveFilters;

  const FilterButton({
    super.key,
    required this.onTap,
    required this.hasActiveFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.filter_list,
                  color: hasActiveFilters
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                if (hasActiveFilters)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}