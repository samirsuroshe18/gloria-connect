import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MobileContacts extends StatefulWidget {
  final Function(String, String) onContactSelected;
  const MobileContacts({super.key, required this.onContactSelected});

  @override
  State<MobileContacts> createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> with AutomaticKeepAliveClientMixin {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  String searchQuery = '';
  bool _permissionDenied = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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

  void filterContacts(String query) {
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
      final phoneLower = contact.phones.isNotEmpty
          ? contact.phones.first.number.replaceAll(RegExp(r'[^\d]'), '')
          : '';

      // Check if any search term matches name or phone
      return searchTerms.any((term) =>
      nameLower.contains(term) ||
          (phoneLower.isNotEmpty && phoneLower.contains(term))
      );
    }).toList();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (query) => filterContacts(query),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search by name or mobile number',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_permissionDenied)
              const Center(
                  child: Text(
                    'Permission denied. Please allow contact access in settings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  )
              ),
            if (_isLoading)
              const Center(
                  child: CircularProgressIndicator()
              ),
            if (!_permissionDenied && !_isLoading) Expanded(
              child: filteredContacts.isEmpty
                  ? Center(
                  child: Text(
                    searchQuery.isEmpty
                        ? 'No contacts found'
                        : 'No contacts matching "$searchQuery"',
                    style: const TextStyle(color: Colors.grey),
                  )
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  final phoneNumber = contact.phones.isNotEmpty
                      ? formatPhoneNumber(contact.phones.first.number)
                      : 'No phone number';
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: ListTile(
                      onTap: () {
                        if (contact.phones.isNotEmpty) {
                          widget.onContactSelected(
                              contact.displayName,
                              contact.phones.first.number
                          );
                        }
                      },
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: contact.photo != null
                            ? ClipOval(
                          child: Image.memory(
                            contact.photo!,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ),
                        )
                            : const Icon(Icons.person, color: Colors.grey),
                      ),
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white70
                        ),
                      ),
                      subtitle: Text(
                        phoneNumber,
                        style: const TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}