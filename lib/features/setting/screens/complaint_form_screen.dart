import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/setting/bloc/setting_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Complaint submitted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, state.response);
          } else if (state is SettingSubmitComplaintFailure) {
            setState(() => isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
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
                        _buildSectionTitle('Location Details'),
                        _buildAreaSelector(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Complaint Category'),
                        _buildCategorySelector(),
                        if (selectedCategory != null)
                          _buildSubCategorySelector(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Complaint Details'),
                        _buildDescriptionField(),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Supporting Evidence'),
                        _buildImageUploader(),
                        const SizedBox(height: 32),
                        _buildSubmitButton(),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
      ),
    );
  }

  Widget _buildAreaSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedArea,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          hintText: 'Select Area',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon:
              const Icon(Icons.location_on_outlined, color: Colors.white70),
        ),
        items: areas.map((String area) {
          return DropdownMenuItem<String>(
            value: area,
            child: Text(area),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() => selectedArea = newValue);
        },
        validator: (value) => value == null ? 'Please select an area' : null,
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: 'Select Category',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.category_outlined, color: Colors.white70),
        ),
        items: categories.keys.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue;
            selectedSubCategory = null;
          });
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  Widget _buildSubCategorySelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonFormField(
          isExpanded: true,  // Forces the dropdown to take the full width
          value: selectedSubCategory,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Select Sub-Category',
            prefixIcon: const Icon(Icons.subdirectory_arrow_right,
                color: Color(0xFF3498DB)),
          ),
          items: categories[selectedCategory]!.map((String subCategory) {
            return DropdownMenuItem(
              value: subCategory,
              child: Text(subCategory, overflow: TextOverflow.ellipsis), // Avoids text overflow
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() => selectedSubCategory = newValue);
          },
          validator: (value) => value == null ? 'Please select a sub-category' : null,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 4,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: 'Describe your complaint in detail...',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 80),
            child: Icon(Icons.description_outlined, color: Colors.white70),
          ),
        ),
        validator: (value) =>
            value?.isEmpty == true ? 'Please enter a description' : null,
      ),
    );
  }

  Widget _buildImageUploader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (file != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      file!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 20),
                        onPressed: () => setState(() => file = null),
                      ),
                    ),
                  ),
                ],
              )
            else
              InkWell(
                onTap: _showImagePickerOptions,
                child: Container(
                  height: 200,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF3498DB), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 50, color: Color(0xFF3498DB)),
                      SizedBox(height: 8),
                      Text(
                        'Upload Supporting Image',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '(Optional)',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Submit Complaint',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_camera,
                        color: Color(0xFF3498DB)),
                  ),
                  title: const Text('Take a photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_library,
                        color: Color(0xFF3498DB)),
                  ),
                  title: const Text('Choose from gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (image != null) {
        setState(() {
          file = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

// Helper class for form validation and error messages
class FormValidator {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters long';
    }
    return null;
  }
}

// Custom theme constants
class ComplaintFormTheme {
  static const Color primaryColor = Color(0xFF3498DB);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color textColor = Color(0xFF2C3E50);
  static const Color errorColor = Color(0xFFE74C3C);

  static const double borderRadius = 12.0;
  static const double spacing = 16.0;
  static const double fontSize = 16.0;

  static BoxDecoration containerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryColor),
    );
  }
}
