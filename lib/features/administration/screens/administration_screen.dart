import 'package:flutter/material.dart';
import 'package:gloria_connect/features/administration/widgets/build_admin_menu_item.dart';
import 'package:gloria_connect/features/administration/widgets/quick_action_card.dart';

class AdministrationScreen extends StatefulWidget {
  const AdministrationScreen({super.key});

  @override
  State<AdministrationScreen> createState() => _AdministrationScreenState();
}

class _AdministrationScreenState extends State<AdministrationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        centerTitle: true,
        title: const Text(
          'Administration',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const BuildAdminMenuItem(),
          const QuickActionCard(),
        ],
      ),
    );
  }
}

