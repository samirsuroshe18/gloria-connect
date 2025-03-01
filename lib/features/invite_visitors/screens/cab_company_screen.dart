import 'package:flutter/material.dart';

class CabCompanyScreen extends StatefulWidget {
  const CabCompanyScreen({super.key});

  @override
  State<CabCompanyScreen> createState() => _CabCompanyScreenState();
}

class _CabCompanyScreenState extends State<CabCompanyScreen> {
  TextEditingController searchController = TextEditingController();
  final TextEditingController name = TextEditingController();
  List<Map<String, String>> filteredCab = [];
  final List<Map<String, String>> cab = [
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
    filteredCab = cab;
    searchController.addListener(_filterCab);
  }

  void _filterCab() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCab = cab.where((company) {
        final companyName = company['name']!.toLowerCase();
        return companyName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCab);
    searchController.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Cab', style: TextStyle(color: Colors.white, fontSize: 20)),
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
                controller: searchController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                  hintText: 'Search Cab...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Expanded list of companies
            Expanded(
              child: ListView.builder(
                itemCount: filteredCab.length,
                itemBuilder: (context, index) {
                  final cab = filteredCab[index];
                  final image = cab['image'];
                  final name = cab['name'] ?? '';
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
                          if (cab['name'] == 'Other') {
                            _showOtherCabDialog(context, image);  // Use modal bottom sheet approach
                            // _navigateToOtherCompanyScreen(context);  // Use navigation approach
                          } else {
                            // Handle tap for predefined companies
                            Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'cab', 'image': image, 'companyName': name});
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

  void _showOtherCabDialog(BuildContext context, String image) {
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
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Enter cab service name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'cab', 'image': image, 'companyName': name.text});
                    },
                    child: const Text('Next'),
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
