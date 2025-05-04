import 'package:flutter/material.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/features/setting/screens/pending_complaint_screen.dart';
import 'package:gloria_connect/features/setting/screens/resolved_complaint_screen.dart';

class ComplaintScreen extends StatefulWidget {
  final GetUserModel? data;
  final bool? isAdmin;
  const ComplaintScreen({super.key, this.data, this.isAdmin = false});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        title: const Text(
          "Complaints",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Resolved"),
          ],
        )
      ),
      body: TabBarView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          PendingComplaintScreen(isAdmin: widget.isAdmin),
          ResolvedComplaintScreen(isAdmin: widget.isAdmin),
        ],
      ),
    );
  }
}

