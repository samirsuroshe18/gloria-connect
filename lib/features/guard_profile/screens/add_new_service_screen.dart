import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/check_in/bloc/check_in_bloc.dart';
import 'package:gloria_connect/features/guard_profile/bloc/guard_profile_bloc.dart';
import 'package:gloria_connect/features/guard_profile/widgets/add_flat_section.dart';
import 'package:gloria_connect/features/guard_profile/widgets/build_text_field.dart';
import 'package:gloria_connect/features/guard_profile/widgets/custom_structure_card.dart';
import 'package:gloria_connect/features/guard_profile/widgets/document_upload_card.dart';
import 'package:gloria_connect/features/guard_profile/widgets/gender_option_tile.dart';
import 'package:gloria_connect/features/guard_profile/widgets/image_picker_option.dart';
import 'package:gloria_connect/features/guard_profile/widgets/profile_avatar_picker.dart';
import 'package:gloria_connect/features/guard_profile/widgets/service_type_selector_tile.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/document_picker_utils.dart';
import 'package:gloria_connect/utils/media_picker_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNewServiceScreen extends StatefulWidget {
  final Map<String, dynamic>? formData;
  const AddNewServiceScreen({super.key, this.formData});

  @override
  State<AddNewServiceScreen> createState() => _AddNewServiceScreenState();
}

class _AddNewServiceScreenState extends State<AddNewServiceScreen> {
  File? _image;
  File? proofImage;
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

  Future<void> _pickProofImage(ImageSource source) async {
    try {
      final File? image = await MediaPickerHelper.pickImageFile(context: context, source: source);

      if (image != null) {
        setState(() {
          proofImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(context: context, message: 'Error picking image: $e', type: SnackBarType.error);
    }
  }

  Future<void> _pickProfileImage(ImageSource source) async {
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
    Navigator.pushNamed(context, '/block-selection-screen', arguments: formData);
  }

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

      CustomSnackBar.show(context: context, message: errorMessage, type: SnackBarType.error);
      return false;
    }
    return true;
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

  List<Map<String, String>> parseApartments(List<String> apartments) {
    return apartments.map((apartment) {
      List<String> parts = apartment.split(' ');
      return {
        'societyBlock': parts[0],
        'apartment': parts[1]
      };
    }).toList();
  }

  int _getMinutesDifference(TimeOfDay start, TimeOfDay end) {
    return (end.hour * 60 + end.minute) - (start.hour * 60 + start.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.2), // Change AppBar color here
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
                CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
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

  Widget _buildProfileSection() {
    return CustomStructureCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Profile Photo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ProfileAvatarPicker(
            imageFile: _image,
            onTap: () => DocumentPickerUtils.showDocumentPickerSheet(
              context: context,
              onPickImage: _pickProfileImage,
              onPickPDF: null,
              isOnlyImage: true,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ImagePickerOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickProfileImage(ImageSource.gallery),
                ),
                ImagePickerOption(
                  icon: Icons.camera,
                  label: 'Camera',
                  onTap: () => _pickProfileImage(ImageSource.camera),
                ),
                ImagePickerOption(
                  icon: Icons.delete_outline,
                  label: 'Remove',
                  onTap: () => setState(() => _image = null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return CustomStructureCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Details',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          const SizedBox(height: 24),
          BuildTextField(
            controller: name,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          BuildTextField(
            controller: mobileNo,
            label: 'Mobile Number',
            hint: '+91',
            icon: Icons.phone_android,
            keyboardType: TextInputType.phone,
            maxLength: 10,
          ),
          const SizedBox(height: 8),
          BuildTextField(
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Upload Identity Document',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DocumentUploadCard(
                file: proofImage,
                onRemove: () => setState(() => proofImage = null),
                onUploadTap: () => DocumentPickerUtils.showDocumentPickerSheet(
                  context: context,
                  onPickImage: _pickProofImage,
                  onPickPDF: null,
                  isOnlyImage: true,
                ),
                label: 'Upload Identity Document',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSection() {
    return CustomStructureCard(
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
          ServiceTypeSelectorTile(
            logoPath: serviceLogo,
            title: 'Service Type',
            subtitle: serviceName ?? 'Select service type',
            onTap: _navigateToServiceTypeSelection,
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
                child: GenderOptionTile(
                  value: 'male',
                  groupValue: selectedGender,
                  label: 'Male',
                  icon: Icons.male,
                  onTap: () => setState(() => selectedGender = 'male'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GenderOptionTile(
                  value: 'female',
                  groupValue: selectedGender,
                  label: 'Female',
                  icon: Icons.female,
                  onTap: () => setState(() => selectedGender = 'female'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AddFlatsSection(
            selectedFlats: selectedFlats,
            onAddFlat: _addFlats,
            onRemoveFlat: (index) {
              context.read<CheckInBloc>().add(RemoveFlat(flatName: selectedFlats[index]));
              setState(() {
                selectedFlats.removeAt(index);
              });
            },
          ),
        ],
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

  Widget _buildDurationSection() {
    return CustomStructureCard(
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
              ? Colors.white.withValues(alpha: 0.2)
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
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.blue.withValues(alpha: 0.4),
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
                startDate, (date) => setState(() => startDate = date),
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateSelector(
                'End Date',
                endDate, (date) => setState(() => endDate = date),
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

  Widget _buildDateSelector(String label, DateTime? selectedDate, Function(DateTime) onDateSelected, bool isStartDate,) {
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
              color: Colors.white.withValues(alpha: 0.2),
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

  Widget _buildTimeSelector(String label, TimeOfDay? selectedTime, Function(TimeOfDay) onTimeSelected, bool isStartTime,) {
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
              color: Colors.white.withValues(alpha: 0.2)
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time,
                    size: 20, color: Colors.white70,),
                const SizedBox(width: 8),
                Text(
                  selectedTime != null
                      ? selectedTime.format(context)
                      : 'Select Time',
                  style: const TextStyle(
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
              CustomSnackBar.show(context: context, message: 'End time must be at least 30 minutes after start time', type: SnackBarType.error);
            }
          }
        }
      });
    }
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