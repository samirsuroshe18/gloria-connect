import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../utils/resize_image.dart';
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
  final TextEditingController otherVehicleNumberController =
      TextEditingController();
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
      vehicleNo = null;
    });
  }

  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: _onContinuePress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Continue',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
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
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120, // Diameter = 2 * radius
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white70, // Border color
                  width: 2.5, // Border width
                ),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : profileData['profileImg'] != null &&
                            profileData.isNotEmpty
                        ? NetworkImage(profileData['profileImg'])
                        : const AssetImage('assets/images/profile.png')
                            as ImageProvider,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 25),
                  onPressed: _openCamera,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mounted)
                TextFormField(
                  controller: otherPhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  // maxLength: 10,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    prefixIcon: const Icon(Icons.phone, color: Colors.white70),
                    hintText: 'Enter Phone Number',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return 'Please enter valid number';
                    } else {
                      return null;
                    }
                  },
                ),
              const SizedBox(height: 15),
              if (mounted)
                TextFormField(
                  controller: otherNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    prefixIcon: const Icon(Icons.person, color: Colors.white70),
                    hintText: 'Enter Name',
                    hintStyle: const TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    } else {
                      return null;
                    }
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
              PinCodeTextField(
                appContext: context,
                length: 4,
                keyboardType: TextInputType.number,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                onChanged: (String verificationCode) {
                  vehicleNo = verificationCode;
                },
                onCompleted: (String verificationCode) {
                  vehicleNo = verificationCode;
                },
                pinTheme: PinTheme(
                  fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 5),
                  fieldWidth: 50,
                  shape: PinCodeFieldShape.box,
                  borderWidth: 2,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: Colors.lightBlueAccent,
                  activeFillColor:
                      Colors.blue.shade50, // Light fill for active fields
                  inactiveFillColor: Colors.white,
                  selectedFillColor:
                      Colors.blue.shade100, // Highlight the selected box
                  borderRadius: BorderRadius.circular(
                      12), // Rounded corners for a modern look
                ),
                boxShadows: [
                  BoxShadow(
                    offset: const Offset(0, 4), // Subtle shadow effect
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.1), // Light shadow
                  ),
                ],
                cursorColor: Colors.blue, // Blue cursor for consistency
                animationType: AnimationType.fade, // Smooth animation effect
                animationDuration:
                    const Duration(milliseconds: 300), // Adjust animation speed
                enablePinAutofill: true, // Allow autofill
                backgroundColor: Colors.transparent, // Transparent background
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70, // Black text for visibility
                ),
              )
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
    setState(() {
      isLoading = true;
    });
    File? resizedImage = await resizeImage(_image, width: 800, quality: 85);
    setState(() {
      isLoading = false;
    });
    if (_formKey.currentState!.validate()) {
      profileData['name'] = otherNameController.text;
      profileData['mobNumber'] = otherPhoneController.text;
      profileData['profileImg'] = resizedImage ?? profileData['profileImg'];
      profileData['serviceName'] = serviceName ?? otherServiceName;
      profileData['serviceLogo'] = serviceLogo ?? otherServiceLogo;
      profileData['entryType'] = 'other';
      profileData['vehicleType'] = selectedVehicle;
      profileData['vehicleNo'] = vehicleNo;
      if (selectedVehicle != 'No Vehicle' &&
          (vehicleNo == null || vehicleNo!.length < 4)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Enter vehicle number'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      } else if (_image == null && profileData['profileImg'] == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please take image'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      } else if (profileData['serviceName'] == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select the service'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      if (mounted) {
        Navigator.pushNamed(context, '/ask-other-approval',
            arguments: profileData);
      }
    }
  }
}
