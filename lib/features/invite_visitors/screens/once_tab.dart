import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../bloc/invite_visitors_bloc.dart';

class OnceTab extends StatefulWidget {
  final Map<String, dynamic>? data;
  const OnceTab({super.key, this.data});

  @override
  State<OnceTab> createState() => _OnceTabState();
}

class _OnceTabState extends State<OnceTab> {
  String? selectedDuration;
  TimeOfDay? selectedTime = TimeOfDay.now();
  DateTime? selectedDate = DateTime.now();
  DateTime? startDate;
  DateTime? endTime;
  DateTime? startTime;
  DateTime? endDate;
  bool _isLoading = false;

  final List<String> durations = ['4 hours', '8 hours', '12 hours', '24 hours'];

  void selectDuration(String duration) {
    setState(() {
      selectedDuration = duration;
      startDate = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, 0, 0, 0);
      endDate = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, 23, 59, 59);
      startTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, selectedTime!.hour, selectedTime!.minute);
      int hours = int.parse(duration.split(' ')[0]);
      endTime = startTime!.add(Duration(hours: hours));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<InviteVisitorsBloc, InviteVisitorsState>(
        listener: (context, state) {
          if (state is AddPreApproveEntryLoading) {
            _isLoading = true;
          }
          if (state is AddPreApproveEntryFailure) {
            _isLoading = false;
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
          }
          if (state is AddPreApproveEntrySuccess) {
            _isLoading = false;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/otp-banner',
              arguments: state.response,
              (route) => route.isFirst,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invite Visitor',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Schedule a visit by selecting date, time and duration',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Date Selection Card
                  _buildSelectionCard(
                    title: 'Visit Date',
                    icon: Icons.calendar_month_rounded,
                    value: selectedDate != null
                        ? DateFormat('EEEE, MMMM d, y').format(selectedDate!)
                        : 'Select Date',
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.blue.shade700,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                  ),

                  // Time Selection Card
                  _buildSelectionCard(
                    title: 'Visit Time',
                    icon: Icons.access_time_rounded,
                    value: selectedTime != null
                        ? selectedTime!.format(context)
                        : 'Select Time',
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.blue.shade700,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (time != null) {
                        setState(() => selectedTime = time);
                      }
                    },
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Pass Duration',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Duration Selection Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: durations.length,
                    itemBuilder: (context, index) {
                      final duration = durations[index];
                      final isSelected = selectedDuration == duration;

                      return InkWell(
                        onTap: () => selectDuration(duration),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade700.withOpacity(0.2)
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.grey.shade300
                                  : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              duration,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white60,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Pre-approve Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                        if (selectedDate != null &&
                            selectedTime != null &&
                            selectedDuration != null) {
                          context
                              .read<InviteVisitorsBloc>()
                              .add(AddPreApproveEntry(
                            name: widget.data?['name'],
                            mobNumber: widget.data?['number'],
                            profileImg: widget.data?['profileImg'],
                            companyName: widget.data?['companyName'],
                            companyLogo: widget.data?['companyLogo'],
                            serviceName: widget.data?['serviceName'],
                            serviceLogo: widget.data?['serviceLogo'],
                            vehicleNumber: widget.data?['vehicleNo'],
                            entryType: widget.data?['profileType'],
                            checkInCodeStartDate:
                            startDate!.toIso8601String(),
                            checkInCodeExpiryDate:
                            endDate!.toIso8601String(),
                            checkInCodeStart:
                            startTime!.toIso8601String(),
                            checkInCodeExpiry:
                            endTime!.toIso8601String(),
                          ));
                        } else {
                          CustomSnackBar.show(context: context, message: 'Please select date, time and pass duration', type: SnackBarType.error);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        'Pre-approve Visit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                            color: Colors.white70
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white70,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}