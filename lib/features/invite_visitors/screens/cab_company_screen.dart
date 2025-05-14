import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_pre_approve_card.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_search_field.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_service_dialog.dart';

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
        backgroundColor: Colors.black.withOpacity(0.2),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomSearchField(
            controller: searchController,
            hintText: 'Search Cab...',
          ),
        ),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filteredCab.length,
          itemBuilder: (context, index) {
            final cab = filteredCab[index];
            final image = cab['image'];
            final name = cab['name'] ?? '';
            return StaggeredListAnimation(index: index, child: CustomPreApproveCard(name: name, image: image!, onTap: ()=>_onCardTap(cab, image, name)),);
          },
        ),
      ),
    );
  }

  void _onCardTap(Map<String, String> cab, String image, String name) {
    if (cab['name'] == 'Other') {
      _showOtherCabDialog(context, image);
    } else {
      Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'cab', 'image': image, 'companyName': name});
    }
  }

  void _showOtherCabDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomServiceDialog(
          labelText: 'Enter cab service name',
          image: image,
          nameController: name,
          onNext: () {
            Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'cab', 'image': image, 'companyName': name.text});
          },
        );
      },
    );
  }
}
