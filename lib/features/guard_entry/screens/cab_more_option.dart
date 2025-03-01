import 'package:flutter/material.dart';

class CabMoreOption extends StatefulWidget {
  const CabMoreOption({super.key});

  @override
  State<CabMoreOption> createState() => _CabMoreOptionState();
}

class _CabMoreOptionState extends State<CabMoreOption> {
  TextEditingController cabMoreSearchController = TextEditingController();
  final TextEditingController cabOtherCompanyName = TextEditingController();
  List<Map<String, String>> filteredCompanies = [];
  final List<Map<String, String>> companies = [
    {'name': 'Ola', 'image': 'assets/images/cab/ola.png'},
    {'name': 'Uber', 'image': 'assets/images/cab/uber.png'},
    {'name': 'Rapido', 'image': 'assets/images/cab/rapido.png'},
    {'name': 'Airport Taxi', 'image': 'assets/images/cab/airport_taxi.png'},
    {'name': 'Meru Cabs', 'image': 'assets/images/cab/meru_cabs.png'},
    {'name': 'Jugnoo', 'image': 'assets/images/cab/jugnoo.png'},
    {'name': 'Utoo', 'image': 'assets/images/cab/utoo.png'},
    {'name': 'Other', 'image': 'assets/images/cab/others.png'},
  ];

  @override
  void initState() {
    super.initState();
    filteredCompanies = companies;
    cabMoreSearchController.addListener(_filterCompanies);
  }

  @override
  void dispose() {
    cabMoreSearchController.removeListener(_filterCompanies);
    cabMoreSearchController.dispose();
    cabOtherCompanyName.dispose();
    super.dispose();
  }

  void _filterCompanies() {
    final query = cabMoreSearchController.text.toLowerCase();
    setState(() {
      filteredCompanies = companies.where((company) {
        final companyName = company['name']!.toLowerCase();
        return companyName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Company', style: TextStyle(color: Colors.white, fontSize: 20)),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar with more padding and enhanced UI
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: cabMoreSearchController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                  hintText: 'Search Companies...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Expanded list of companies
            Expanded(
              child: ListView.builder(
                itemCount: filteredCompanies.length,
                itemBuilder: (context, index) {
                  final company = filteredCompanies[index];
                  final image = company['image'];
                  final name = company['name'] ?? '';
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(image!),
                          radius: 25,
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.blueAccent),
                        onTap: () {
                          if (company['name'] == 'Other') {
                            _showOtherCompanyDialog(context, image);
                          } else {
                            Navigator.pop(context, {'logo': image, 'name': name});
                            // Navigator.pushReplacementNamed(context, '/delivery-approval-profile', arguments: {'logo': image, 'name': name});
                          }
                        },
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

  void _showOtherCompanyDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    image,
                    height: 100, // adjust as needed
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: cabOtherCompanyName,
                    decoration: const InputDecoration(
                      labelText: 'Enter other cab service name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.pop(context, {'logo': image, 'name': cabOtherCompanyName.text});
                      // Navigator.pushReplacementNamed(context, '/delivery-approval-profile', arguments: {'logo': image, 'name': name.text});
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
