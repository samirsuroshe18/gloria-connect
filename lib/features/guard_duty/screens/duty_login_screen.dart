import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:lottie/lottie.dart';

class DutyLoginScreen extends StatefulWidget {
  const DutyLoginScreen({super.key});

  @override
  State<DutyLoginScreen> createState() => _DutyLoginScreenState();
}

class _DutyLoginScreenState extends State<DutyLoginScreen> {
  String? _selectedGate;
  String? checkinReason;
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Start Duty',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.2),
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
            CustomSnackbar.show(context: context, message: state.message, type: SnackbarType.error);
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
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Gate',
                          labelStyle: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: 'Choose your assigned gate',
                          prefixIcon: Icon(Icons.location_on_outlined, color: Colors.white70),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        value: _selectedGate,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                        items: _gates.map<DropdownMenuItem<String>>((String gate) {
                          return DropdownMenuItem<String>(
                            value: gate,
                            child: Text(gate),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGate = newValue;
                          });
                        },
                      ),

                      // Info text
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 8.0),
                        child: Text(
                          'Please select your assigned gate before starting.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),

                      // Gate Selection Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Reason',
                          labelStyle: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: 'Choose your check-in reasons',
                          prefixIcon: Icon(Icons.location_on_outlined, color: Colors.white70),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                        ),
                        value: checkinReason,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                        items: _checkinReasons.map<DropdownMenuItem<String>>((String gate) {
                          return DropdownMenuItem<String>(
                            value: gate,
                            child: Text(gate),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            checkinReason = newValue;
                          });
                        },
                      ),

                      // Info text
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 8.0),
                        child: Text(
                          'Please select your reason before check-in.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Spacer
                      const Spacer(),

                      // Start Duty Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: (_selectedGate != null && checkinReason != null) ? () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Check-In'),
                                content: Text(
                                  'You are about to start duty at $_selectedGate for reason:\n\n$checkinReason\n\nDo you want to proceed?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.read<GuardDutyBloc>().add(GuardDutyCheckIn(gate: _selectedGate!, checkinReason: checkinReason!));
                                    },
                                    child: const Text('Start Duty'),
                                  ),
                                ],
                              ),
                            );
                          } : null,
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.indigo.withOpacity(0.3),
                            disabledForegroundColor: Colors.white70,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            elevation: 3,
                          ),
                          child: const Text('START DUTY'),
                        ),
                      ),

                      // Bottom spacing
                      SizedBox(height: screenSize.height * 0.08),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Center(
                  child: Lottie.asset(
                    'assets/animations/loader.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}