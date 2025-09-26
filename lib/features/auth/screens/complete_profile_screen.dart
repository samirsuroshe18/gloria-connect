import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/auth/models/society_model.dart';
import 'package:gloria_connect/features/auth/widgets/modern_dropdown.dart';
import 'package:gloria_connect/features/auth/widgets/modern_text_field.dart';
import 'package:gloria_connect/features/auth/widgets/owenership_selection.dart';
import 'package:gloria_connect/features/auth/widgets/profile_type_card.dart';
import 'package:gloria_connect/features/auth/widgets/verification_section.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/media_picker_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Even though you did not manually install intl, it's likely available because another package depends on it. That’s why importing it works without errors.
// So in case of intl and path package importing working fine because another packages dependent on them
// intl : awesome_notifications (direct dependency) timeago (indirect dependency)
// path :flutter_launcher_icons, flutter_native_splash, hive_generator, json_serializable
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

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
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
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
    mobileController.dispose();
    profileTypeController.dispose();
    societyController.dispose();
    blockController.dispose();
    apartmentController.dispose();
    gateController.dispose();
    ownershipController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    context.read<AuthBloc>().add(AuthSocietyDetails());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              Navigator.pushReplacementNamed(context, '/verification-pending-screen');
              _isLoading = false;
            } else {
              Navigator.pushReplacementNamed(context, '/verification-pending-screen');
              _isLoading = false;
            }
          }

          if (state is AuthCompleteProfileFailure) {
            CustomSnackBar.show(
              context: context,
              message: state.message,
              type: SnackBarType.error,
            );
            _isLoading = false;
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Modern App Bar with Gradient
                _buildAppBar(),

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
                          const Text(
                            'Select Profile Type',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: ProfileTypeCard(
                                  onTap: _handleProfileTypeCardTap,
                                  isSelected: profileType == 'Resident',
                                  type: 'Resident',
                                  icon: Icons.home_rounded,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ProfileTypeCard(
                                  onTap: _handleProfileTypeCardTap,
                                  type: 'Security',
                                  icon: Icons.security_rounded,
                                  isSelected: profileType == 'Security',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Contact Information Section
                          _buildSectionHeader('Contact Information'),
                          ModernTextField(
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
                            ModernDropdown(
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
                            ModernDropdown(
                              value: blockName,
                              items: blockItems,
                              label: 'Select Block',
                              onChanged: blockOnChanged,
                              icon: Icons.business_rounded,
                            ),
                            if (blockName != null) ...[
                              const SizedBox(height: 24),
                              ModernDropdown(
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
                            ModernDropdown(
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
                            OwenershipSelection(onSelected: _handleChipSelectedTap, ownershipStatus: ownershipStatus,),
                            if (ownershipStatus != null)
                              VerificationSection(
                                ownerFileRemove: _ownerFileRemove,
                                tenantFileRemove: _tenantFileRemove,
                                startDateController: startDateController,
                                selectDate: _selectDate,
                                endDateController: endDateController,
                                onPickImage: _pickImage,
                                onPickPDF: _pickPDF,
                                ownershipStatus: ownershipStatus,
                                ownershipDocument: ownershipDocument,
                                ownershipDocumentType: ownershipDocumentType,
                                tenantAgreementType: tenantAgreementType,
                                tenantAgreement: tenantAgreement,
                              ),
                          ],

                          // Submit Button
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _onProfilePressed,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.white.withValues(alpha: 0.8),
                                foregroundColor: Colors.black, // Text color
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(){
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(45), bottomRight: Radius.circular(45))
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
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _handleProfileTypeCardTap(String type){
     setState(() => profileType = type);
  }

  void _handleChipSelectedTap(bool selected, String status) {
    if (selected) {
      setState(() => ownershipStatus = status);
    }
  }

  void _ownerFileRemove(){
    setState(() => ownershipDocument = null);
  }

  void _tenantFileRemove(){
    setState(() => tenantAgreement = null);
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
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
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
    CustomSnackBar.show(
      context: context,
      message: "Logged out successfully",
      type: SnackBarType.info,
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
          CustomSnackBar.show(
            context: context,
            message: "Ownership document is required",
            type: SnackBarType.error,
          );
          return;
        }
        if (ownershipStatus == 'Tenant') {
          if (tenantAgreement == null || startDate == null || endDate == null) {
            CustomSnackBar.show(
              context: context,
              message: "All fields are required. from tenant agreement",
              type: SnackBarType.error,
            );
            return;
          } else {
            if (!checkDates(startDate!, endDate!)) {
              CustomSnackBar.show(
                context: context,
                message: "End date must be at least 3 months greater than the start date.",
                type: SnackBarType.error,
              );
              return;
            }
          }
        }

        context.read<AuthBloc>().add(
              AuthCompleteProfile(
                  phoneNo: mobileController.text,
                  profileType: profileType ?? '',
                  societyName: societyName ?? '',
                  blockName: blockName ?? '',
                  apartment: apartment ?? '',
                  ownershipStatus: ownershipStatus ?? '',
                  startDate: startDate?.toIso8601String(),
                  endDate: endDate?.toIso8601String(),
                  tenantAgreement: tenantAgreement,
                  ownershipDocument: ownershipDocument),
            );
      } else if (profileType == 'Security' &&
          societyName != null &&
          gateName != null) {
        context.read<AuthBloc>().add(
              AuthCompleteProfile(
                phoneNo: mobileController.text,
                profileType: profileType ?? '',
                societyName: societyName ?? '',
                gateName: gateName ?? '',
              ),
            );
      } else {
        CustomSnackBar.show(
          context: context,
          message: "All fields are required.",
          type: SnackBarType.error,
        );
      }
    }
  }

  Future<void> _pickPDF() async {
    bool isOwner = ownershipStatus == 'Owner';
    try{
      final File? file =  await MediaPickerHelper.pickPdfFile(context: context);

      if (file != null) {
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
    }catch(e){
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    bool isOwner = ownershipStatus == 'Owner';
    try {
      final File? image = await MediaPickerHelper.pickImageFile(context: context, source: source);

      if (image != null) {
        final String fileExtension = path.extension(image.path).toLowerCase();

        setState(() {
          if (isOwner) {
            ownershipDocument = image;
            ownershipDocumentType = fileExtension;
          } else {
            tenantAgreement = image;
            tenantAgreementType = fileExtension;
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking image: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(
      context: context,
      message: message,
      type: SnackBarType.error,
    );
  }
}