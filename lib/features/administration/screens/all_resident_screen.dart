import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/society_member.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';


class AllResidentScreen extends StatefulWidget {
  const AllResidentScreen({super.key,});

  @override
  State<AllResidentScreen> createState() => _AllResidentScreenState();
}

class _AllResidentScreenState extends State<AllResidentScreen> {
  List<SocietyMember> data = [];
  List<SocietyMember> filteredResidents = [];
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
    context.read<AdministrationBloc>().add(AdminGetSocietyMember());
  }

  void filterResidents(String query) {
    final filtered = data.where((data) {
      final nameLower = data.user?.userName?.toLowerCase() ?? '';
      final phoneLower = data.user?.phoneNo?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          phoneLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredResidents = filtered;
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Society Members',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyMemberLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is AdminGetSocietyMemberSuccess) {
              _isLoading = false;
              _isError = false;
              data = state.response;
              filteredResidents = data;
            }
            if (state is AdminGetSocietyMemberFailure) {
              _isLoading = false;
              _isError = true;
              filteredResidents = [];
              statusCode = state.status;
            }
            if (state is AdminCreateAdminSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response['message']!),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is AdminCreateAdminFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
            if (state is AdminRemoveResidentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response['message']!),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is AdminRemoveResidentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state){
            if(filteredResidents.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _refreshUserData,  // Method to refresh user data
                child: Column(
                  children: [
                    TextField(
                      onChanged: (query) => filterResidents(query),
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
                        itemCount: filteredResidents.length,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        itemBuilder: (context, index) {
                          final member = filteredResidents[index];
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
                                    _deleteResident(member.user?.id ?? "");
                                  } else if (value == 'makeAdmin') {
                                    _makeAdmin(member.user?.email ?? "");
                                  }else if(value == 'call'){
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
                                        Text('Delete Resident'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'makeAdmin',
                                    child: Row(
                                      children: [
                                        Icon(Icons.person_add, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('Make Admin'),
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
            } else if (filteredResidents.isEmpty && _isError == true && statusCode == 401) {
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
                          "There are no residents.",
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
    context.read<AdministrationBloc>().add(AdminGetSocietyMember());
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makeAdmin(String email) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Promote User to Admin'),
          content: const Text('Are you sure you want to grant admin privileges to this user? Admins have elevated permissions to manage the system.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminCreateAdminLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AdminCreateAdminFailure) {
                  return TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminCreateAdmin(email: email));
                    },
                  );
                }else if (state is AdminCreateAdminSuccess) {
                  onPressed(){
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Confirm'),
                  );
                } else {
                  return TextButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(
                        AdminCreateAdmin(email: email),
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

  Future<void> _deleteResident(String id) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Resident', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to delete this resident? This action cannot be undone and will remove all associated data.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminRemoveResidentLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AdminRemoveResidentFailure) {
                  return TextButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveResident(id: id));
                    },
                  );
                }else if (state is AdminRemoveResidentSuccess) {
                  onPressed(){
                    context.read<AdministrationBloc>().add(AdminGetSocietyMember());
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
                      context.read<AdministrationBloc>().add(AdminRemoveResident(id: id));
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
