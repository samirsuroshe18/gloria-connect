import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/guard_profile/bloc/guard_profile_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNewServiceScreen extends StatefulWidget {
  final Map<String, dynamic>? formData;
  const AddNewServiceScreen({super.key, this.formData});

  @override
  State<AddNewServiceScreen> createState() => _AddNewServiceScreenState();
}

class _AddNewServiceScreenState extends State<AddNewServiceScreen> {
  // Existing controllers and variables remain the same
  File? _image;
  File? proofImage;
  final ImagePicker _picker = ImagePicker();
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController address = TextEditingController();
  List<String> selectedFlats = [];
  String selectedGender = 'male';
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectedDurationType;
  String? serviceLogo;
  String? serviceName;
  bool _isLoading = false;
  final _scrollController = ScrollController();
  File? proofImageDocument;

  final List<DurationOption> durationOptions = [
    DurationOption(label: '1 Month', months: 1),
    DurationOption(label: '3 Months', months: 3),
    DurationOption(label: '6 Months', months: 6),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize existing data if available
    _initializeData();
  }

  void _initializeData() {
    context.read<CheckInBloc>().add(AddFlat());
    if (widget.formData != null) {
      _image = widget.formData?['image'];
      proofImage = widget.formData?['proofImage'];
      name.text = widget.formData?['name'] ?? '';
      mobileNo.text = widget.formData?['mobileNo'] ?? '';
      address.text = widget.formData?['address'] ?? '';
      selectedGender = widget.formData?['selectedGender'] ?? 'male';
      startDate = widget.formData?['startDate'];
      endDate = widget.formData?['endDate'];
      startTime = widget.formData?['startTime'];
      endTime = widget.formData?['endTime'];
      selectedDurationType = widget.formData?['selectedDurationType'];
      serviceLogo = widget.formData?['serviceLogo'];
      serviceName = widget.formData?['serviceName'];
    }
  }

