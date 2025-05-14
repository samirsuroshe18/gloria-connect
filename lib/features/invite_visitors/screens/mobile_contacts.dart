import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/contact_list_tile.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_search_field.dart';

class MobileContacts extends StatefulWidget {
  final Function(String, String) onContactSelected;
  const MobileContacts({super.key, required this.onContactSelected});

  @override
  State<MobileContacts> createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  String searchQuery = '';
  bool _permissionDenied = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(filterContacts);
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      try {
        setState(() {
          _isLoading = true;
        });
        // Fetch contacts with full info (including phone numbers and photo)
        final allContacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
          withThumbnail: true,
        );

        // Filter out contacts without phone numbers
        final contactsWithPhones = allContacts.where((contact) =>
        contact.phones.isNotEmpty && contact.phones.first.number.isNotEmpty
        ).toList();

        setState(() {
          contacts = contactsWithPhones;
          filteredContacts = contactsWithPhones;
          _isLoading = false;
        });
      } catch (e) {
        debugPrint('Error fetching contacts: $e');
        setState(() {
          _isLoading = false;
          _permissionDenied = true;
        });
      }
    }
  }

  void filterContacts() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredContacts = contacts;
        searchQuery = '';
      });
      return;
    }

    final searchTerms = query.toLowerCase().split(' ');

    final filtered = contacts.where((contact) {
      final nameLower = contact.displayName.toLowerCase();
      final phoneLower = contact.phones.isNotEmpty ? contact.phones.first.number.replaceAll(RegExp(r'[^\d]'), '') : '';

      // Check if any search term matches name or phone
      return searchTerms.any((term) => nameLower.contains(term) || (phoneLower.isNotEmpty && phoneLower.contains(term)));}).toList();

    setState(() {
      filteredContacts = filtered;
      searchQuery = query;
    });
  }

  String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // If it starts with '+91' and has more than 10 digits, format it
    if (cleaned.startsWith('+91') && cleaned.length > 10) {
      cleaned = cleaned.substring(3); // Remove +91
    }

    // If it's a 10-digit number, format it as XXX-XXX-XXXX
    if (cleaned.length == 10) {
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }

    return phone; // Return original if doesn't match expected format
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          CustomSearchField(controller: searchController, hintText: 'Search by name or mobile number', top: 8,),
          if (_permissionDenied)
            const Center(
                child: Text(
                  'Permission denied. Please allow contact access in settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                )
            ),
          if (_isLoading)const CustomLoader(),

          if (!_permissionDenied && !_isLoading)
            Expanded(
              child: filteredContacts.isEmpty
                ? Center(
                  child: Text(
                    searchQuery.isEmpty ? 'No contacts found' : 'No contacts matching "$searchQuery"',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  )
                )
                : AnimationLimiter(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      final phoneNumber = contact.phones.isNotEmpty ? formatPhoneNumber(contact.phones.first.number) : 'No phone number';
                      return StaggeredListAnimation(
                        index: index,
                        child: ContactListTile(
                          displayName: contact.displayName,
                          phoneNumber: phoneNumber,
                          photo: contact.photo,
                          onContactSelected: (name, number) {
                            // Handle contact selection
                            widget.onContactSelected(name, number);
                          },
                        ),
                      );
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}