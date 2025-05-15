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

class DeliveryApprovalProfile extends StatefulWidget {
  final String? mobNumber;
  const DeliveryApprovalProfile({super.key, this.mobNumber});

  @override
  State<DeliveryApprovalProfile> createState() =>
      _DeliveryApprovalProfileState();
}

class _DeliveryApprovalProfileState extends State<DeliveryApprovalProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController deliveryPhoneController = TextEditingController();
  final TextEditingController deliveryNameController = TextEditingController();
  final TextEditingController deliveryVehicleNumberController = TextEditingController();
  String? otherCompanyLogo;
  String? otherCompanyName;
  String? companyName;
  String? companyLogo;
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
    deliveryPhoneController.text = widget.mobNumber ?? '';
  }

  @override
  void dispose() {
    deliveryPhoneController.dispose();
    deliveryNameController.dispose();
    super.dispose();
  }

  void selectVehicle(String vehicle) {
    setState(() {
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

  void _selectCompany(int index, String compName, String logo) {
    setState(() {
      _selectedCompanyIndex = index;
      companyName = compName;
      companyLogo = logo;
    });
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
              deliveryNameController.text = state.response['name'] ?? '';
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
                controller: deliveryPhoneController,
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
                controller: deliveryNameController,
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
        const Text(
          'Coming From (Company)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          childAspectRatio: 0.9,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            CompanyTile(
              companyName: otherCompanyName != null ? otherCompanyName! : 'Swiggy',
              logo: otherCompanyLogo != null ? otherCompanyLogo! : 'assets/images/delivery/swiggy_logo.png',
              isSelected: _selectedCompanyIndex == 0,
              onTap: () => _selectCompany(
                  0,
                  otherCompanyName != null ? otherCompanyName! : 'Swiggy',
                  otherCompanyLogo != null ? otherCompanyLogo! : 'assets/images/delivery/swiggy_logo.png',
              ),
            ),
            CompanyTile(
              companyName: 'Zomato',
              logo: 'assets/images/delivery/zomato_logo.png',
              isSelected: _selectedCompanyIndex == 1,
              onTap: () => _selectCompany(1, 'Zomato', 'assets/images/delivery/zomato_logo.png'),
            ),
            CompanyTile(
              companyName: 'Amazon',
              logo: 'assets/images/delivery/amazon_logo.jpeg',
              isSelected: _selectedCompanyIndex == 2,
              onTap: () => _selectCompany(2, 'Amazon', 'assets/images/delivery/amazon_logo.jpeg'),
            ),
            CompanyTile(
              companyName: 'Flipkart',
              logo: 'assets/images/delivery/flipkart_logo.png',
              isSelected: _selectedCompanyIndex == 3,
              onTap: () => _selectCompany(3, 'Flipkart', 'assets/images/delivery/flipkart_logo.png'),
            ),
            CompanyTile(
              companyName: 'Myntra',
              logo: 'assets/images/delivery/myntra.jpeg',
              isSelected: _selectedCompanyIndex == 4,
              onTap: () => _selectCompany(4, 'Myntra', 'assets/images/delivery/myntra.jpeg'),
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

  Future<void> _onMorePressed() async {
    final result = await Navigator.pushNamed(context, '/delivery-more-option');

    if (result is Map<String, dynamic>) {
      setState(() {
        companyName = null;
        companyLogo = null;
        _selectedCompanyIndex = 0;
        otherCompanyName = result['name'];
        otherCompanyLogo = result['logo'];
      });
    }
  }

  Future<void> _onContinuePress() async {
    if (_formKey.currentState!.validate()) {
      profileData['name'] = deliveryNameController.text;
      profileData['mobNumber'] = deliveryPhoneController.text;
      profileData['profileImg'] = _image ?? profileData['profileImg'];
      profileData['companyName'] = companyName ?? otherCompanyName;
      profileData['entryType'] = 'delivery';
      profileData['companyLogo'] = companyLogo ?? otherCompanyLogo;
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
      } else if (profileData['companyName'] == null) {
        if (mounted) {
          CustomSnackBar.show(context: context, message: 'Please select the company', type: SnackBarType.error);
        }
        return;
      }
      if (mounted) {
        Navigator.pushNamed(context, '/ask-resident-approval', arguments: profileData);
      }
    }
  }
}
