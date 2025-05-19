import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
import 'package:gloria_connect/features/guard_duty/widgets/custom_dropdown_field.dart';
import 'package:gloria_connect/features/guard_duty/widgets/info_text.dart';
import 'package:gloria_connect/features/guard_duty/widgets/start_duty_button.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DutyLoginScreen extends StatefulWidget {
  const DutyLoginScreen({super.key});

  @override
  State<DutyLoginScreen> createState() => _DutyLoginScreenState();
}

class _DutyLoginScreenState extends State<DutyLoginScreen> {
  late SharedPreferences _prefs;
  String? _selectedGate;
  String? checkinReason;
  String? checkinShift;
  bool _isLoading = false;

  final List<String> _gates = [
    'Ground Floor Entry',
    'Podium Entry'
  ];

  final List<String> _checkinReasons = [
    '👮‍♂️ Start of scheduled shift',
    '🔄 Swapping shift with another guard',
    '🧹 Cleaning/maintenance duty',
    '⏰ Covering someone’s absence',
    '📝 Manual check-in (forgot earlier)'
  ];

  final List<String> _shifts = ['All Shifts', 'Morning', 'Evening', 'Night'];

  @override
  void initState(){
    super.initState();
    _initialized();
  }

  Future<void> _initialized() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _logoutUser() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              const Text('Confirm Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLogoutLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthLogoutSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    removeAccessToken();
                  });
                  return const SizedBox.shrink();
                } else {
                  return TextButton(
                    child: Text(
                      'Logout',
                      style:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    onPressed: () => context.read<AuthBloc>().add(AuthLogout()),
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
    CustomSnackBar.show(
      context: context,
      message: "Logged out successfully",
      type: SnackBarType.info,
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        title: const Text(
          'Start Duty',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logoutUser,
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthLoginSuccess){
            Navigator.pushReplacementNamed(context, '/login');
          }
          if(state is AuthLogoutFailure){
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
          }
        },
        builder: (context, state){
          return BlocConsumer<GuardDutyBloc, GuardDutyState>(
            listener: (context, state){
              if(state is GuardDutyCheckInLoading){
                _isLoading = true;
              }
              if(state is GuardDutyCheckInSuccess){
                _isLoading = false;
                Navigator.pushReplacementNamed(context, '/guard-home');
              }
              if(state is GuardDutyCheckInFailure){
                _isLoading = false;
                CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
              }
            },
            builder: (context, state){
              return Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top spacing
                          const SizedBox(height: 40),

                          // Gate Selection Dropdown
                          CustomDropdownFormField(
                            value: _selectedGate,
                            items: _gates,
                            labelText: 'Select Gate',
                            hintText: 'Choose your assigned gate',
                            prefixIcon: Icons.location_on_outlined,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGate = newValue;
                              });
                            },
                          ),

                          // Info text
                          const InfoText(
                            message: 'Please select your assigned gate before starting.',
                          ),
                          const SizedBox(height: 10,),

                          // Reason Selection Dropdown
                          CustomDropdownFormField(
                            value: checkinReason,
                            items: _checkinReasons,
                            labelText: 'Select Reason',
                            hintText: 'Choose your check-in reasons',
                            prefixIcon: Icons.location_on_outlined,
                            onChanged: (newValue) {
                              setState(() {
                                checkinReason = newValue;
                              });
                            },
                          ),

                          // Info text
                          const InfoText(
                            message: 'Please select your reason before check-in.',
                          ),
                          const SizedBox(height: 10,),

                          // Shift Selection Dropdown
                          CustomDropdownFormField(
                            value: checkinShift,
                            items: _shifts,
                            labelText: 'Select Shift',
                            hintText: 'Choose your Shift',
                            prefixIcon: Icons.access_time,
                            onChanged: (String? newValue) {
                              setState(() {
                                checkinShift = newValue;
                              });
                            },
                          ),

                          // Info text
                          const InfoText(
                            message: 'Please select your shift before check-in.',
                          ),

                          // Spacer
                          const Spacer(),

                          // Start Duty Button
                          StartDutyButton(
                            checkinReason: checkinReason,
                            checkinShift: checkinShift,
                            selectedGate: _selectedGate,
                          ),

                          // Bottom spacing
                          SizedBox(height: screenSize.height * 0.08),
                        ],
                      ),
                    ),
                  ),
                  if (_isLoading)
                    const CustomLoader()
                ],
              );
            },
          );
        },
      ),
    );
  }
}