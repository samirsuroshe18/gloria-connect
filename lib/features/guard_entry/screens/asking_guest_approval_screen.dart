import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/guard_entry/widgets/apartment_list_row.dart';
import 'package:gloria_connect/features/guard_entry/widgets/build_header.dart';
import 'package:gloria_connect/features/guard_entry/widgets/entry_type_tag.dart';
import 'package:gloria_connect/features/guard_entry/widgets/profile_image_avatar.dart';
import 'package:gloria_connect/features/guard_entry/widgets/read_only_pincode_field.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import '../bloc/guard_entry_bloc.dart';
import '../widgets/ask_approval_btn.dart';
import '../widgets/vehicle_option.dart';

class AskingGuestApprovalScreen extends StatefulWidget {
  final Map<String, dynamic>? deliveryData;

  const AskingGuestApprovalScreen({super.key, this.deliveryData});

  @override
  State<AskingGuestApprovalScreen> createState() => _AskingGuestApprovalScreenState();
}

class _AskingGuestApprovalScreenState extends State<AskingGuestApprovalScreen> {
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
        backgroundColor: Colors.black.withValues(alpha: 0.2),
      ),
      body: BlocListener<GuardEntryBloc, GuardEntryState>(
        listener: (context, state){
          if(state is AddDeliveryEntryLoading){
            setState(() {
              _isLoading = true;
            });
          }
          if (state is AddDeliveryEntrySuccess) {
            CustomSnackBar.show(context: context, message: state.response['message'], type: SnackBarType.success);
            setState(() {
              _isLoading = false;
            });
            context.read<CheckInBloc>().add(ClearFlat());
            Navigator.pushNamedAndRemoveUntil(context, '/guard-home', (Route<dynamic> route) => false);
          }
          if (state is AddDeliveryEntryFailure) {
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
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
        AskApprovalBtn(isLoading: _isLoading, onTap: _askForApproval),
      ],
    );
  }

  Widget _buildDeliveryCard() {
    return Card(
      color: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileImageAvatar(
              imageSource: widget.deliveryData?['profileImg'],
            ),
            const SizedBox(width: 16),
            _buildDeliveryInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildHeader(title: widget.deliveryData?['name'] ?? 'NA', onEditTap: () => Navigator.of(context).pop()),
          EntryTypeTag(text: widget.deliveryData?['entryType'] ?? 'NA'),
          const SizedBox(height: 12),
          _buildAccompanyingGuest(),
          const SizedBox(height: 8),
          ApartmentListRow(
            apartments: societyApartments,
          ),
        ],
      ),
    );
  }

  Widget _buildAccompanyingGuest() {
    return Text(
      'Accomp. Guest: ${widget.deliveryData?['accompanyingGuest']} Guest',
        style: const TextStyle(fontSize: 16, color: Colors.white70)
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
        ReadOnlyPinCodeField(
          initialValue: widget.deliveryData?['vehicleNo'] ?? '',
          context: context,
        ),
      ],
    );
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
      accompanyingGuest: widget.deliveryData?['accompanyingGuest'],
      companyName: widget.deliveryData?['companyName'],
      companyLogo: widget.deliveryData?['companyLogo'],
      vehicleType: widget.deliveryData?['vehicleType'],
      vehicleNumber: widget.deliveryData?['vehicleNo'],
      entryType: widget.deliveryData?['entryType'],
      societyName: widget.deliveryData?['societyName'],
      societyApartments: societyApartments,
      societyGates: widget.deliveryData?['gateName'],
    ));
  }
}
