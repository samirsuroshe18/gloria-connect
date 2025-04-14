import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/guard_duty/bloc/guard_duty_bloc.dart';
import 'package:gloria_connect/features/guard_entry/bloc/guard_entry_bloc.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/notification_service.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../check_in/bloc/check_in_bloc.dart';

class GuardEntryScreen extends StatefulWidget {
  const GuardEntryScreen({super.key});

  @override
  State<GuardEntryScreen> createState() => _GuardEntryScreenState();
}

class _GuardEntryScreenState extends State<GuardEntryScreen> {
  final TextEditingController _pinController = TextEditingController();
  NavigatorState? _navigator;
  String _gateName = '...';
  String _guardName = '...';
  String? _otp;
  bool _isLoading = false;
  bool _isCheckoutLoading = false;
  ReceivedAction? initialAction;

  // Checkout reasons
  final List<String> _checkoutReasons = [
    '✅ End of scheduled shift',
    '🔁 Handing over shift',
    '🛠 Emergency exit',
    '📝 Manual check-out (forgot earlier)',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }

  void getInitialAction() async {
    initialAction = NotificationController.initialAction;
    if (mounted) {
      if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'NOTIFY_NOTICE_CREATED') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/notice-board-details-screen', (route) => route.isFirst,
            arguments: NoticeBoardModel.fromJson(jsonDecode(initialAction!.payload!['data']!)));
      } else if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'NOTIFY_COMPLAINT_CREATED') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/complaint-details-screen', (route) => route.isFirst,
            arguments: jsonDecode(initialAction!.payload!['data']!));
      } else if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'NOTIFY_RESIDENT_REPLIED') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/complaint-details-screen', (route) => route.isFirst,
            arguments: jsonDecode(initialAction!.payload!['data']!));
      } else if (initialAction != null &&
          jsonDecode(initialAction!.payload!['data']!)['action'] == 'NOTIFY_ADMIN_REPLIED') {
        Navigator.pushNamedAndRemoveUntil(
            context, '/complaint-details-screen', (route) => route.isFirst,
            arguments: jsonDecode(initialAction!.payload!['data']!));
      } else {
        context.read<AuthBloc>().add(AuthGetUser());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getInitialAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<GuardDutyBloc, GuardDutyState>(
        listener: (context, state){
          if(state is GuardDutyCheckOutLoading){
            _isCheckoutLoading = true;
          }
          if(state is GuardDutyCheckOutSuccess){
            _isCheckoutLoading = false;
            CustomSnackbar.show(context: context, message: "Your Duty is finished!", type: SnackbarType.success);
            Navigator.pushReplacementNamed(context, '/duty-login');
          }
          if(state is GuardDutyCheckOutFailure){
            CustomSnackbar.show(context: context, message: state.message, type: SnackbarType.error);
          }
        },
        builder: (context, state){
          return BlocListener<GuardEntryBloc, GuardEntryState>(
            listener: (context, state) {
              if (state is CheckInByCodeLoading) {
                setState(() {
                  _isLoading = true;
                });
              } else if (state is CheckInByCodeSuccess) {
                if (mounted) _handleSuccess(state.response['message']);
                if (mounted) _pinController.clear();
                setState(() {
                  _isLoading = false;
                });
              } else if (state is CheckInByCodeFailure) {
                if (mounted) _handleError(state.message);
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, authState) {
                if (authState is AuthGetUserSuccess) {
                  setState(() {
                    _gateName = authState.response.gateAssign ?? 'NA';
                    _guardName = authState.response.userName ?? 'NA';
                  });
                }
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mounted) _buildCheckInSection(),
                        const SizedBox(height: 30),
                        _build3DLine(),
                        const SizedBox(height: 30),
                        if (mounted) _buildCategorySection(),
                        const SizedBox(height: 30),
                        _buildEndDutyButton(),
                      ],
                    ),
                  ),
                  if (_isCheckoutLoading)
                    Center(
                      child: Lottie.asset(
                        'assets/animations/loader.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    )
                ]
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${_gateName.toUpperCase()}  $_guardName',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white70,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white70),
            onPressed: () {
              Navigator.pushNamed(context, '/general-notice-board-screen');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0.2),
    );
  }

  _clearPinCode() {
    if (mounted) {
      setState(() {
        _pinController.clear();
        _otp = null;
      });
    }
  }

  Column _buildCheckInSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.phone_android, size: 30, color: Colors.white70),
            SizedBox(width: 10),
            Text('Check-in by Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Enter verification code',
                style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold)),
            TextButton(
                onPressed: _clearPinCode,
                child: const Text('Clear', style: TextStyle(color: Colors.white60))),
          ],
        ),
        const SizedBox(height: 10),
        if (mounted) _buildOTPFields(context),
        const SizedBox(height: 20),
        _buildSubmitButton(),
      ],
    );
  }

  ElevatedButton _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_otp != null && _otp!.length == 6) {
          context.read<GuardEntryBloc>().add(CheckInByCode(checkInCode: _otp!));
        } else {
          _showSnackBar("Enter a valid check-in code", Colors.redAccent);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff448EE4),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Center(
        child: _isLoading
            ? CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          backgroundColor: Colors.grey[200],
          strokeWidth: 5.0,
        )
            : const Text('SUBMIT',
            style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Container _build3DLine() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade600, Colors.grey.shade300]),
      ),
    );
  }

  PinCodeTextField _buildOTPFields(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: _pinController,
      length: 6,
      keyboardType: TextInputType.number,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onChanged: (code) => _otp = code,
      onCompleted: (verificationCode) => _otp = verificationCode,
      pinTheme: PinTheme(
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
        fieldWidth: MediaQuery.of(context).size.width * 0.12,
        shape: PinCodeFieldShape.box,
        borderWidth: 2,
        activeColor: Colors.blue,
        inactiveColor: Colors.grey.shade300,
        selectedColor: Colors.lightBlueAccent,
        activeFillColor: Colors.blue.shade50,
        inactiveFillColor: Colors.white,
        selectedFillColor: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      boxShadows: [
        BoxShadow(offset: const Offset(0, 4), blurRadius: 8, color: Colors.black.withOpacity(0.1)),
      ],
      cursorColor: Colors.white70,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
      enablePinAutofill: true,
      backgroundColor: Colors.transparent,
      textStyle: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.white70,
      ),
    );
  }

  Column _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Check-in without Code',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70)),
        const SizedBox(height: 10),
        const Text('Pick by category',
            style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _buildCategoryGrid(),
      ],
    );
  }

  GridView _buildCategoryGrid() {
    final categories = [
      {'icon': Icons.cleaning_services, 'title': 'Maid'},
      {'icon': Icons.delivery_dining, 'title': 'Delivery'},
      {'icon': Icons.person, 'title': 'Guest'},
      {'icon': Icons.local_laundry_service, 'title': 'Laundry'},
      {'icon': Icons.local_drink, 'title': 'Milkman'},
      {'icon': Icons.propane_tank, 'title': 'Gas'},
      {'icon': Icons.local_taxi, 'title': 'Cab'},
      {'icon': Icons.miscellaneous_services, 'title': 'Other'},
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryItem(
            categories[index]['icon'] as IconData, categories[index]['title'] as String, _onCategoryTap);
      },
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, Function(String) onTap) {
    return InkWell(
      onTap: () => onTap(title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: Colors.transparent,
              elevation: 8,
              shape: const CircleBorder(),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(icon, size: 25, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.white60),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCategoryTap(String category) {
    context.read<CheckInBloc>().add(ClearFlat());
    if (mounted) {
      _navigator?.pushNamed(
        '/block-selection-screen',
        arguments: {
          'entryType': category == 'Maid' || category == 'Laundry' || category == 'Milkman' || category == 'Gas'
              ? 'other'
              : category.toLowerCase(),
          'categoryOption': category,
        },
      );
    }
  }

  void _handleSuccess(String message) {
    _showSnackBar(message, Colors.green);
  }

  void _handleError(String message) {
    _showSnackBar(message, Colors.redAccent);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Widget _buildEndDutyButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _showEndDutyDialog,
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'End Duty',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
        ),
      ),
    );
  }

  void _showEndDutyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedReason; // move inside here
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Reason for Ending Duty'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: _checkoutReasons.map((reason) {
                  return RadioListTile<String>(
                    title: Text(reason),
                    value: reason,
                    groupValue: selectedReason,
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedReason != null
                      ? () {
                    Navigator.pop(context);
                    _handleEndDuty(selectedReason!);
                  }
                      : null,
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleEndDuty(String reason) {
    context.read<GuardDutyBloc>().add(GuardDutyCheckOut(checkoutReason: reason));
  }
}
