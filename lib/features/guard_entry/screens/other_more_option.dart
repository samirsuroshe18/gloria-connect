import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';

class OtherMoreOption extends StatefulWidget {
  final bool? isAddService;
  const OtherMoreOption({super.key, this.isAddService = false,});

  @override
  State<OtherMoreOption> createState() => _OtherMoreOptionState();
}

class _OtherMoreOptionState extends State<OtherMoreOption> {
  TextEditingController otherSearchController = TextEditingController();
  final TextEditingController otherServiceName = TextEditingController();
  List<Map<String, String>> filteredServices = [];
  final List<Map<String, String>> services = [
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
    otherSearchController.addListener(_filterCompanies);
  }

  @override
  void dispose() {
    otherSearchController.removeListener(_filterCompanies);
    otherSearchController.dispose();
    otherServiceName.dispose();
    super.dispose();
  }

  void _filterCompanies() {
    final query = otherSearchController.text.toLowerCase();
    setState(() {
      filteredServices = services.where((company) {
        final companyName = company['name']!.toLowerCase();
        return companyName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Company', style: TextStyle(color: Colors.white70, fontSize: 20)),
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar with more padding and enhanced UI
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: otherSearchController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  hintText: 'Search Services...',
                  hintStyle: TextStyle(color: Colors.white60),
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Expanded list of companies
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredServices[index];
                    final image = service['image'];
                    final name = service['name'] ?? '';
                    return StaggeredListAnimation(index: index, child: Card(
                      color: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
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
                          trailing: const Icon(Icons.chevron_right, color: Colors.white70),
                          onTap: () {
                            if (service['name'] == 'Other') {
                              _showOtherCompanyDialog(context, image);
                            } else if (widget.isAddService == true) {
                              Navigator.pop(context, {'logo': image, 'name': name});
                            } else {
                              Navigator.pop(context, {'logo': image, 'name': name});
                              // Navigator.pushReplacementNamed(context, '/delivery-approval-profile', arguments: {'logo': image, 'name': name});
                            }
                          },
                        ),
                      ),
                    ));
                  },
                ),
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
          backgroundColor: Colors.deepPurple,
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
                    controller: otherServiceName,
                    decoration: InputDecoration(
                      labelText: 'Enter other service name',
                      border: const OutlineInputBorder(),
                      labelStyle: const TextStyle(color: Colors.white70),
                      fillColor: Colors.white.withOpacity(0.2)
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    onPressed: () {
                      if(otherServiceName.text.isEmpty){
                        CustomSnackbar.show(context: context, message: 'This field is required', type: SnackbarType.error);
                        return;
                      }
                      Navigator.pop(context); // Close the dialog
                      if (widget.isAddService == true) {
                      Navigator.pop(context, {'logo': image, 'name': otherServiceName.text});
                      }else{
                        Navigator.pop(context, {'logo': image, 'name': otherServiceName.text});
                      }
                      // Navigator.pushReplacementNamed(context, '/delivery-approval-profile', arguments: {'logo': image, 'name': name.text});
                    },
                    child: const Text('Submit', style: TextStyle(color: Colors.white),),
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
