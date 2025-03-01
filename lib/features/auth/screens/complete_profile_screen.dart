import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/auth/models/society_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// Even though you didn’t manually install intl, it's likely available because another package depends on it. That’s why importing it works without errors.
// So in case of intl and path package importing working fine beacause another packages dependent on them
// intl : awesome_notifications (direct dependency) timeago (indirect dependency)
// path :flutter_launcher_icons, flutter_native_splash, hive_generator, json_serializable
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences _prefs;

  // Add file type tracking
  String? ownershipDocumentType;
  String? tenantAgreementType;

  // Supported file types
  final List<String> supportedImageTypes = ['.jpg', '.jpeg', '.png'];
  final List<String> supportedPdfTypes = ['.pdf'];

  // Existing controllers
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController profileTypeController = TextEditingController();
  final TextEditingController societyController = TextEditingController();
  final TextEditingController blockController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController ownershipController = TextEditingController();
  final TextEditingController gateController = TextEditingController();

  // New controllers for tenant dates
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // Image picker instance
  final ImagePicker _picker = ImagePicker();
  File? ownershipDocument;
  File? tenantAgreement;

  // Existing variables
  final List<String> profileItems = ['Resident', 'Security'];
  late List<String> societyItems;
  late List<String> blockItems;
  late List<String> apartmentItems;
  final List<String> ownershipItems = ['Owner', 'Tenant'];
  late List<String> gateItems;

  bool _isLoading = false;
  String? profileType;
  String? societyName;
  String? blockName;
  String? apartment;
  String? ownershipStatus;
  String? gateName;
  late List<Society> response;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    // Existing disposals
    mobileController.dispose();
    profileTypeController.dispose();
    societyController.dispose();
    blockController.dispose();
    apartmentController.dispose();
    gateController.dispose();
    ownershipController.dispose();

    // New disposals
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    if(!mounted) return;
    context.read<AuthBloc>().add(AuthSocietyDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSocietyDetailsLoading) {
            societyItems = ['Loading...'];
          }
          if (state is AuthSocietyDetailsSuccess) {
            response = state.response;
            // societyItems = state.response
            //     .map((society) => society.societyName ?? '')
            //     .toList();
            societyItems = ['Gloria'];
          }
          if (state is AuthSocietyDetailsFailure) {
            societyItems = ['Failed to load...'];
          }
          if (state is AuthCompleteProfileLoading) {
            _isLoading = true;
          }

          if (state is AuthCompleteProfileSuccess) {
            if (state.response.role == 'admin') {
              Navigator.pushReplacementNamed(context, '/admin-home');
              _isLoading = false;
            } else if (state.response.role == 'user' &&
                state.response.profileType == 'Resident') {
              Navigator.pushReplacementNamed(
                  context, '/verification-pending-screen');
              _isLoading = false;
            } else {
              Navigator.pushReplacementNamed(
                  context, '/verification-pending-screen');
              _isLoading = false;
            }
          }

          if (state is AuthCompleteProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ));
            _isLoading = false;
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Modern App Bar with Gradient
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.blue,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Theme.of(context).primaryColor,
                          Colors.blue.shade800,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.apartment_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Complete Your Profile',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: _logoutUser,
                  ),
                ],
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Type Selection Cards
                        Text(
                          'Select Profile Type',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildProfileTypeCard(
                                'Resident',
                                Icons.home_rounded,
                                profileType == 'Resident',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildProfileTypeCard(
                                'Security',
                                Icons.security_rounded,
                                profileType == 'Security',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Contact Information Section
                        _buildSectionHeader('Contact Information'),
                        _buildModernTextField(
                          controller: mobileController,
                          label: 'Mobile Number',
                          icon: Icons.phone_rounded,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                        ),
                        const SizedBox(height: 32),

                        // Society Details Section
                        if (profileType != null) ...[
                          _buildSectionHeader('Society Details'),
                          _buildModernDropdown(
                            value: societyName,
                            items: societyItems,
                            label: 'Select Society',
                            onChanged: societyOnChanged,
                            icon: Icons.location_city_rounded,
                          ),
                        ],

                        // Resident-specific fields
                        if (profileType == 'Resident' && societyName != null) ...[
                          const SizedBox(height: 24),
                          _buildModernDropdown(
                            value: blockName,
                            items: blockItems,
                            label: 'Select Block',
                            onChanged: blockOnChanged,
                            icon: Icons.business_rounded,
                          ),
                          if (blockName != null) ...[
                            const SizedBox(height: 24),
                            _buildModernDropdown(
                              value: apartment,
                              items: apartmentItems,
                              label: 'Select Apartment',
                              onChanged: apartmentOnChanged,
                              icon: Icons.apartment_rounded,
                            ),
                          ],
                        ],

                        // Security-specific fields
                        if (profileType == 'Security' && societyName != null) ...[
                          const SizedBox(height: 24),
                          _buildModernDropdown(
                            value: gateName,
                            items: gateItems,
                            label: 'Select Gate',
                            onChanged: gateOnChanged,
                            icon: Icons.door_front_door_rounded,
                          ),
                        ],

                        // Ownership Status Section
                        if (profileType == 'Resident' && apartment != null) ...[
                          const SizedBox(height: 32),
                          _buildSectionHeader('Ownership Details'),
                          _buildOwnershipSelection(),
                          if (ownershipStatus != null)
                            _buildVerificationSection(),
                        ],

                        // Submit Button
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _onProfilePressed,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                              'Complete Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProfileTypeCard(String type, IconData icon, bool isSelected) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => profileType = type),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 40,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                type,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField({required TextEditingController controller, required String label, required IconData icon, TextInputType? keyboardType, int? maxLength,}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          counterText: '',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildModernDropdown({required String? value, required List<String> items, required String label, required Function(String?) onChanged, required IconData icon,}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
    );
  }

  Widget _buildOwnershipSelection() {
    return Row(
      children: ownershipItems.map((status) {
        bool isSelected = ownershipStatus == status;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => ownershipStatus = status);
                }
              },
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        if (ownershipStatus == 'Owner')
          _buildDocumentUploadCard(
            title: 'Upload Ownership Document',
            subtitle: 'Please provide your Index2 or Resident Smart card photo',
            file: ownershipDocument,
            onUpload: () => _showDocumentPickerOptions(true),
            onRemove: () => setState(() => ownershipDocument = null),
            isOwner: ownershipStatus == 'owner'
          )
        else if (ownershipStatus == 'Tenant')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Agreement Duration'),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePickerField(
                      controller: startDateController,
                      label: 'Start Date',
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePickerField(
                      controller: endDateController,
                      label: 'End Date',
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDocumentUploadCard(
                title: 'Upload Rental Agreement',
                subtitle: 'Please provide your rental agreement document',
                file: tenantAgreement,
                onUpload: () => _showDocumentPickerOptions(false),
                onRemove: () => setState(() => tenantAgreement = null),
                isOwner: ownershipStatus == 'owner',
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDatePickerField({required TextEditingController controller, required String label, required VoidCallback onTap,}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
      ),
    );
  }

  Widget _buildDocumentUploadCard({required String title, required String subtitle, required File? file, required VoidCallback onUpload, required VoidCallback onRemove, required bool isOwner,}) {
    String? fileType = isOwner ? ownershipDocumentType : tenantAgreementType;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            if (file != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildFilePreview(file, fileType),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: onRemove,
                  ),
                ],
              )
            else
              InkWell(
                onTap: onUpload,
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: DottedBorder(
                    color: Colors.grey.shade300,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [8, 4],
                    strokeWidth: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file_rounded,
                            size: 48,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Upload Document',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to upload image or PDF',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(File file, String? fileType) {
    final String fileExtension = file.path.split('.').last.toLowerCase();
    if (fileExtension == 'pdf') {
      return GestureDetector(
        onTap: () => _showPDFPreview(file),
        child: Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                path.basename(file.path),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap to preview PDF',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // For image files
      return Image.file(
        file,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Error loading image',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _showPDFPreview(File file) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text(path.basename(file.path), style: const TextStyle(color: Colors.white),),
          ),
          body: PDFView(
            filePath: file.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageSnap: true,
            onError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error loading PDF: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _logoutUser() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              const Text('Confirm Logout'),
            ],
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLogoutLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AuthLogoutSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    removeAccessToken();
                  });
                  return const SizedBox.shrink();
                } else {
                  return TextButton(
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> removeAccessToken() async {
    await _prefs.remove("accessToken");
    await _prefs.remove("refreshMode");

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (Route<dynamic> route) => false,
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? DateTime.now()
          : (startDate?.add(const Duration(days: 1)) ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : (startDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          startDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        } else {
          endDate = picked;
          endDateController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      });
    }
  }

  void profileOnChanged(value) {
    setState(() {
      profileType = value;
    });
  }

  void societyOnChanged(newValue) {
    setState(() {
      societyName = newValue;
      final society =
      response.firstWhere((society) => society.societyName == societyName);
      blockItems = society.societyBlocks ?? [];
      gateItems = society.societyGates ?? [];
    });
  }

  void blockOnChanged(newValue) {
    setState(() {
      blockName = newValue;
      final society =
      response.firstWhere((society) => society.societyName == societyName);
      final apartments = society.societyApartments
          ?.where((apartment) => apartment.societyBlock == blockName)
          .toList();
      apartmentItems = apartments!
          .map((apartment) => apartment.apartmentName ?? '')
          .toList();
    });
  }

  void apartmentOnChanged(newValue) {
    setState(() {
      apartment = newValue;
    });
  }

  void ownershipOnChanged(newValue) {
    setState(() {
      ownershipStatus = newValue;
    });
  }

  void gateOnChanged(newValue) {
    setState(() {
      gateName = newValue;
    });
  }

  void _onProfilePressed() {
    bool checkDates(DateTime startDate, DateTime endDate) {
      // Add 3 months to the startDate
      final DateTime minEndDate = DateTime(
        startDate.year,
        startDate.month + 3,
        startDate.day,
      );

      // Check if the endDate is greater than or equal to the minimum end date
      if (endDate.isAfter(minEndDate) || endDate.isAtSameMomentAs(minEndDate)) {
        return true;
      } else {
        return false;
      }
    }

    if (_formKey.currentState!.validate()) {
      if (profileType == 'Resident' &&
          societyName != null &&
          blockName != null &&
          apartment != null &&
          ownershipStatus != null) {
        if (ownershipStatus == 'Owner' && ownershipDocument == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ownership document is required'),
            ),
          );
          return;
        }
        if (ownershipStatus == 'Tenant') {
          if (tenantAgreement == null || startDate == null || endDate == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All fields are required. from tenant agreement'),
              ),
            );
            return;
          } else {
            if (!checkDates(startDate!, endDate!)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'End date must be at least 3 months greater than the start date.',
                  ),
                ),
              );
              return;
            }
          }
        }

        context.read<AuthBloc>().add(
          AuthCompleteProfile(
              phoneNo: mobileController.text,
              profileType: '$profileType',
              societyName: '$societyName',
              blockName: '$blockName',
              apartment: '$apartment',
              ownershipStatus: '$ownershipStatus',
              startDate: startDate?.toIso8601String(),
              endDate: endDate?.toIso8601String(),
              tenantAgreement: tenantAgreement,
              ownershipDocument: ownershipDocument
          ),
        );
      } else if (profileType == 'Security' &&
          societyName != null &&
          gateName != null) {
        context.read<AuthBloc>().add(
          AuthCompleteProfile(
            phoneNo: mobileController.text,
            profileType: '$profileType',
            societyName: '$societyName',
            gateName: '$gateName',
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'All fields are required',
            ),
          ),
        );
      }
    }
  }

  void _showDocumentPickerOptions(bool isOwner) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Document Source',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera, isOwner);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery, isOwner);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: const Text('Upload PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickPDF(isOwner);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickPDF(bool isOwner) async {
    try {
      // Use a more reliable method to pick files on platforms
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: true,
        onFileLoading: (FilePickerStatus status) => log('FilePicker status: $status'),
      );

      if (result != null) {
        final path = result.files.single.path;
        if (path == null) {
          // Handle web platform or when path is not available
          if (result.files.first.bytes != null) {
            // Handle the bytes directly for web platform
            final bytes = result.files.first.bytes!;
            final tempDir = await getTemporaryDirectory();
            final file = File('${tempDir.path}/${result.files.first.name}');
            await file.writeAsBytes(bytes);

            setState(() {
              if (isOwner) {
                ownershipDocument = file;
                ownershipDocumentType = '.pdf';
              } else {
                tenantAgreement = file;
                tenantAgreementType = '.pdf';
              }
            });
          } else {
            _showErrorSnackBar('Could not access the selected file');
          }
        } else {
          // Handle native platforms
          final file = File(path);
          setState(() {
            if (isOwner) {
              ownershipDocument = file;
              ownershipDocumentType = '.pdf';
            } else {
              tenantAgreement = file;
              tenantAgreementType = '.pdf';
            }
          });
        }
      }
    } on PlatformException catch (e) {
      _showErrorSnackBar('Error picking PDF: ${e.message}');
    } catch (e) {
      _showErrorSnackBar('Error picking PDF: $e');
    }
  }

  Future<void> _pickImage(ImageSource source, bool isOwner) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        String fileExtension = path.extension(image.path).toLowerCase();

        if (supportedImageTypes.contains(fileExtension)) {
          setState(() {
            if (isOwner) {
              ownershipDocument = File(image.path);
              ownershipDocumentType = fileExtension;
            } else {
              tenantAgreement = File(image.path);
              tenantAgreementType = fileExtension;
            }
          });
        } else {
          _showErrorSnackBar('Please select a valid image file (JPG, JPEG, or PNG)');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}