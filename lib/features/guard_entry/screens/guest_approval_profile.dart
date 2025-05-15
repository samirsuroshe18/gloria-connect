import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/guard_entry/widgets/custom_continue_button.dart';
import 'package:gloria_connect/features/guard_entry/widgets/custom_pin_code_field.dart';
import 'package:gloria_connect/features/guard_entry/widgets/custom_text_form_field.dart';
import 'package:gloria_connect/features/guard_entry/widgets/guest_selector.dart';
import 'package:gloria_connect/features/guard_entry/widgets/profile_image_picker.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/document_picker_utils.dart';
import 'package:gloria_connect/utils/media_picker_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/vehicle_option.dart';

class GuestApprovalProfile extends StatefulWidget {
  final String? mobNumber;
  const GuestApprovalProfile({super.key, this.mobNumber});

  @override
  State<GuestApprovalProfile> createState() => _GuestApprovalProfileState();
}

class _GuestApprovalProfileState extends State<GuestApprovalProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController guestPhoneController = TextEditingController();
  TextEditingController guestNameController = TextEditingController();
  final TextEditingController guestVehicleNumberController = TextEditingController();
  String? otherServiceLogo;
  String? otherServiceName;
  String? serviceName;
  String? serviceLogo;
  File? _image;
  String? selectedVehicle = 'No Vehicle';
  String? vehicleNo;
  String? societyName;
  String? gateName;
  Map<String, dynamic> profileData = {};
  int accompanyingGuests = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    guestPhoneController.text = widget.mobNumber ?? '';
  }

  @override
  void dispose() {
    guestPhoneController.dispose();
    guestNameController.dispose();
    guestVehicleNumberController.dispose();
    super.dispose();
  }

  void selectVehicle(String vehicle) {
    setState(() {
      guestVehicleNumberController.clear();
      selectedVehicle = vehicle;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final File? image = await MediaPickerHelper.pickImageFile(context: context, source: source);

      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(context: context, message: 'Error picking image: $e', type: SnackBarType.error);
    }
  }

  String getGuestText() {
    if (accompanyingGuests == 0) {
      return 'No Additional Guest';
    } else if (accompanyingGuests == 1) {
      return '1 Guest';
    } else {
      return '$accompanyingGuests Guests';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Entry',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listener: (context, state) {
          if (state is CheckInGetNumberSuccess) {
            profileData = state.response;
            if (mounted) {
              guestNameController.text = state.response['name'] ?? '';
            }
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _profileDetails(),
                          const SizedBox(height: 20),
                          GuestSelector(
                            guestCount: accompanyingGuests,
                            onIncrement: () {
                              setState(() {
                                accompanyingGuests++;
                              });
                            },
                            onDecrement: () {
                              setState(() {
                                accompanyingGuests--;
                              });
                            },
                            guestTextBuilder: getGuestText,
                          ),
                          const SizedBox(height: 20),
                          _vehicleDetails(),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomContinueButton(
                  onPressed: _onContinuePress,
                  label: 'Continue',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _profileDetails() {
    return Row(
      children: [
        ProfileImagePicker(
          localImage: _image,
          networkImageUrl: profileData['profileImg'].runtimeType == String ? profileData['profileImg']: null,
          onPickImage: () {
            DocumentPickerUtils.showDocumentPickerSheet(
              context: context,
              onPickImage: _pickImage,
              onPickPDF: null,
              isOnlyImage: true,
            );
          },
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: guestPhoneController,
                hintText: 'Enter Phone Number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 10) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: guestNameController,
                hintText: 'Enter Name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _vehicleDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              onTap: () => selectVehicle('No Vehicle'),
              label: 'No Vehicle',
              icon: Icons.cancel,
              isSelected: selectedVehicle == 'No Vehicle',
            ),
            VehicleOption(
              onTap: () => selectVehicle('Two Wheeler'),
              label: 'Two Wheeler',
              icon: Icons.motorcycle,
              isSelected: selectedVehicle == 'Two Wheeler',
            ),
            VehicleOption(
              onTap: () => selectVehicle('Four Wheeler'),
              label: 'Four Wheeler',
              icon: Icons.directions_car,
              isSelected: selectedVehicle == 'Four Wheeler',
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (selectedVehicle == 'Two Wheeler' || selectedVehicle == 'Four Wheeler')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Vehicle Number.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              CustomPinCodeField(
                appContext: context,
                length: 4,
                onChanged: (code) {
                  vehicleNo = code;
                },
                onCompleted: (code) {
                  vehicleNo = code;
                },
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _onContinuePress() async {

    if (_formKey.currentState!.validate()) {
      profileData['name'] = guestNameController.text;
      profileData['mobNumber'] = guestPhoneController.text;
      profileData['profileImg'] = _image ?? profileData['profileImg'];
      profileData['entryType'] = 'guest';
      profileData['accompanyingGuest'] = accompanyingGuests.toString();
      profileData['vehicleType'] = selectedVehicle;
      profileData['vehicleNo'] = vehicleNo;

      if (selectedVehicle != 'No Vehicle' && (vehicleNo == null || vehicleNo!.length < 4)) {
        if (mounted) {
          CustomSnackBar.show(context: context, message: 'Enter vehicle number', type: SnackBarType.error);
        }
        return;
      } else if (_image == null && profileData['profileImg'] == null) {
        if (mounted) {
          CustomSnackBar.show(context: context, message: 'Please take image', type: SnackBarType.error);
        }
        return;
      }
      if (mounted) {
        Navigator.pushNamed(context, '/ask-guest-approval', arguments: profileData);
      }
    }
  }
}
