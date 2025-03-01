import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../utils/resize_image.dart';
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
  final TextEditingController guestVehicleNumberController =
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
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
                          _guestDetails(),
                          const SizedBox(height: 20),
                          _vehicleDetails(),
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
                  color: Colors.blue, // Border color
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
                  controller: guestPhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  // maxLength: 10,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                    hintText: 'Enter Phone Number',
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
                  controller: guestNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                    hintText: 'Enter Name',
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

  Widget _guestDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ADD ACCOMPANYING GUESTS',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xB3000000)),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                  onPressed: accompanyingGuests > 0
                      ? () {
                          setState(() {
                            accompanyingGuests--;
                          });
                        }
                      : null,
                ),
                Text(
                  accompanyingGuests.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.add_circle_outline, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      accompanyingGuests++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.blue.shade100,
          ),
          child: Text(
            getGuestText(),
            style: const TextStyle(fontSize: 16, color: Color(0xB3000000)),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
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
                    fontWeight: FontWeight.bold, color: Colors.black54),
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
                  activeFillColor: Colors.blue.shade50,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.blue.shade100,
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
                  color: Colors.black, // Black text for visibility
                ),
              )
            ],
          ),
      ],
    );
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
      profileData['name'] = guestNameController.text;
      profileData['mobNumber'] = guestPhoneController.text;
      profileData['profileImg'] = resizedImage ?? profileData['profileImg'];
      profileData['entryType'] = 'guest';
      profileData['accompanyingGuest'] = accompanyingGuests.toString();
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
      }
      if (mounted) {
        Navigator.pushNamed(context, '/ask-guest-approval',
            arguments: profileData);
      }
    }
  }
}
