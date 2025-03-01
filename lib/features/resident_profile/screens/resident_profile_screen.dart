import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/models/get_user_model.dart';

class ResidentProfileScreen extends StatefulWidget {
  const ResidentProfileScreen({super.key});

  @override
  State<ResidentProfileScreen> createState() => _ResidentProfileScreenState();
}

class _ResidentProfileScreenState extends State<ResidentProfileScreen> {
  late SharedPreferences _prefs;
  GetUserModel? data;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    if(!mounted) return;
    context.read<AuthBloc>().add(AuthGetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthGetUserLoading) {
            _isLoading = true;
          }
          if (state is AuthGetUserSuccess) {
            _isLoading = false;
            data = state.response;
          }
          if (state is AuthGetUserFailure) {
            _isLoading = false;
          }
        },
        builder: (context, state) {
          if(data != null && _isLoading == false) {
            return RefreshIndicator(
              onRefresh: _refreshUserData,  // Method to refresh user data
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: data?.profile == null
                                  ? const AssetImage('assets/images/profile.png')
                                  : NetworkImage(data!.profile!),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              data?.userName ?? "NA",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data?.email ?? "NA",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit-profile-screen', arguments: data);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18)
                              ),
                              child: const Text(
                                'Edit profile',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1F0FF),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color(0xFFE1E1E1), // Border color
                            width: 2, // Border width
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: const Icon(
                                      Icons.door_sliding_outlined,
                                      color: Color(0xFF5B5B5B),
                                    )),
                                title: Text(
                                  'Block ${data?.societyBlock?.toUpperCase() ?? "NA"}, Apartment ${data?.apartment ?? "NA"}',
                                  style: const TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Divider(height: 2),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: const Icon(
                                      Icons.lock,
                                      color: Color(0xFF5B5B5B),
                                    )),
                                title: Text(
                                  'Passcode : ${data?.checkInCode ?? "NA"}',
                                  style: const TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Divider(height: 2),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: const Icon(
                                      Icons.group,
                                      color: Color(0xFF5B5B5B),
                                    )),
                                title: const Text(
                                  'Apartment Members',
                                  style: TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Color(0xFF5B5B5B),),
                                onTap: () {
                                  Navigator.pushNamed(context, '/apartment-member-screen');
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Divider(height: 2),
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: ListTile(
                                leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: const Icon(
                                      Icons.settings,
                                      color: Color(0xFF5B5B5B),
                                    )),
                                title: const Text(
                                  'Settings',
                                  style: TextStyle(color: Color(0xFF272727), fontWeight: FontWeight.w500),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Color(0xFF5B5B5B),),
                                onTap: () {
                                  Navigator.pushNamed(context, '/setting-screen',);
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Divider(height: 2),
                            ),
                            ListTile(
                              leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: const Color(0x2FB74343),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: const Icon(
                                    Icons.logout,
                                    color: Color(0xFFAD3232),
                                  )),
                              title: const Text(
                                'Logout',
                                style: TextStyle(color: Color(0xFFB74343), fontWeight: FontWeight.w500),
                              ),
                              onTap: _logoutUser,
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
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
          }else {
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
          }
        },
      ),
    );
  }

  Future<void> _refreshUserData() async {
    context.read<AuthBloc>().add(AuthGetUser());
  }

  Future<void> _logoutUser() async {
    if(!mounted) return;

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLogoutLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthLogoutFailure) {
                  return TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                    },
                  );
                }else if (state is AuthLogoutSuccess) {
                  onPressed(){
                    removeAccessToken();
                    Navigator.of(context).pop();
                  }
                  return TextButton(
                    onPressed: onPressed(),
                    child: const Text('Logout'),
                  );
                } else {
                  return TextButton(
                    child: const Text('Logout'),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        AuthLogout(),
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

  Future<void> removeAccessToken() async {
    await _prefs.remove("accessToken");
    await _prefs.remove("refreshMode");

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
  }
}
