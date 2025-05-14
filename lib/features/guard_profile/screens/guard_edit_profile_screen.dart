import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/features/guard_profile/bloc/guard_profile_bloc.dart';
import 'package:gloria_connect/features/guard_profile/widgets/build_save_button.dart';
import 'package:gloria_connect/features/guard_profile/widgets/custom_text_input.dart';
import 'package:gloria_connect/features/guard_profile/widgets/profile_image_picker.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/document_picker_utils.dart';
import 'package:gloria_connect/utils/media_picker_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/bloc/auth_bloc.dart';

class GuardEditProfileScreen extends StatefulWidget {
  final GetUserModel? data;
  const GuardEditProfileScreen({super.key, this.data});

  @override
  State<GuardEditProfileScreen> createState() => _GuardEditProfileScreenState();
}

class _GuardEditProfileScreenState extends State<GuardEditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String profileImage = "";
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.data?.userName ?? "";
    profileImage = widget.data?.profile ?? "";
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final File? image = await MediaPickerHelper.pickImageFile(context: context, source: source);

      if (image != null) {
        setState(() {
          _selectedImage = image;
          profileImage = "";
        });
      }
    } catch (e) {
      CustomSnackBar.show(context: context, message: 'Error picking image: $e', type: SnackBarType.error);
    }
  }

  Future<void> _saveChanges() async {
    if(widget.data?.userName == _nameController.text && _selectedImage == null){
      _handleError("No changes were made.");
      return;
    }
    context.read<GuardProfileBloc>().add(GuardUpdateDetails(userName: _nameController.text, profile: _selectedImage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<GuardProfileBloc, GuardProfileState>(
        listener: (context, state){
          if(state is GuardUpdateDetailsLoading){
            _isLoading = true;
          }
          if(state is GuardUpdateDetailsSuccess){
            _isLoading = false;
            _handleSuccess(state.response['message']);
            context.read<AuthBloc>().add(AuthGetUser());
            Navigator.of(context).pop();
          }
          if(state is GuardUpdateDetailsFailure){
            _isLoading = false;
            _handleError(state.message);
          }
        },
        builder: (context, state){
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Section
                ProfileImagePicker(
                  selectedImage: _selectedImage,
                  profileImageUrl: profileImage,
                  onPickImage: () => DocumentPickerUtils.showDocumentPickerSheet(
                    context: context,
                    onPickImage: _pickImage,
                    onPickPDF: null,
                    isOnlyImage: true,
                  ),
                ),
                const SizedBox(height: 30),
                // Name Field Label
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Full Name",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Name Input Field
                CustomTextInput(
                  controller: _nameController,
                  hintText: "Enter your name",
                ),
                const SizedBox(height: 30),
                // Save Changes Button
                BuildSaveButton(isLoading: _isLoading, onPressed: _saveChanges),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleSuccess(String message) {
    CustomSnackBar.show(context: context, message: message, type: SnackBarType.success);
  }

  void _handleError(String message) {
    CustomSnackBar.show(context: context, message: message, type: SnackBarType.error);
  }
}
