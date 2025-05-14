import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';

class StartDutyButton extends StatelessWidget {
  final String? checkinReason;
  final String? checkinShift;
  final String? selectedGate;
  final Function()? onConfirmed;

  const StartDutyButton({
    super.key,
    required this.checkinReason,
    required this.checkinShift,
    required this.selectedGate,
    this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          if (selectedGate != null && checkinReason != null && checkinShift != null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Check-In'),
                content: Text(
                  'You are about to start duty at $selectedGate for reason:\n\n$checkinReason\n\nDo you want to proceed?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirmed?.call();
                      context.read<GuardDutyBloc>().add(
                        GuardDutyCheckIn(
                          gate: selectedGate!,
                          checkinReason: checkinReason!,
                          shift: checkinShift!,
                        ),
                      );
                    },
                    child: const Text('Start Duty'),
                  ),
                ],
              ),
            );
          } else {
            CustomSnackBar.show(
              context: context,
              message: 'All fields are required',
              type: SnackBarType.error,
            );
          }
        },
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
    );
  }
}
