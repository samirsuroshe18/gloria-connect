import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../bloc/invite_visitors_bloc.dart';

class FrequentlyTab extends StatefulWidget {
  final Map<String, dynamic>? data;

  const FrequentlyTab({super.key, this.data});

  @override
  State<FrequentlyTab> createState() => _FrequentlyTabState();
}

class _FrequentlyTabState extends State<FrequentlyTab> {
  DateTime? currentStartDate;
  DateTime? currentEndDate;
  TimeOfDay? currentStartTime;
  TimeOfDay? currentEndTime;
  String? selectedPeriod;

  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  bool _isLoading = false;

  final List<Map<String, dynamic>> periods = [
    {'label': '1 week', 'days': 7},
    {'label': '15 days', 'days': 15},
    {'label': '1 month', 'days': 30},
    {'label': 'Custom', 'days': null},
  ];

  void _setDatesBasedOnSelection(int? days, String label) {
    setState(() {
      selectedPeriod = label;
      if (days != null) {
        currentStartDate = DateTime.now();
        currentEndDate = currentStartDate!.add(Duration(days: days));
      } else {
        currentStartDate = null;
        currentEndDate = null;
      }
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
          if (state is AddPreApproveEntrySuccess) {
            _isLoading = false;
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/otp-banner',
              arguments: state.response,
              (route) => route.isFirst,
            );
          }
          if (state is AddPreApproveEntryFailure) {
            _isLoading = false;
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Frequent Visitor Pass',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Set up recurring access for regular visitors',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 32),

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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: periods.length,
                      itemBuilder: (context, index) {
                        final period = periods[index];
                        final isSelected = selectedPeriod == period['label'];

                        return InkWell(
                          onTap: () => _setDatesBasedOnSelection(
                            period['days'],
                            period['label'],
                          ),
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
                                period['label'],
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
                    const SizedBox(height: 32),

                    // Date Selection
                    _buildSelectionCard(
                      title: 'Start Date',
                      icon: Icons.calendar_month_rounded,
                      value: currentStartDate != null
                          ? DateFormat('EEEE, MMMM d, y')
                              .format(currentStartDate!)
                          : 'Select Start Date',
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: currentStartDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
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
                          setState(() => currentStartDate = date);
                        }
                      },
                    ),

                    _buildSelectionCard(
                      title: 'End Date',
                      icon: Icons.calendar_month_rounded,
                      value: currentEndDate != null
                          ? DateFormat('EEEE, MMMM d, y')
                              .format(currentEndDate!)
                          : 'Select End Date',
                      onTap: () async {
                        if (currentStartDate == null) {
                          _showError('Please select start date first');
                          return;
                        }
                        final date = await showDatePicker(
                          context: context,
                          initialDate: currentEndDate ??
                              currentStartDate!.add(const Duration(days: 1)),
                          firstDate: currentStartDate!,
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
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
                          setState(() => currentEndDate = date);
                        }
                      },
                    ),

                    // Time Selection
                    _buildSelectionCard(
                      title: 'Daily Start Time',
                      icon: Icons.access_time_rounded,
                      value: currentStartTime != null
                          ? currentStartTime!.format(context)
                          : 'Select Start Time',
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: currentStartTime ?? TimeOfDay.now(),
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
                          setState(() => currentStartTime = time);
                        }
                      },
                    ),

                    _buildSelectionCard(
                      title: 'Daily End Time',
                      icon: Icons.access_time_rounded,
                      value: currentEndTime != null
                          ? currentEndTime!.format(context)
                          : 'Select End Time',
                      onTap: () async {
                        if (currentStartTime == null) {
                          _showError('Please select start time first');
                          return;
                        }
                        final time = await showTimePicker(
                          context: context,
                          initialTime: currentEndTime ?? TimeOfDay.now(),
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
                          setState(() => currentEndTime = time);
                        }
                      },
                    ),

                    const SizedBox(height: 40),

                    // Pre-approve Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Pre-approve Frequent Access',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError(String message) {
    CustomSnackBar.show(context: context, message: message, type: SnackBarType.error);
  }

  void _handleSubmit() {
    if (currentStartDate == null ||
        currentEndDate == null ||
        currentStartTime == null ||
        currentEndTime == null) {
      _showError('Please fill in all date and time fields');
      return;
    }

    // Set up the dates
    startDate = DateTime(
      currentStartDate!.year,
      currentStartDate!.month,
      currentStartDate!.day,
      0,
      0,
      0,
    );
    endDate = DateTime(
      currentEndDate!.year,
      currentEndDate!.month,
      currentEndDate!.day,
      23,
      59,
      59,
    );
    startTime = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      currentStartTime!.hour,
      currentStartTime!.minute,
    );
    endTime = DateTime(
      endDate!.year,
      endDate!.month,
      endDate!.day,
      currentEndTime!.hour,
      currentEndTime!.minute,
    );

    // Validate time difference
    int startMinutes = currentStartTime!.hour * 60 + currentStartTime!.minute;
    int endMinutes = currentEndTime!.hour * 60 + currentEndTime!.minute;
    int timeDifference = endMinutes - startMinutes;

    if (timeDifference < 30) {
      _showError('Daily access duration must be at least 30 minutes');
      return;
    }

    // Submit the form
    context.read<InviteVisitorsBloc>().add(AddPreApproveEntry(
          name: widget.data?['name'],
          mobNumber: widget.data?['number'],
          profileImg: widget.data?['profileImg'],
          companyName: widget.data?['companyName'],
          companyLogo: widget.data?['companyLogo'],
          serviceName: widget.data?['serviceName'],
          serviceLogo: widget.data?['serviceLogo'],
          vehicleNumber: widget.data?['vehicleNo'],
          entryType: widget.data?['profileType'],
          checkInCodeStartDate: startDate!.toIso8601String(),
          checkInCodeExpiryDate: endDate!.toIso8601String(),
          checkInCodeStart: startTime!.toIso8601String(),
          checkInCodeExpiry: endTime!.toIso8601String(),
        ));
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
