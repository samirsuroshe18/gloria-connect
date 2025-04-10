import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/utils/staggered_list_animation.dart';
import 'package:lottie/lottie.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../administration/models/admin_complaint_model.dart';

class ComplaintScreen extends StatefulWidget {
  final GetUserModel? data;
  final bool? isAdmin;
  const ComplaintScreen({super.key, this.data, this.isAdmin = false});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> with SingleTickerProviderStateMixin {
  List<ComplaintModel> data = [];
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;
  User? user;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<ComplaintModel> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    widget.isAdmin == true
        ? context.read<AdministrationBloc>().add(AdminGetComplaint())
        : context.read<SettingBloc>().add(SettingGetComplaint());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterComplaints(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = data;
      } else {
        _filteredData = data
            .where((complaint) =>
        complaint.category!.toLowerCase().contains(query.toLowerCase()) ||
            complaint.description!.toLowerCase().contains(query.toLowerCase()) ||
            complaint.complaintId!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  List<ComplaintModel> _getFilteredComplaints(String status) {
    return _filteredData.where((complaint) => complaint.status == status).toList();
  }

  Future<void> _raiseComplaint(BuildContext context) async {
    final data = await Navigator.pushNamed(context, '/complaint-form-screen');
    if(data is Map<String, dynamic>){
      setState(() {
        _filteredData.add(ComplaintModel.fromJson(data));
      });
    }
  }

  Future<void> _cardOnTap(ComplaintModel complaint) async {
    Map<String, dynamic> args = {'id': complaint.id,};

    var result = await Navigator.pushNamed(
      context,
      '/complaint-details-screen',
      arguments: args,
    );

    if (result is ComplaintModel) {
      setState(() {
        int index = data.indexWhere((item) => item.complaintId == complaint.complaintId);
        if (index != -1) {
          data[index] = result;
          _filterComplaints(_searchController.text);
        }
      });
    }
  }

  Widget _buildComplaintCard(ComplaintModel complaint) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _cardOnTap(complaint),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '#${complaint.complaintId}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  _buildStatusChip(complaint.status ?? 'pending'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                complaint.category ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70
                ),
              ),
              const SizedBox(height: 8),
              Text(
                complaint.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.white60),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(complaint.date!),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.comment_outlined, size: 16, color: Colors.white60),
                      const SizedBox(width: 4),
                      Text(
                        '${complaint.responses?.length ?? 0}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                      if (complaint.review != null && complaint.review! > 0) ...[
                        const SizedBox(width: 16),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          complaint.review.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        displayText = 'Pending';
        break;
      case 'resolved':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        displayText = 'Resolved';
        break;
      case 'in_progress':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade900;
        displayText = 'In Progress';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade900;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterComplaints,
                  decoration: InputDecoration(
                    hintText: 'Search complaints...',
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.white60,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.blue,
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'Resolved'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<AdministrationBloc, AdministrationState>(
        listener: (context, state) {
          if (state is AdminGetComplaintLoading) {
            _isLoading = true;
            _isError = false;
          }
          if (state is AdminGetComplaintSuccess) {
            data = state.response.complaints!
                .map((e) => ComplaintModel.fromJson(e.toJson()))
                .toList();
            _filteredData = data;
            user = state.response.user!;
            _isLoading = false;
            _isError = false;
          }
          if (state is AdminGetComplaintFailure) {
            data = [];
            _filteredData = [];
            _isLoading = false;
            _isError = true;
            statusCode = state.status;
          }
        },
        builder: (context, state) {
          return BlocConsumer<SettingBloc, SettingState>(
            listener: (context, state) {
              if (state is SettingGetComplaintLoading) {
                _isLoading = true;
                _isError = false;
              }
              if (state is SettingGetComplaintSuccess) {
                data = state.response;
                _filteredData = data;
                _isLoading = false;
                _isError = false;
              }
              if (state is SettingGetComplaintFailure) {
                data = [];
                _filteredData = [];
                _isLoading = false;
                _isError = true;
                statusCode = state.status;
              }
            },
            builder: (context, state) {
              if (_isLoading) {
                return Center(
                  child: Lottie.asset(
                    'assets/animations/loader.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                );
              }

              if (_isError && statusCode == 401) {
                return _buildTabBarViewWithContent(_buildErrorState);
              }

              return TabBarView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  _filteredData.isEmpty ? _buildEmptyState() : _buildComplaintList(_getFilteredComplaints('pending')),
                  _filteredData.isEmpty ? _buildEmptyState() : _buildComplaintList(_getFilteredComplaints('resolved')),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _raiseComplaint(context),
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white70),
        label: const Text(
          'New Complaint',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildTabBarViewWithContent(Widget Function() contentBuilder) {
    return TabBarView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _tabController,
      children: [
        contentBuilder(),
        contentBuilder(),
      ],
    );
  }

  Widget _buildComplaintList(List<ComplaintModel> complaints) {
    return complaints.isEmpty
        ? _buildEmptyState()
        : RefreshIndicator(
      onRefresh: _onRefresh,
      child: AnimationLimiter(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: complaints.length,
          padding: const EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) => StaggeredListAnimation(index: index, child: _buildComplaintCard(complaints[index])),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/no_data.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  "No complaints found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 200,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/error.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Something went wrong!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    widget.isAdmin == true
        ? context.read<AdministrationBloc>().add(AdminGetComplaint())
        : context.read<SettingBloc>().add(SettingGetComplaint());
  }
}