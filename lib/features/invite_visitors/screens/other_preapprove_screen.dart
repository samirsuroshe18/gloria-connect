import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_pre_approve_card.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_search_field.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_service_dialog.dart';

class OtherPreapproveScreen extends StatefulWidget {
  const OtherPreapproveScreen({super.key});

  @override
  State<OtherPreapproveScreen> createState() => _OtherPreapproveScreenState();
}

class _OtherPreapproveScreenState extends State<OtherPreapproveScreen> {
  TextEditingController searchController = TextEditingController();
  final TextEditingController name = TextEditingController();
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
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomSearchField(
            controller: searchController,
            hintText: 'Search other services...',
          ),
        ),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filteredServices.length,
          itemBuilder: (context, index) {
            final service = filteredServices[index];
            final image = service['image'];
            final name = service['name'] ?? '';
            return StaggeredListAnimation(index: index, child: CustomPreApproveCard(name: name, image: image!, onTap: ()=>_onCardTap(service, image, name)));
          },
        ),
      ),
    );
  }

  void _onCardTap(Map<String, dynamic> service, String image, String name) {
    if (service['name'] == 'Other') {
      _showOtherServiceDialog(context, image);
    } else {
      Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'other', 'image': image, 'companyName': name});
    }
  }

  void _showOtherServiceDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomServiceDialog(
          labelText: 'Enter other service name.',
          image: image,
          nameController: name,
          onNext: () {
            Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'other', 'image': image, 'companyName': name.text});
          },
        );
      },
    );
  }
}
