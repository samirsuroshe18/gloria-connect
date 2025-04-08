import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/administration/bloc/administration_bloc.dart';
import 'package:gloria_connect/features/administration/models/society_member.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class AllAdminScreen extends StatefulWidget {
  const AllAdminScreen({super.key,});

  @override
  State<AllAdminScreen> createState() => _AllAdminScreenState();
}

class _AllAdminScreenState extends State<AllAdminScreen> {
  List<SocietyMember> data = [];
  List<SocietyMember> filteredAdmin = [];
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
    context.read<AdministrationBloc>().add(AdminGetSocietyAdmin());
  }

  void _filterAdmin(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAdmin = data;
      } else {
        filteredAdmin = data
            .where((data) =>
        data.user!.userName!.toLowerCase().contains(query.toLowerCase()) ||
            data.user!.phoneNo!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Society Admin',
            style: TextStyle(color: Colors.white,),
          ),
          backgroundColor: Colors.black.withOpacity(0.2),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: _filterAdmin,
                decoration: InputDecoration(
                  hintText: 'Search by name or mobile number',
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
          ),
        ),
        body: BlocConsumer<AdministrationBloc, AdministrationState>(
          listener: (context, state){
            if (state is AdminGetSocietyAdminLoading) {
              _isLoading = true;
              _isError = false;
            }
            if (state is AdminGetSocietyAdminSuccess) {
              _isLoading = false;
              _isError = false;
              data = state.response;
              filteredAdmin = data;
            }
            if (state is AdminGetSocietyAdminFailure) {
              _isLoading = false;
              _isError = true;
              filteredAdmin = [];
              statusCode = state.status;
            }
            if (state is AdminRemoveAdminSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response['message']!),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is AdminRemoveAdminFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state){
            if(filteredAdmin.isNotEmpty && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _refreshUserData,  // Method to refresh user data
                child: ListView.builder(
                  itemCount: filteredAdmin.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  itemBuilder: (context, index) {
                    final member = filteredAdmin[index];
                    return Card(
                      color: Colors.black.withOpacity(0.2),
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
                            if (value == 'remove') {
                              _removeAdmin(member.user?.email ?? "");
                            } else if(value == 'call'){
                              _makePhoneCall(member.user?.phoneNo ?? "");
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'remove',
                              child: Row(
                                children: [
                                  Icon(Icons.person_remove, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Remove Admin'),
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
            } else if (filteredAdmin.isEmpty && _isError == true && statusCode == 401) {
              return RefreshIndicator(
                onRefresh: _refreshUserData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height - (kToolbarHeight*2),
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
                    height: MediaQuery.of(context).size.height - (kToolbarHeight*2),
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
                          "There are no admin",
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
    context.read<AdministrationBloc>().add(AdminGetSocietyAdmin());
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _removeAdmin(String email) async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Revoke Admin Privileges', style: TextStyle(color: Colors.red)),
          content: const Text('Are you sure you want to revoke admin privileges from this user? They will lose access to admin-level features and permissions.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AdministrationBloc, AdministrationState>(
              builder: (context, state) {
                if (state is AdminRemoveAdminLoading) {
                  return const CircularProgressIndicator(color: Colors.red,);
                } else if (state is AdminRemoveAdminFailure) {
                  return TextButton(
                    child: const Text('Revoke', style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(AdminRemoveAdmin(email: email));
                    },
                  );
                }else if (state is AdminRemoveAdminSuccess) {
                  onPressed(){
                    context.read<AdministrationBloc>().add(AdminGetSocietyAdmin());
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Revoke', style: TextStyle(color: Colors.red)),
                  );
                } else {
                  return TextButton(
                    child: const Text('Revoke', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      context.read<AdministrationBloc>().add(
                        AdminRemoveAdmin(email: email),
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

  // Future<void> _removeAdmin(String email) async {
  //   if(!mounted) return;
  //
  //   showDialog(context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Revoke Admin Privileges', style: TextStyle(color: Colors.red)),
  //         content: const Text('Are you sure you want to revoke admin privileges from this user? They will lose access to admin-level features and permissions.'),
  //         actions: [
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           BlocBuilder<AdministrationBloc, AdministrationState>(
  //             builder: (context, state) {
  //               if (state is AdminRemoveAdminLoading) {
  //                 return const CircularProgressIndicator();
  //               } else if (state is AdminRemoveAdminFailure) {
  //                 return TextButton(
  //                   child: const Text('Revoke', style: TextStyle(color: Colors.red),),
  //                   onPressed: () {
  //                     context.read<AdministrationBloc>().add(AdminRemoveAdmin(email: email));
  //                   },
  //                 );
  //               }else if (state is AdminRemoveAdminSuccess) {
  //                 onPressed(){
  //                   context.read<AdministrationBloc>().add(AdminGetSocietyAdmin());
  //                   Navigator.of(context).pop();
  //                 }
  //                 return TextButton(
  //                   onPressed: onPressed(),
  //                   child: const Text('Revoke', style: TextStyle(color: Colors.red)),
  //                 );
  //               } else {
  //                 return TextButton(
  //                   child: const Text('Revoke', style: TextStyle(color: Colors.red)),
  //                   onPressed: () {
  //                     context.read<AdministrationBloc>().add(
  //                       AdminRemoveGuard(id: email),
  //                     );
  //                   },
  //                 );
  //               }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
