import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/guard_entry/bloc/guard_entry_bloc.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchUser() {
    if(mounted) context.read<AuthBloc>().add(AuthGetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<GuardEntryBloc, GuardEntryState>(
        listener: (context, state) {
          if (state is CheckInByCodeLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is CheckInByCodeSuccess) {
            if(mounted)_handleSuccess(state.response['message']);
            if(mounted)_pinController.clear();
            setState(() {
              _isLoading = false;
            });
          } else if (state is CheckInByCodeFailure) {
            if(mounted)_handleError(state.message);
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(mounted)
                  _buildCheckInSection(),
                const SizedBox(height: 30),
                _build3DLine(),
                const SizedBox(height: 30),
                if(mounted)
                  _buildCategorySection(),
              ],
            ),
          ),
        ),
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
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              _showSnackBar("This feature is under development", Colors.blueGrey);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xff448EE4),
    );
  }

  _clearPinCode() {
    if(mounted){
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
            Icon(Icons.phone_android, size: 30, color: Color(0xff448EE4)),
            SizedBox(width: 10),
            Text('Check-in by Code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Enter verification code', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            TextButton(onPressed: _clearPinCode, child: const Text('Clear'))
          ],
        ),
        const SizedBox(height: 10),
        if(mounted)
        _buildOTPFields(context),
        const SizedBox(height: 20),
        _buildSubmitButton(),
      ],
    );
  }

  ElevatedButton _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_otp != null && _otp!.length == 6) { // Validate length
          context.read<GuardEntryBloc>().add(CheckInByCode(checkInCode: _otp!));
        } else {
          _showSnackBar("Enter a valid check-in code", Colors.redAccent);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff448EE4),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        shadowColor: Colors.blueGrey.shade200,
      ),
      child: Center(
        child: _isLoading
            ? CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          backgroundColor: Colors.grey[200],
          strokeWidth: 5.0,)
            : const Text('SUBMIT', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Container _build3DLine() {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade600, Colors.grey.shade300]),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: const Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 0.5,
          ),
        ],
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
      onChanged: (code) {
        setState(() {
          _otp = code;
        });
      },
      onCompleted: (verificationCode) {
        setState(() {
          _otp = verificationCode;
        });
      },
      pinTheme: PinTheme(
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
        fieldWidth: MediaQuery.of(context).size.width * 0.12, // Responsive width
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
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 8,
          color: Colors.black.withOpacity(0.1),
        ),
      ],
      cursorColor: Colors.blue,
      animationType: AnimationType.fade,
      animationDuration: const Duration(milliseconds: 300),
      enablePinAutofill: true,
      backgroundColor: Colors.transparent,
      textStyle: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.05, // Responsive font size
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Column _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Check-in without Code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text('Pick by category', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _buildCategoryGrid(),
      ],
    );
  }

  GridView _buildCategoryGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _buildCategoryItem(Icons.delivery_dining, 'Delivery', _onCategoryTap),
        _buildCategoryItem(Icons.person, 'Guest', _onCategoryTap),
        _buildCategoryItem(Icons.local_taxi, 'Cab', _onCategoryTap),
        _buildCategoryItem(Icons.miscellaneous_services, 'Others', _onCategoryTap),
      ],
    );
  }

  InkWell _buildCategoryItem(IconData icon, String title, Function(String) onTap) {
    return InkWell(
      onTap: () => onTap(title),
      child: Column(
        children: [
          Material(
            elevation: 8,
            shape: const CircleBorder(),
            shadowColor: Colors.blueGrey.shade200,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xff448EE4),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _onCategoryTap(String category) {
    context.read<CheckInBloc>().add(ClearFlat());
    if(mounted)_navigator?.pushNamed('/block-selection-screen', arguments: {'entryType': category.toLowerCase()},);
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
}

