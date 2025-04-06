import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_entry/widgets/ask_approval_btn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import '../bloc/guard_entry_bloc.dart';
import '../widgets/vehicle_option.dart';

class AskingResidentApprovalScreen extends StatefulWidget {
  final Map<String, dynamic>? deliveryData;

  const AskingResidentApprovalScreen({super.key, this.deliveryData});

  @override
  State<AskingResidentApprovalScreen> createState() => _GateEntryScreenState();
}

class _GateEntryScreenState extends State<AskingResidentApprovalScreen> {
  List<Map<String, String>> societyApartments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<CheckInBloc>().add(AddFlat());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gate Entry',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
      body: BlocListener<GuardEntryBloc, GuardEntryState>(
        listener: (context, state) {
          if(state is AddDeliveryEntryLoading){
            setState(() {
              _isLoading = true;
            });
          }
          if (state is AddDeliveryEntrySuccess) {
            _showSnackBar(context, state.response['message'], Colors.green);
            setState(() {
              _isLoading = false;
            });
            context.read<CheckInBloc>().add(ClearFlat());
            Navigator.pushNamedAndRemoveUntil(context, '/guard-home', (Route<dynamic> route) => false);
          }
          if (state is AddDeliveryEntryFailure) {
            _showSnackBar(context, state.message, Colors.redAccent);
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: BlocBuilder<CheckInBloc, CheckInState>(
          builder: (context, state) {
            if (state is FlatState) {
              _mapSelectedFlatsToApartmentList(state.selectedFlats);
            }
            return _buildBodyContent();
          },
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDeliveryCard(),
                if (widget.deliveryData?['vehicleType'] == 'Two Wheeler' || widget.deliveryData?['vehicleType'] == 'Four Wheeler')
                  _buildVehicleDetails(),
              ],
            ),
          ),
        ),
        _buildApprovalButton(),
      ],
    );
  }

  Widget _buildDeliveryCard() {
    return Card(
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileImage(),
            const SizedBox(width: 16),
            _buildDeliveryInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    final profileImg = widget.deliveryData!['profileImg'];
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue, // Border color
          width: 2, // Border width
        ),
      ),
      child: CircleAvatar(
        backgroundImage: profileImg is File ? FileImage(profileImg) : NetworkImage(profileImg) as ImageProvider,
        radius: 45,
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeliveryHeader(),
          _buildEntryTypeTag(),
          const SizedBox(height: 12),
          _buildCompanyRow(),
          const SizedBox(height: 8),
          _buildApartmentList(),
        ],
      ),
    );
  }

  Widget _buildDeliveryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.deliveryData?['name'] ?? 'NA',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white70),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.white70,),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildEntryTypeTag() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        widget.deliveryData!['entryType'].toString().toUpperCase(),
        style: const TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  Widget _buildCompanyRow() {
    return Row(
      children: [
        CircleAvatar(radius: 13, backgroundImage: AssetImage(widget.deliveryData?['companyLogo'] ?? 'assets/images/amazon_log.png')),
        const SizedBox(width: 5),
        Text(widget.deliveryData?['companyName'] ?? 'Company', style: const TextStyle(fontSize: 16, color: Colors.white70)),
      ],
    );
  }

  Widget _buildApartmentList() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.all(5.0), child: Icon(Icons.home, size: 20, color: Colors.white70)),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: societyApartments.map((e) => Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(e['apartment']!, style: const TextStyle(fontSize: 14, color: Colors.white70)))).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Vehicle Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          childAspectRatio: 1.5,
          crossAxisSpacing: 8,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            VehicleOption(
              label: 'No Vehicle',
              icon: Icons.cancel,
              isSelected: widget.deliveryData?['vehicleType'] == 'No Vehicle',
            ),
            VehicleOption(
              label: 'Two Wheeler',
              icon: Icons.motorcycle,
              isSelected: widget.deliveryData?['vehicleType'] == 'Two Wheeler',
            ),
            VehicleOption(
              label: 'Four Wheeler',
              icon: Icons.directions_car,
              isSelected: widget.deliveryData?['vehicleType'] == 'Four Wheeler',
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Vehicle Number',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        PinCodeTextField(
          controller: TextEditingController(text: widget.deliveryData?['vehicleNo']),
          appContext: context,
          length: 4,
          readOnly: true,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          pinTheme: PinTheme(
            fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
            fieldWidth: 50,
            shape: PinCodeFieldShape.box,
            borderWidth: 2,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey.shade300,
            selectedColor: Colors.lightBlueAccent,
            activeFillColor: Colors.blue.shade50, // Light fill for active fields
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.blue.shade100, // Highlight the selected box
            borderRadius: BorderRadius.circular(12), // Rounded corners for a modern look
          ),
          boxShadows: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
          animationType: AnimationType.fade,
          animationDuration: const Duration(milliseconds: 300),
          enablePinAutofill: true, // Allow autofill
          backgroundColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        )
      ],
    );
  }
  
  Widget _buildApprovalButton() {
    return AskApprovalBtn(isLoading: _isLoading, onTap: _askForApproval);
  }

  void _showSnackBar(BuildContext context, String message, Color? color){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color ?? const Color(0xFF323232),
    ));
  }

  void _mapSelectedFlatsToApartmentList(List<String> selectedFlats) {
    societyApartments = selectedFlats.map((item) {
      List<String> parts = item.split(' ');
      return {
        'societyBlock': parts[0],
        'apartment': parts[1],
      };
    }).toList();
  }

  void _askForApproval() {
    context.read<GuardEntryBloc>().add(AddDeliveryEntry(
        name: widget.deliveryData?['name'],
        mobNumber: widget.deliveryData?['mobNumber'],
        profileImg: widget.deliveryData!['profileImg'],
        companyName: widget.deliveryData?['companyName'],
        companyLogo: widget.deliveryData?['companyLogo'],
        vehicleType: widget.deliveryData?['vehicleType'],
        vehicleNumber: widget.deliveryData?['vehicleNo'],
        entryType: widget.deliveryData?['entryType'],
        societyName: widget.deliveryData?['societyName'],
        societyApartments: societyApartments,
        societyGates: widget.deliveryData?['gateName']
    ));
  }
}

