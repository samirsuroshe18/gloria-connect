import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/resident_profile/widgets/build_action_button.dart';
import 'package:gloria_connect/features/resident_profile/widgets/build_resident_info_tile.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
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
              onRefresh: _refreshUserData,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Profile Header Section
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                CustomCachedNetworkImage(
                                  imageUrl: data?.profile,
                                  isCircular: true,
                                  size: 100,
                                  errorImage: Icons.person,
                                  onTap: () => CustomFullScreenImageViewer.show(context, data?.profile),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  data?.userName ?? "NA",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data?.email ?? "NA",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/admin-edit-profile-screen',
                                      arguments: data,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                    foregroundColor: Colors.white70,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Edit Profile'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Resident Details Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Residence Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                BuildResidentInfoTile(
                                  icon: Icons.apartment,
                                  label: 'Block & Apartment',
                                  value: 'Block ${data?.societyBlock?.toUpperCase() ?? "NA"}, Apartment ${data?.apartment ?? "NA"}',
                                ),
                                const Divider(height: 24),
                                BuildResidentInfoTile(
                                  icon: Icons.password,
                                  label: 'Passcode',
                                  value: data?.checkInCode ?? "NA",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Actions Grid
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Quick Actions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                BuildActionButton(
                                  title: 'Apartment Members',
                                  icon: Icons.group_outlined,
                                  color: const Color(0xFF4A90E2),
                                  onTap: () => Navigator.pushNamed(context, '/apartment-member-screen'),
                                ),
                                const SizedBox(height: 12),
                                BuildActionButton(
                                  title: 'Settings',
                                  icon: Icons.settings_outlined,
                                  color: Colors.white60,
                                  onTap: () => Navigator.pushNamed(context, '/setting-screen', arguments: data),
                                ),
                                const SizedBox(height: 12),
                                BuildActionButton(
                                  title: 'Logout',
                                  icon: Icons.logout,
                                  color: const Color(0xFFE63946),
                                  onTap: _logoutUser,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (_isLoading) {
            return const CustomLoader();
          } else {
            return BuildErrorState(onRefresh: _refreshUserData);
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
    CustomSnackBar.show(context: context, message: 'Logged out', type: SnackBarType.success);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
  }
}
