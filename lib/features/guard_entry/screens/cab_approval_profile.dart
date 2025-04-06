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

class CabApprovalProfile extends StatefulWidget {
  final String? mobNumber;
  const CabApprovalProfile({super.key, this.mobNumber});

  @override
  State<CabApprovalProfile> createState() => _CabApprovalProfileState();
}

class _CabApprovalProfileState extends State<CabApprovalProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController cabPhoneController = TextEditingController();
  final TextEditingController cabNameController = TextEditingController();
  final TextEditingController cabVehicleNumberController =
      TextEditingController();
  String? otherCompanyLogo;
  String? otherCompanyName;
  String? companyName;
  String? companyLogo;
  File? _image;
  String? selectedVehicle = 'Two Wheeler';
  String? vehicleNo;
  String? societyName;
  String? gateName;
  Map<String, dynamic> profileData = {};
  int? _selectedCompanyIndex;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cabPhoneController.text = widget.mobNumber ?? '';
  }

  @override
  void dispose() {
    cabPhoneController.dispose();
    cabNameController.dispose();
    super.dispose();
  }

  void selectVehicle(String vehicle) {
    setState(() {
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
      companyName = compName;
      companyLogo = logo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Cab',
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black.withOpacity(0.2),
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listener: (context, state) {
          if (state is CheckInGetNumberSuccess) {
            profileData = state.response;
            if (mounted) cabNameController.text = state.response['name'] ?? '';
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
                    onPressed: isLoading ? null : _onContinuePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0)),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blueAccent),
                            backgroundColor: Colors.grey[200],
                            strokeWidth: 5.0,
                          )
                        : const Text('Continue',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
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
                  controller: cabPhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  // maxLength: 10,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    prefixIcon: const Icon(Icons.phone, color: Colors.white70),
                    hintText: 'Enter Phone Number',
                    hintStyle: TextStyle(color: Colors.white60),
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
                  controller: cabNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    prefixIcon: const Icon(Icons.person, color: Colors.white70),
                    hintText: 'Enter Name',
                    hintStyle: TextStyle(color: Colors.white60),
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
        const Text('Coming From (Company)',
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
                  otherCompanyName != null ? otherCompanyName! : 'Jugnoo',
              logo: otherCompanyLogo != null
                  ? otherCompanyLogo!
                  : 'assets/images/cab/jugnoo.png',
              isSelected: _selectedCompanyIndex == 0,
              onTap: () => _selectCompany(
                  0,
                  otherCompanyName != null ? otherCompanyName! : 'Jugnoo',
                  otherCompanyLogo != null
                      ? otherCompanyLogo!
                      : 'assets/images/cab/jugnoo.png'),
            ),
            CompanyTile(
              companyName: 'Ola',
              logo: 'assets/images/cab/ola.png',
              isSelected: _selectedCompanyIndex == 1,
              onTap: () =>
                  _selectCompany(1, 'Ola', 'assets/images/cab/ola.png'),
            ),
            CompanyTile(
              companyName: 'Rapido',
              logo: 'assets/images/cab/rapido.png',
              isSelected: _selectedCompanyIndex == 2,
              onTap: () =>
                  _selectCompany(2, 'Rapido', 'assets/images/cab/rapido.png'),
            ),
            CompanyTile(
              companyName: 'Uber',
              logo: 'assets/images/cab/uber.png',
              isSelected: _selectedCompanyIndex == 3,
              onTap: () =>
                  _selectCompany(3, 'Uber', 'assets/images/cab/uber.png'),
            ),
            CompanyTile(
              companyName: 'Utoo',
              logo: 'assets/images/cab/utoo.png',
              isSelected: _selectedCompanyIndex == 4,
              onTap: () =>
                  _selectCompany(4, 'Utoo', 'assets/images/cab/utoo.png'),
            ),
            MoreOptionsTile(onTap: _onMorePressed),
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
            VehicleOption(
              onTap: () => selectVehicle('Three Wheeler'),
              label: 'Three Wheeler',
              icon: Icons.electric_rickshaw,
              isSelected: selectedVehicle == 'Three Wheeler',
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (selectedVehicle == 'Two Wheeler' ||
            selectedVehicle == 'Four Wheeler' ||
            selectedVehicle == 'Three Wheeler')
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
    final result = await Navigator.pushNamed(context, '/cab-more-option');

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

  Future<void> _onContinuePressed() async {
    setState(() {
      isLoading = true;
    });
    File? resizedImage = await resizeImage(_image, width: 800, quality: 85);
    setState(() {
      isLoading = false;
    });
    if (_formKey.currentState!.validate()) {
      profileData['name'] = cabNameController.text;
      profileData['mobNumber'] = cabPhoneController.text;
      profileData['profileImg'] = resizedImage ?? profileData['profileImg'];
      profileData['companyName'] = companyName ?? otherCompanyName;
      profileData['entryType'] = 'cab';
      profileData['companyLogo'] = companyLogo ?? otherCompanyLogo;
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please take image'),
            backgroundColor: Colors.red,
          ));
        }
        return;
      } else if (profileData['companyName'] == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select the company'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.pushNamed(context, '/ask-cab-approval',
            arguments: profileData);
      }
    }
  }
}
