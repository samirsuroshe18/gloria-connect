import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/guard_entry/widgets/custom_continue_button.dart';
import 'package:gloria_connect/features/guard_entry/widgets/custom_pin_code_field.dart';
import 'package:gloria_connect/features/guard_entry/widgets/custom_text_form_field.dart';
import 'package:gloria_connect/features/guard_entry/widgets/profile_image_picker.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/document_picker_utils.dart';
import 'package:gloria_connect/utils/media_picker_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/company_tile.dart';
import '../widgets/more_option_tile.dart';
import '../widgets/vehicle_option.dart';

class OtherApprovalProfile extends StatefulWidget {
  final String? mobNumber;
  final String? categoryOption;
  const OtherApprovalProfile({super.key, this.mobNumber, this.categoryOption});

  @override
  State<OtherApprovalProfile> createState() => _OtherApprovalProfileState();
}

class _OtherApprovalProfileState extends State<OtherApprovalProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otherPhoneController = TextEditingController();
  TextEditingController otherNameController = TextEditingController();
  final TextEditingController otherVehicleNumberController = TextEditingController();
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
  int? _selectedCompanyIndex;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    otherPhoneController.text = widget.mobNumber ?? '';

    switch (widget.categoryOption) {
      case "Maid":
        _selectedCompanyIndex = 0;
        serviceName = 'Maid';
        serviceLogo = 'assets/images/other/cleaning.png';
        break;
      case "Laundry":
        _selectedCompanyIndex = 1;
        serviceName = 'Laundry';
        serviceLogo = 'assets/images/other/laundry.png';
        break;
      case "Milkman":
        _selectedCompanyIndex = 2;
        serviceName = 'Milkman';
        serviceLogo = 'assets/images/other/milkman.png';
        break;
      case "Gas":
        _selectedCompanyIndex = 3;
        serviceName = 'Gas';
        serviceLogo = 'assets/images/other/propane_tank.png';
        break;
    }
  }


  @override
  void dispose() {
    otherPhoneController.dispose();
    otherNameController.dispose();
    otherVehicleNumberController.dispose();
    super.dispose();
  }

  void selectVehicle(String vehicle) {
    setState(() {
      otherVehicleNumberController.clear();
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
      CustomSnackBar.show(context: context, message: 'Error picking image: $e', type: SnackBarType.error);
    }
  }

  void _selectCompany(int index, String compName, String logo) {
    setState(() {
      _selectedCompanyIndex = index;
      serviceName = compName;
      serviceLogo = logo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Services',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listener: (context, state) {
          if (state is CheckInGetNumberSuccess) {
            profileData = state.response;
            if (mounted) {
              otherNameController.text = state.response['name'] ?? '';
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
                          _companyDetails(),
                          const SizedBox(height: 20),
                          _vehicleDetails()
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
                controller: otherPhoneController,
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
                controller: otherNameController,
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

  Widget _companyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Coming From (Service)',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          childAspectRatio: 0.9,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            CompanyTile(
              companyName:
                  otherServiceName != null ? otherServiceName! : 'Maid',
              logo: otherServiceLogo != null
                  ? otherServiceLogo!
                  : 'assets/images/other/cleaning.png',
              isSelected: _selectedCompanyIndex == 0,
              onTap: () => _selectCompany(
                  0,
                  otherServiceName != null ? otherServiceName! : 'Maid',
                  otherServiceLogo != null
                      ? otherServiceLogo!
                      : 'assets/images/other/cleaning.png'),
            ),
            CompanyTile(
              companyName: 'Laundry',
              logo: 'assets/images/other/laundry.png',
              isSelected: _selectedCompanyIndex == 1,
              onTap: () => _selectCompany(
                  1, 'Plumber', 'assets/images/other/plumber.png'),
            ),
            CompanyTile(
              companyName: 'Milkman',
              logo: 'assets/images/other/milkman.png',
              isSelected: _selectedCompanyIndex == 2,
              onTap: () => _selectCompany(
                  2, 'Milkman', 'assets/images/other/milkman.png'),
            ),
            CompanyTile(
              companyName: 'Gas',
              logo: 'assets/images/other/propane_tank.png',
              isSelected: _selectedCompanyIndex == 3,
              onTap: () =>
                  _selectCompany(3, 'Cook', 'assets/images/other/cook.png'),
            ),
            CompanyTile(
              companyName: 'Housekeeping',
              logo: 'assets/images/other/housekeeping.png',
              isSelected: _selectedCompanyIndex == 4,
              onTap: () => _selectCompany(
                  4, 'Housekeeping', 'assets/images/other/housekeeping.png'),
            ),
            MoreOptionsTile(
              onTap: _onMorePressed,
            ),
          ],
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
        if (selectedVehicle == 'Two Wheeler' ||
            selectedVehicle == 'Four Wheeler')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Vehicle Number.',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white70),
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

  Future<void> _onMorePressed() async {
    final result = await Navigator.pushNamed(context, '/other-more-option');

    if (result is Map<String, dynamic>) {
      setState(() {
        serviceName = null;
        serviceLogo = null;
        _selectedCompanyIndex = 0;
        otherServiceName = result['name'];
        otherServiceLogo = result['logo'];
      });
    }
  }

  Future<void> _onContinuePress() async {

    if (_formKey.currentState!.validate()) {
      profileData['name'] = otherNameController.text;
      profileData['mobNumber'] = otherPhoneController.text;
      profileData['profileImg'] = _image ?? profileData['profileImg'];
      profileData['serviceName'] = serviceName ?? otherServiceName;
      profileData['serviceLogo'] = serviceLogo ?? otherServiceLogo;
      profileData['entryType'] = 'other';
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
      } else if (profileData['serviceName'] == null) {
        if (mounted) {
          CustomSnackBar.show(context: context, message: 'Please select the service', type: SnackBarType.error);
        }
        return;
      }
      if (mounted) {
        Navigator.pushNamed(context, '/ask-other-approval', arguments: profileData);
      }
    }
  }
}
