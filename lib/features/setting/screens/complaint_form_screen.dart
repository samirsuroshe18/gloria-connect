import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:gloria_connect/features/setting/widgets/build_area_selector.dart';
import 'package:gloria_connect/features/setting/widgets/build_category.dart';
import 'package:gloria_connect/features/setting/widgets/build_description.dart';
import 'package:gloria_connect/features/setting/widgets/build_image_uploader.dart';
import 'package:gloria_connect/features/setting/widgets/build_selection_tile.dart';
import 'package:gloria_connect/features/setting/widgets/build_sub_category.dart';
import 'package:gloria_connect/features/setting/widgets/build_submit_button.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/media_picker_helper.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  File? file;

  String? selectedArea;
  String? selectedCategory;
  String? selectedSubCategory;
  bool isLoading = false;

  // Existing data structure maintained
  final List<String> areas = ['My Apartment', 'My Society', 'My Building'];
  final Map<String, List<String>> categories = {
    'AC': ["AC Not Working (Hitachi)", "AC Not Working (LG)", "AC Leakage", "AC Remote Not Working", "AC Wall Switch Non Working", "Cooling Issue", "Duct Area Cleaning", "PCB Issue", "Servicing Needed"],
    'Children Play Area': ['Play Equipment Damaged'],
    'Civil': ["Bedroom Ceiling Leakage", "Bedroom Skirting Leakage", "Common Toilet Leakage", "Damaged Jaiselmer of Elevator Jam", "Daughter Toilet Leakage", "External Wall Leakage", "Kitchen Ceiling Leakage", "Leakage In Plumbing Lines", "Living Room Ceiling Leakage", "Living Room Skirting Leakage", "Master Toilet Leakage", "Plumbing Leakages (Inside Shaft)", "Structural Cracks", "Structural Leakage Or Seepage", "Demarcation Not Done"],
    'Common Area': ["Animal / Bird Waste Or Odour", "City Common Area / Roads Not Cleaned"],
    'Doors': ["Entrance Glass Door", "Fire Exit Door", "Terrace Doors", "Utility Door"],
    'Electrical': ["Fire Alarm Safety Gets Activated", "No Electricity In Common Areas", "No Power", "Tube Light Hanging", "Voltage Fluctuating", "Voltage Fluctuations in Building", "UTP Cable Missing", "Choke Up In Line"],
    'Electrical Meter Related': ['Electrical Meter Related'],
    'Elevators': ["Door Jam / Sensor Issue", "Elevator Lights Not Working", "Elevator Not Working", "Elevator Stuck / Halting Issue / Jerks", "Fan / Lights / Display / Buttons Issue", "Intercom Not Working", "Mirror Damaged", "Noise In The Elevator22"],
    'Plumbing': ["Fix Water Pressure", "Geyser Issue", "Health Faucet", "Internal Line Choke - Up", "Low Water Pressure", "No Domestic Water", "No Flushing Water", "Solar Water", "Tap Leakage", "WC Cover"],
    'Roads and Walkways': ['Potholes or Repairs Required'],
    'Street Light': ['Light Not Sufficient', 'Lights Not working'],
    'Water': ["Drainage Choked Overflow", "Terrace Booster Pump Not Working", "Water - Others", "Water Logging"],
    'Transportation': ['Bus Running Late', 'Misconduct Of Drivers Or Conductors', 'Unclean Bus'],
    'Safety & Security': ["Building Security Issues", "Illegal Public Activities", "Loud Music/ Noise Pollution", "Obstruction In Public Areas", "Potential Fire Hazard", "Public Defecation Or Urination", "Suspicious Behaviour Within City Common Areas", "Traffic Rules Violation", "Trespassers In City", "Unauthorized Parking Occupation"],
    'Gloria App': ["Unable To Login", "Unable To Use App Functionality", "Profile Details Mismatch"],
    'Cable Services': ['Cable Not Working'],
    'CCTV': ['CCTV Camera Not Working'],
    'Intercom': ["Cat Cable Missing", "No Dial Tone", "Not Installed", "VDP Installation", "VDP not working"],
    'Lobby Access Control': ["Access Control Lobby Glass Door Issue", "Dial Pad Not Working", "Access Card Not working"],
    'WiFi': ['WiFi Not Working'],
    'Horticulture': ["Shrubs Not Trimmed", "Snake Holes / Rat Holes Spotted"],
    'Building Housekeeping': ["Garbage Collection", "Pigeon Waste & Odour", "Unclean Area In Garden", "Unclean Area In Building", "Beehive"],
    'Pest Control': ['Building Pest Control'],
    'Parking': ["Demarcation Not Done", "Double Allocation", "Mismatch Parking In System", "Parking Sticker"],
    'Club Hose': ["Clubhouse - Others", "Equipment's (Gym Swimming Pool etc)", "Others"],
    'DLP': ["MCB Not Working", "Switch Not Working", "Door Lock Not Working", "CP Fitting", "Geyser Not Working", "Door Framework", "Door Name Plate Not Install", "Window Sliding Lock", "Chajja Cleaning For Debris", "Low Water Pressure", "Cracks In The Apartment", "Kitchen/Bathroom Sink Choked", "Choke Up In Line", "Gypsum Hollow", "Loose Tiles"],
    'Flat Access': ["Access of Other Flats"],
    'AC Servicing': ["Ac Service"]
  };

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<SettingBloc>().add(SettingSubmitComplaint(
          area: selectedArea!,
          category: selectedCategory!,
          subCategory: selectedSubCategory!,
          description: _descriptionController.text,
          file: file));
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        title: const Text(
          'Submit Complaint',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingSubmitComplaintLoading) {
            setState(() => isLoading = true);
          } else if (state is SettingSubmitComplaintSuccess) {
            setState(() => isLoading = false);
            CustomSnackBar.show(context: context, message: 'Complaint submitted successfully', type: SnackBarType.success);
            Navigator.pop(context, state.response);
          } else if (state is SettingSubmitComplaintFailure) {
            setState(() => isLoading = false);
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BuildSelectionTile(title: 'Location Details'),
                        BuildAreaSelector(
                          selectedArea: selectedArea,
                          areas: areas,
                          onChange: (String? newValue) {
                            setState(() => selectedArea = newValue);
                          },
                        ),
                        const SizedBox(height: 24),
                        const BuildSelectionTile(title: 'Complaint Category'),
                        BuildCategory(
                          selectedCategory: selectedCategory,
                          onChange: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue;
                              selectedSubCategory = null;
                            });
                          },
                          categories: categories,
                        ),
                        if (selectedCategory != null)
                          BuildSubCategory(
                            selectedCategory: selectedCategory,
                            selectedSubCategory: selectedSubCategory,
                            categories: categories,
                            onChange: (String? newValue) {
                              setState(() => selectedSubCategory = newValue);
                            },
                          ),
                        const SizedBox(height: 24),
                        const BuildSelectionTile(title: 'Complaint Details'),
                        BuildDescription(descriptionController: _descriptionController),
                        const SizedBox(height: 24),
                        const BuildSelectionTile(title: 'Supporting Evidence'),
                        BuildImageUploader(file: file, onCancel: () => setState(() => file = null), pickImage: _pickImage),
                        const SizedBox(height: 32),
                        BuildSubmitButton(isLoading: isLoading, onPressed: _submitForm),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final File? image = await MediaPickerHelper.pickImageFile(context: context, source: source);

      if (image != null) {
        setState(() {
          file = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(context: context, message: 'Error picking image: $e', type: SnackBarType.error);
    }
  }
}
