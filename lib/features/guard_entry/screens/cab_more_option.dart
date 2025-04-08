import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';

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
        title: const Text('Select Company', style: TextStyle(color: Colors.white70, fontSize: 20)),
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
                controller: cabMoreSearchController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  hintText: 'Search Companies...',
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
                  itemCount: filteredCompanies.length,
                  itemBuilder: (context, index) {
                    final company = filteredCompanies[index];
                    final image = company['image'];
                    final name = company['name'] ?? '';
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
                            if (company['name'] == 'Other') {
                              _showOtherCompanyDialog(context, image);
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
                    controller: cabOtherCompanyName,
                    decoration: InputDecoration(
                      labelText: 'Enter other cab service name',
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
                      if(cabOtherCompanyName.text.isEmpty){
                        CustomSnackbar.show(context: context, message: 'This field is required', type: SnackbarType.error);
                        return;
                      }
                      Navigator.pop(context); // Close the dialog
                      Navigator.pop(context, {'logo': image, 'name': cabOtherCompanyName.text});
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
