import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
import 'package:gloria_connect/features/guard_duty/widgets/custom_dropdown_field.dart';
import 'package:gloria_connect/features/guard_duty/widgets/info_text.dart';
import 'package:gloria_connect/features/guard_duty/widgets/start_duty_button.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

class DutyLoginScreen extends StatefulWidget {
  const DutyLoginScreen({super.key});

  @override
  State<DutyLoginScreen> createState() => _DutyLoginScreenState();
}

class _DutyLoginScreenState extends State<DutyLoginScreen> {
  String? _selectedGate;
  String? checkinReason;
  String? checkinShift;
  bool _isLoading = false;

  // Mock data for gates
  final List<String> _gates = [
    'Ground Floor Entry',
    'Podium Entry'
  ];

  // Mock data for gates
  final List<String> _checkinReasons = [
    '👮‍♂️ Start of scheduled shift',
    '🔄 Swapping shift with another guard',
    '🧹 Cleaning/maintenance duty',
    '⏰ Covering someone’s absence',
    '📝 Manual check-in (forgot earlier)'
  ];

  final List<String> _shifts = ['All Shifts', 'Morning', 'Evening', 'Night'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        title: const Text(
          'Start Duty',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<GuardDutyBloc, GuardDutyState>(
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
      ),
    );
  }
}