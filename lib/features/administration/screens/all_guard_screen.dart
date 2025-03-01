import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/society_guard.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class AllGuardScreen extends StatefulWidget {
  const AllGuardScreen({super.key,});

  @override
  State<AllGuardScreen> createState() => _AllGuardScreenState();
}

class _AllGuardScreenState extends State<AllGuardScreen> {
  List<SocietyGuard> data = [];
  List<SocietyGuard> filteredGuards = [];
  String searchQuery = '';
  bool _isLoading = false;
  bool _isError = false;
  int? statusCode;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    if(!mounted) return;
    context.read<AdministrationBloc>().add(AdminGetSocietyGuard());
  }

  void filterGuards(String query) {
    final filtered = data.where((data) {
      final nameLower = data.user?.userName?.toLowerCase() ?? '';
      final phoneLower = data.user?.phoneNo?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          phoneLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredGuards = filtered;
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Society Guards',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyGuardLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is AdminGetSocietyGuardSuccess) {
              _isLoading = false;
              _isError = false;
              data = state.response;
              filteredGuards = data;
            }
            if (state is AdminGetSocietyGuardFailure) {
              _isLoading = false;
              _isError = true;
              filteredGuards = [];
              statusCode = state.status;
            }
            if (state is AdminRemoveGuardSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response['message']!),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is AdminRemoveGuardFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state){
            if(data.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _refreshUserData,  // Method to refresh user data
                child: Column(
                  children: [
                    TextField(
                      onChanged: (query) => filterGuards(query),
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search by name or mobile number',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredGuards.length,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        itemBuilder: (context, index) {
                          final member = filteredGuards[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: (member.user?.profile != null && member.user!.profile!.isNotEmpty)
                                    ? NetworkImage(member.user!.profile!)
                                    : const AssetImage('assets/images/profile.png') as ImageProvider,
                              ),
                              title: Text(
                                member.user?.userName ?? "NA",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(member.user?.phoneNo ?? ""),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _deleteGuard(member.user?.id ?? "");
                                  } else if(value == 'call'){
                                    _makePhoneCall(member.user?.phoneNo ?? "");
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete Guard'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'call',
                                    child: Row(
                                      children: [
                                        Icon(Icons.call, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('Call'),
                                      ],
                                    ),
                                  ),
                                ],
                                icon: const Icon(Icons.more_vert), // Three-dot icon
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (_isLoading) {
              return Center(
                child: Lottie.asset(
                  'assets/animations/loader.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              );
            } else if (filteredGuards.isEmpty && _isError == true && statusCode == 401) {
              return RefreshIndicator(
                onRefresh: _refreshUserData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
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
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshUserData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
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
                          "There are no guards",
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        )
    );
  }

  Future<void> _refreshUserData() async {
    context.read<AdministrationBloc>().add(AdminGetSocietyGuard());
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _deleteGuard(String id) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Guard', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to delete this security guard? This action cannot be undone and will remove all associated data.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminRemoveGuardLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AdminRemoveGuardFailure) {
                  return TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveGuard(id: id));
                    },
                  );
                }else if (state is AdminRemoveGuardSuccess) {
                  onPressed(){
                    context.read<AdministrationBloc>().add(AdminGetSocietyGuard());
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  );
                } else {
                  return TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(
                        AdminRemoveGuard(id: id),
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
