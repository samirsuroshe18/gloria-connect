import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/common_widgets/staggered_list_animation.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_pre_approve_card.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_search_field.dart';
import 'package:gloria_connect/features/invite_visitors/widgets/custom_service_dialog.dart';

class DeliveryCompanyScreen extends StatefulWidget {
  const DeliveryCompanyScreen({super.key});

  @override
  State<DeliveryCompanyScreen> createState() => _DeliveryCompanyScreenState();
}

class _DeliveryCompanyScreenState extends State<DeliveryCompanyScreen> {
  TextEditingController searchController = TextEditingController();
  final TextEditingController name = TextEditingController();
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
    searchController.addListener(_filterCompanies);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCompanies);
    searchController.dispose();
    name.dispose();
    super.dispose();
  }

  void _filterCompanies() {
    final query = searchController.text.toLowerCase();
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
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomSearchField(
            controller: searchController,
            hintText: 'Search Companies...',
          ),
        ),
      ),
      body: AnimationLimiter(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: filteredCompanies.length,
          itemBuilder: (context, index) {
            final company = filteredCompanies[index];
            final image = company['image'];
            final name = company['name'] ?? '';
            return StaggeredListAnimation(index: index, child: CustomPreApproveCard(name: name, image: image!, onTap: ()=>_onCardTap(company, image, name)));
          },
        ),
      ),
    );
  }

  void _onCardTap(Map<String, dynamic> company, String image, String name) {
    if (company['name'] == 'Other') {
      _showOtherCompanyDialog(context, image);
    } else {
      Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'delivery', 'image': image, 'companyName': name});
    }
  }

  void _showOtherCompanyDialog(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomServiceDialog(
          labelText: 'Enter delivery service name',
          image: image,
          nameController: name,
          onNext: () {
            Navigator.pushNamed(context, '/contact-screen', arguments: {'profileType': 'delivery', 'image': image, 'companyName': name.text,},);
          },
        );
      },
    );
  }
}
