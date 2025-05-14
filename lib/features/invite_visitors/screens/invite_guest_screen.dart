import 'package:flutter/material.dart';
import 'package:gloria_connect/features/invite_visitors/screens/frequently_tab.dart';
import 'package:gloria_connect/features/invite_visitors/screens/once_tab.dart';

class InviteGuestScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const InviteGuestScreen({super.key, this.data});

  @override
  State<InviteGuestScreen> createState() => _InviteGuestScreenState();
}

class _InviteGuestScreenState extends State<InviteGuestScreen> with SingleTickerProviderStateMixin {
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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Guest', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black.withOpacity(0.2),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Once'),
              Tab(text: 'Frequently'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            OnceTab(data: widget.data,),
            FrequentlyTab(data: widget.data,),
          ],
        ),
      ),
    );
  }
}
