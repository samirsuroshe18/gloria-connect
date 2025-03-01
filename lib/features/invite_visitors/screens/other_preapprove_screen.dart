import 'package:flutter/material.dart';

class OtherPreapproveScreen extends StatefulWidget {
  const OtherPreapproveScreen({super.key});

  @override
  State<OtherPreapproveScreen> createState() => _OtherPreapproveScreenState();
}

class _OtherPreapproveScreenState extends State<OtherPreapproveScreen> {
  TextEditingController searchController = TextEditingController();
  final TextEditingController name = TextEditingController();
  List<Map<String, dynamic>> filteredServices = [];
  final List<Map<String, dynamic>> services = [
    {'name': 'Maid', 'image': 'assets/images/other/cleaning.png'},
    {'name': 'Cook', 'image': 'assets/images/other/cook.png'},
    {'name': 'Driver', 'image': 'assets/images/other/driver.png'},
    {'name': 'Doctor', 'image': 'assets/images/other/doctor.png'},
    {'name': 'Gardener', 'image': 'assets/images/other/gardner_staff.png'},
    {'name': 'Nanny', 'image': 'assets/images/other/nanny.png'},
    {'name': 'Milkman', 'image': 'assets/images/other/milkman.png'},
    {'name': 'Newspaper', 'image': 'assets/images/other/newspaper.png'},
    {'name': 'Water Tanker', 'image': 'assets/images/other/water_tank.png'},
    {'name': 'Laundry', 'image': 'assets/images/other/laundry.png'},
    {'name': 'Car Cleaner', 'image': 'assets/images/other/car_wash.png'},
    {'name': 'Tuition Teacher', 'image': 'assets/images/other/teacher.png'},
    {'name': 'Electrician', 'image': 'assets/images/other/electrician.png'},
    {'name': 'Plumber', 'image': 'assets/images/other/plumber.png'},
    {'name': 'Gym Instructor', 'image': 'assets/images/other/gym_instructor.png'},
    {'name': 'Yoga Instructor', 'image': 'assets/images/other/yoga.png'},
    {'name': 'Sports Teacher', 'image': 'assets/images/other/sports_teacher.png'},
    {'name': 'STP Operator(Staff)', 'image': 'assets/images/other/stp.png'},
    {'name': 'Housekeeping', 'image': 'assets/images/other/housekeeping.png'},
    {'name': 'Carpenter', 'image': 'assets/images/other/carpenter.png'},
    {'name': 'Pest Control', 'image': 'assets/images/other/paste_control.png'},
    {'name': 'Pet Walker', 'image': 'assets/images/other/pet_walker.png'},
    {'name': 'Tennis Coach', 'image': 'assets/images/other/tennis_coach.png'},
    {'name': 'Makeup Artist', 'image': 'assets/images/other/makeup.png'},
    {'name': 'Painting Company(Staff)', 'image': 'assets/images/other/painting_staff.png'},
    {'name': 'Medical Staff', 'image': 'assets/images/other/medical_staff.png'},
    {'name': 'AC Service', 'image': 'assets/images/other/ac.png'},
    {'name': 'Blood Test', 'image': 'assets/images/other/blood_test.png'},
    {'name': 'Staff', 'image': 'assets/images/other/staff.png'},
    {'name': 'Other', 'image': 'assets/images/other/more_options.png'},
  ];

  @override
  void initState() {
    super.initState();
    filteredServices = services;
    searchController.addListener(_filterCab);
  }

  void _filterCab() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredServices = services.where((company) {
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
        title: const Text('Select services', style: TextStyle(color: Colors.white, fontSize: 20)),
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
                  hintText: 'Search other services...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Expanded list of companies
            Expanded(
              child: ListView.builder(
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  final service = filteredServices[index];
                  final image = service['image'];
                  final name = service['name'] ?? '';
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
                          if (service['name'] == 'Other') {
                            _showOtherServiceDialog(context, image);  // Use modal bottom sheet approach
                            // _navigateToOtherCompanyScreen(context);  // Use navigation approach
                          } else {
                            // Handle tap for predefined companies
                            Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'other', 'image': image, 'companyName': name});
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

  void _showOtherServiceDialog(BuildContext context, String image) {
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
                      labelText: 'Enter other service name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'other', 'image': image, 'companyName': name.text});
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
