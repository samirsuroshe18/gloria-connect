import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AuthDropdownButtonFormField<T> extends StatelessWidget {
  final Icon? icon;
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final TextEditingController controller;

  const AuthDropdownButtonFormField({
    super.key,
    this.icon,
    required this.hintText,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            icon ?? const Icon(Icons.disabled_by_default), //Colors.blueAccent
            const SizedBox(width: 8), // Add space between the icon and the hint
            Text(
              hintText,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Row(
            children: [
              icon ?? const Icon(Icons.disabled_by_default),
              const SizedBox(width: 8),
              Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )).toList(),
        value: selectedValue,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.black54, width: 1.0), // Use dynamic border color
            color: Colors.blue.withOpacity(0.1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55, // Adjust the button height
          width: double.infinity, // Full width
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white, // Dropdown background color
            border: Border.all(color: Colors.black54, width: 1.0),
          ),
          maxHeight: 200, // Adjust dropdown max height
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40, // Adjust height of individual items
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: controller,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for an item...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            controller.clear(); // Clear search text when dropdown is closed
          }
        },
      ),
    );
  }
}