  Widget _buildProfileSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: _image != null
                        ? ClipOval(
                      child: Image.file(
                        _image!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showImageSourceDialog(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: name,
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: mobileNo,
              label: 'Mobile Number',
              hint: '+91',
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: address,
              label: 'Address',
              hint: 'Enter your address',
              icon: Icons.location_on_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Upload Identity Document',
                    style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                ),
                Card(
                  color: Colors.white.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (proofImage != null)
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.file(
                                proofImage!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () =>
                                    setState(() => proofImage = null),
                              ),
                            ],
                          )
                        else
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () => _showImagePickerOptions(true),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 50, color: Colors.white70,),
                                  Text('Upload Ownership Document', style: TextStyle(color: Colors.white70),),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions(bool isOwner) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
            proofImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white60),
            prefixIcon: Icon(icon, color: Colors.white70,),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: _navigateToServiceTypeSelection,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      serviceLogo ?? 'assets/images/other/more_options.png', // Replace with your asset image path
                      width: 24, // Adjust the width as needed
                      height: 24, // Adjust the height as needed
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Service Type',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            serviceName ?? 'Select service type',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.white70),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildGenderOption(
                    'male',
                    'Male',
                    Icons.male,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGenderOption(
                    'female',
                    'Female',
                    Icons.female,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Flats',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addFlats,
                      icon: const Icon(Icons.add, color: Colors.white70),
                      label: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (selectedFlats.isNotEmpty)
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedFlats.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white.withOpacity(0.2),
                          margin: const EdgeInsets.only(right: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Text(selectedFlats[index], style: TextStyle(color: Colors.white70),),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      context.read<CheckInBloc>().add(
                                          RemoveFlat(flatName: selectedFlats[index]));
                                      selectedFlats.removeAt(index);
                                      // List<String> parts = selectedFlats[index].split(' ');
                                      // context.read<CheckInBloc>().add(RemoveFlat(flatName: selectedFlats[index]));
                                    });
                                  },
                                  child: const Icon(Icons.close,
                                      size: 20, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addFlats() async {
    Map<String, dynamic> formData = {
      'image': _image,
      'name': name.text,
      'mobileNo': mobileNo.text,
      'address': address.text,
      'proofImage': proofImage,
      'selectedGender': selectedGender,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'selectedDurationType': selectedDurationType,
      'serviceLogo': serviceLogo,
      'serviceName': serviceName,
      'isAddService': true
    };
    Navigator.pushNamed(context, '/block-selection-screen',
        arguments: formData);
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = selectedGender == value;
    return InkWell(
      onTap: () => setState(() => selectedGender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            'Add Service',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Validate and submit form logic (existing implementation)
    if (!_validateForm()) return;

    List<Map<String, String>> result = parseApartments(selectedFlats);

    context.read<GuardProfileBloc>().add(AddGatePass(
      name: name.text,
      profile: proofImage,
      mobNumber: mobileNo.text,
      address: address.text,
      serviceName: serviceName,
      serviceLogo: serviceLogo,
      addressProof: proofImage,
      gender: selectedGender,
      gatepassAptDetails: result,
      checkInCodeStartDate: DateTime(startDate!.year, startDate!.month, startDate!.day, 00, 00, 00).toIso8601String(),
      checkInCodeExpiryDate: DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59).toIso8601String(),
      checkInCodeStart: DateTime(startDate!.year, startDate!.month, startDate!.day, startTime!.hour, startTime!.minute).toIso8601String(),
      checkInCodeExpiry: DateTime(endDate!.year, endDate!.month, endDate!.day, endTime!.hour, endTime!.minute).toIso8601String(),
    ));
  }

  // ... (continuing from previous code)

  bool _validateForm() {
    if (_image == null ||
        name.text.isEmpty ||
        proofImage == null ||
        mobileNo.text.isEmpty ||
        address.text.isEmpty ||
        serviceName == null ||
        serviceLogo == null ||
        selectedGender.isEmpty ||
        selectedFlats.isEmpty ||
        startDate == null ||
        endDate == null ||
        startTime == null ||
        endTime == null) {

      String errorMessage = 'Please fill in all required fields:';
      if (_image == null) errorMessage += '\n- Profile photo';
      if (name.text.isEmpty) errorMessage += '\n- Name';
      if (proofImage == null) errorMessage += '\n- Identity Document';
      if (mobileNo.text.isEmpty) errorMessage += '\n- Mobile Number';
      if (address.text.isEmpty) errorMessage += '\n- Address';
      if (serviceName == null) errorMessage += '\n- Service Type';
      if (selectedFlats.isEmpty) errorMessage += '\n- Flats';
      if (startDate == null || endDate == null) errorMessage += '\n- Service Duration';
      if (startTime == null || endTime == null) errorMessage += '\n- Service Time';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
    return true;
  }

  Widget _buildDurationSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Duration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...durationOptions.map((option) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildDurationOption(option),
                  )),
                  _buildCustomDurationOption(),
                ],
              ),
            ),
            if (selectedDurationType != null) ...[
              const SizedBox(height: 24),
              _buildDateTimeSelectors(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDurationOption(DurationOption option) {
    final isSelected = selectedDurationType == option.label;
    return InkWell(
      onTap: () => _selectPredefinedDuration(option),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          option.label,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDurationOption() {
    final isSelected = selectedDurationType == 'Custom';
    return InkWell(
      onTap: () {
        setState(() {
          selectedDurationType = 'Custom';
          startDate = null;
          endDate = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.blue.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
          ),
        ),
        child: Text(
          'Custom',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeSelectors() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDateSelector(
                'Start Date',
                startDate,
                    (date) => setState(() => startDate = date),
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateSelector(
                'End Date',
                endDate,
                    (date) => setState(() => endDate = date),
                false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildTimeSelector(
                'Start Time',
                startTime,
                    (time) => setState(() => startTime = time),
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTimeSelector(
                'End Time',
                endTime,
                    (time) => setState(() => endTime = time),
                false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector(
      String label,
      DateTime? selectedDate,
      Function(DateTime) onDateSelected,
      bool isStartDate,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context, isStartDate),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 20, color: Colors.white60),
                const SizedBox(width: 8),
                Text(
                  selectedDate != null
                      ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                      : 'Select Date',
                  style: const TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(
      String label,
      TimeOfDay? selectedTime,
      Function(TimeOfDay) onTimeSelected,
      bool isStartTime,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context, isStartTime),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.2)
            ),
            child: Row(
              children: [
                Icon(Icons.access_time,
                    size: 20, color: Colors.white70,),
                const SizedBox(width: 8),
                Text(
                  selectedTime != null
                      ? selectedTime.format(context)
                      : 'Select Time',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2), // Change AppBar color here
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<CheckInBloc>().add(ClearFlat());
            Navigator.pop(context);
          },
          color: Colors.white70,
        ),
        title: const Text(
          'Add new gate pass',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listener: (context, state) {
          if (state is FlatState) {
            setState(() => selectedFlats = state.selectedFlats);
          }
        },
        builder: (context, checkInState) {
          return BlocConsumer<GuardProfileBloc, GuardProfileState>(
            listener: (context, state) {
              if (state is AddGatePassLoading) {
                setState(() => _isLoading = true);
              } else if (state is AddGatePassSuccess) {
                setState(() => _isLoading = false);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/gate-pass-banner-screen',
                  arguments: state.response,
                      (route) => route.isFirst,
                );
              } else if (state is AddGatePassFailure) {
                setState(() => _isLoading = false);
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
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(child: _buildProfileSection()),
                  SliverToBoxAdapter(child: _buildFormSection()),
                  SliverToBoxAdapter(child: _buildServiceSection()),
                  SliverToBoxAdapter(child: _buildDurationSection()),
                  SliverToBoxAdapter(child: _buildSubmitButton()),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  List<Map<String, String>> parseApartments(List<String> apartments) {
    return apartments.map((apartment) {
      List<String> parts = apartment.split(' ');
      return {
        'societyBlock': parts[0],
        'apartment': parts[1]
      };
    }).toList();
  }

  Future<void> _showImageSourceDialog({bool isProof = false}) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    title: 'Camera',
                    onTap: () {
                      isProof
                          ? _getProofImage(ImageSource.camera)
                          : _getImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                  _buildImageSourceOption(
                    icon: Icons.photo_library,
                    title: 'Gallery',
                    onTap: () {
                      isProof
                          ? _getProofImage(ImageSource.gallery)
                          : _getImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: Colors.green),
          ),
          const SizedBox(height: 12),
          Text(title),
        ],
      ),
    );
  }

  Future<void> _getProofImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        proofImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
      isStartTime ? TimeOfDay.now() : (startTime ?? TimeOfDay.now()),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
          // Reset end time if it's not valid with new start time
          if (endTime != null) {
            final difference = _getMinutesDifference(picked, endTime!);
            if (difference < 30) {
              endTime = null;
            }
          }
        } else {
          // Check if end time is at least 30 minutes after start time
          if (startTime != null) {
            final difference = _getMinutesDifference(startTime!, picked);
            if (difference >= 30) {
              endTime = picked;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'End time must be at least 30 minutes after start time'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      });
    }
  }

  int _getMinutesDifference(TimeOfDay start, TimeOfDay end) {
    return (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? DateTime.now()
          : (startDate ?? DateTime.now()).add(const Duration(days: 1)),
      firstDate: isStartDate ? DateTime.now() : (startDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          // Reset end date if it's before new start date
          if (endDate != null && endDate!.isBefore(picked)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
        selectedDurationType = 'Custom';
      });
    }
  }

  Future<void> _navigateToServiceTypeSelection() async {
    final result = await Navigator.pushNamed(
      context,
      '/other-more-option',
      arguments: true,
    );

    if (result is Map<String, dynamic>) {
      setState(() {
        serviceName = result['name'];
        serviceLogo = result['logo'];
      });
    }
  }

  void _selectPredefinedDuration(DurationOption option) {
    final now = DateTime.now();
    setState(() {
      startDate = now;
      endDate = DateTime(now.year, now.month + option.months, now.day);
      selectedDurationType = option.label;
    });
  }
}

class DurationOption {
  final String label;
  final int months;

  DurationOption({required this.label, required this.months});
}