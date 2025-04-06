import 'package:flutter/material.dart';

class DeliveryMoreOption extends StatefulWidget {
  const DeliveryMoreOption({super.key});

  @override
  State<DeliveryMoreOption> createState() => _DeliveryMoreOptionState();
}

class _DeliveryMoreOptionState extends State<DeliveryMoreOption> {
  TextEditingController deliveryMoreSearchController = TextEditingController();
  final TextEditingController searchName = TextEditingController();
  List<Map<String, String>> filteredCompanies = [];
  final List<Map<String, String>> companies = [
    {'name': 'Urban Company', 'image': 'assets/images/delivery/urban_company.png'},
    {'name': 'Amazon', 'image': 'assets/images/delivery/amazon_logo.jpeg'},
    {'name': 'Swiggy', 'image': 'assets/images/delivery/swiggy_logo.png'},
    {'name': 'Zomato', 'image': 'assets/images/delivery/zomato_logo.png'},
    {'name': 'BigBasket', 'image': 'assets/images/delivery/big_basket.png'},
    {'name': 'Flipkart', 'image': 'assets/images/delivery/flipkart_logo.png'},
    {'name': 'Snapdeal', 'image': 'assets/images/delivery/snapdeal.png'},
    {'name': 'Myntra', 'image': 'assets/images/delivery/myntra.jpeg'},
    {'name': 'NYKAA', 'image': 'assets/images/delivery/nykaa.png'},
    {'name': 'Meesho', 'image': 'assets/images/delivery/meesho.png'},
    {'name': 'AJIO', 'image': 'assets/images/delivery/ajio.png'},
    {'name': 'Zepto', 'image': 'assets/images/delivery/zepto.jpeg'},
    {'name': 'Blinkit', 'image': 'assets/images/delivery/blinkit.png'},
    {'name': 'Dominos', 'image': 'assets/images/delivery/dominos.png'},
    {'name': 'Ekart', 'image': 'assets/images/delivery/ekart.jpeg'},
    {'name': 'DTDC', 'image': 'assets/images/delivery/dtdc.jpeg'},
    {'name': 'INDIA POST', 'image': 'assets/images/delivery/india_post.png'},
    {'name': 'Box8', 'image': 'assets/images/delivery/box8.png'},
    {'name': 'FoodPanda', 'image': 'assets/images/delivery/food_panda.png'},
    {'name': 'Netmeds', 'image': 'assets/images/delivery/netmeds.png'},
    {'name': 'OlaDash', 'image': 'assets/images/delivery/ola_dash.png'},
    {'name': 'Otipy', 'image': 'assets/images/delivery/otipy.jpeg'},
    {'name': 'PharmEasy', 'image': 'assets/images/delivery/pharm_easy.png'},
    {'name': 'ShopClues', 'image': 'assets/images/delivery/shop_clues.png'},
    {'name': 'Other', 'image': 'assets/images/delivery/other.png'},
  ];

  @override
  void initState() {
    super.initState();
    filteredCompanies = companies;
    deliveryMoreSearchController.addListener(_filterCompanies);
  }

  @override
  void dispose() {
    deliveryMoreSearchController.removeListener(_filterCompanies);
    deliveryMoreSearchController.dispose();
    searchName.dispose();
    super.dispose();
  }

  void _filterCompanies() {
    final query = deliveryMoreSearchController.text.toLowerCase();
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
                controller: deliveryMoreSearchController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  hintText: 'Search Companies...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
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
                    controller: searchName,
                    decoration: const InputDecoration(
                      labelText: 'Enter delivery name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.pop(context, {'logo': image, 'name': searchName.text});
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
