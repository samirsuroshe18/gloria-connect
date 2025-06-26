import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/common_widgets/build_error_state.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/common_widgets/custom_loader.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import 'package:gloria_connect/features/technician_home/bloc/technician_home_bloc.dart';
import 'package:gloria_connect/features/technician_home/models/resolution_model.dart';
import 'package:gloria_connect/features/technician_home/widgets/resolution_upload_card.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:gloria_connect/utils/document_picker_utils.dart';
import 'package:gloria_connect/utils/media_picker_helper.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class TechnicianComplaintDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? notificationPayload;
  final ResolutionElement? data;

  const TechnicianComplaintDetailsScreen({super.key, this.data, this.notificationPayload});

  @override
  State<TechnicianComplaintDetailsScreen> createState() =>
      _TechnicianComplaintDetailsScreenState();
}

class _TechnicianComplaintDetailsScreenState extends State<TechnicianComplaintDetailsScreen> {
  final TextEditingController resolutionNoteController = TextEditingController();
  ResolutionElement? response;
  File? tenantAgreement;
  String? tenantAgreementType;
  bool _isLoading = false;
  bool _submitLoading = false;
  bool isResolved = false;

  @override
  void dispose() {
    super.dispose();
    resolutionNoteController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if(widget.data != null){
      response = widget.data;
      isResolved = response?.resolution?.status == 'approved';
    }
    if(widget.notificationPayload != null){
      context.read<TechnicianHomeBloc>().add(GetTechnicianDetails(complaintId: widget.notificationPayload!['id']));
    }
  }

  Future<void> _onRefresh() async {
    if(response != null){
      context.read<TechnicianHomeBloc>().add(GetTechnicianDetails(complaintId: response!.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        centerTitle: true,
        title: const Text(
          'Complaint Details',
          style: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: BlocConsumer<TechnicianHomeBloc, TechnicianHomeState>(
        listener: (context, state) {
          if (state is GetTechnicianDetailsLoading) {
            _isLoading = true;
          }
          if (state is GetTechnicianDetailsSuccess) {
            _isLoading = false;
            response = state.response;
            isResolved = response?.resolution?.status == 'approved';
          }
          if (state is GetTechnicianDetailsFailure) {
            CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
            _isLoading = false;
          }
        },
        builder: (context, state) {
          return BlocConsumer<TechnicianHomeBloc, TechnicianHomeState>(
            listener: (context, state){
              if(state is AddComplaintResolutionLoading){
                _submitLoading = true;
              }
              if(state is AddComplaintResolutionSuccess){
                _submitLoading = false;
                _tenantFileRemove();
                resolutionNoteController.text = '';
                response = state.response;
              }
              if(state is AddComplaintResolutionFailure){
                _submitLoading = false;
                CustomSnackBar.show(context: context, message: state.message, type: SnackBarType.error);
              }
          },
          builder: (context, state){
            if (response != null && _isLoading == false) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildComplaintInfoCard(context, isResolved),
                            const SizedBox(height: 24),

                            if(response?.resolution?.status == null)
                              _buildResolutionInputCard(context),

                            if(response?.resolution?.status == 'approved')
                              _buildResolutionInfoCard(context),

                            if(response?.resolution?.status == 'under_review')
                              _buildUnderReviewCard(context),

                            if(response?.resolution?.status == 'rejected')
                              _buildRejectedCard(context)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (_isLoading) {
              return const CustomLoader();
            } else {
              return BuildErrorState(onRefresh: _onRefresh);
            }
          }
          );
        },
      ),
    );
  }

  Widget _buildComplaintInfoCard(BuildContext context, bool isResolved) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appBarBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCachedNetworkImage(
                imageUrl: response?.imageUrl,
                size: 60,
                borderWidth: 1,
                isCircular: true,
                errorImage: Icons.image,
                onTap: () =>
                    CustomFullScreenImageViewer.show(
                        context, response?.imageUrl, errorImage: Icons.image),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response?.category ?? 'NA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusChip(isResolved),
                    const SizedBox(height: 16),
                    _buildDetailRow('Category:', response?.subCategory ?? 'NA', context),
                    _buildDetailRow('Date:', response?.createdAt != null ? DateFormat('dd MMM, yyyy').format(response!.createdAt!) :'NA', context),
                    _buildDetailRow('Resident:', response?.raisedBy?.userName ?? 'NA', context),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Description',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(response?.description ?? 'NA',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  color: AppColors.iconColor, size: 20),
              const SizedBox(width: 8),
              Text('Assigned to: ${response?.technicianId?.userName ?? 'NA'}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              Text('Resolution Approved',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionInputCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resolution', style: Theme
              .of(context)
              .textTheme
              .titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: resolutionNoteController,
            maxLines: 4,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Describe how you resolved the issue...',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              fillColor: AppColors.appBarBackground,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ResolutionUploadCard(
          title: 'Resolution Attachment',
          subtitle: 'Please provide image',
          file: tenantAgreement,
          onUpload: () => DocumentPickerUtils.showDocumentPickerSheet(context: context, onPickImage: _pickImage, isOnlyImage: true, onPickPDF: null),
          onRemove: _tenantFileRemove,
          tenantAgreementType: tenantAgreementType,
        ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Optionally disable button when loading
                if (tenantAgreement!=null && resolutionNoteController.text.isNotEmpty) {
                  context.read<TechnicianHomeBloc>().add(AddComplaintResolution(complaintId: response!.id!, resolutionNote: resolutionNoteController.text, file: tenantAgreement!));
                }else{
                  CustomSnackBar.show(context: context, message: "Please fill all the fields", type: SnackBarType.error);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButtonColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _submitLoading ?
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.0,
              )
              : const Text('Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonTextColor)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRejectedCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resolution', style: Theme
              .of(context)
              .textTheme
              .titleLarge),
          const SizedBox(height: 16),
          Text(
            'Resolution Rejected',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            response?.resolution?.rejectedNote ?? 'NA',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red.shade700,
            ),
          ),
          TextField(
            controller: resolutionNoteController,
            maxLines: 4,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Describe how you resolved the issue...',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              fillColor: AppColors.appBarBackground,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ResolutionUploadCard(
          title: 'Resolution Attachment',
          subtitle: 'Please provide image',
          file: tenantAgreement,
          onUpload: () => DocumentPickerUtils.showDocumentPickerSheet(context: context, onPickImage: _pickImage, isOnlyImage: true, onPickPDF: null),
          onRemove: _tenantFileRemove,
          tenantAgreementType: tenantAgreementType,
        ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Optionally disable button when loading
                if (tenantAgreement!=null && resolutionNoteController.text.isNotEmpty) {
                  context.read<TechnicianHomeBloc>().add(AddComplaintResolution(complaintId: response!.id!, resolutionNote: resolutionNoteController.text, file: tenantAgreement!));
                }else{
                  CustomSnackBar.show(context: context, message: "Please fill all the fields", type: SnackBarType.error);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButtonColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _submitLoading ?
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3.0,
              )
              : const Text('Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.buttonTextColor)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                    color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildUnderReviewCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.2),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.timelapse,
            color: Colors.orange,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resolution Under Review',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your resolution has been submitted and is currently under review by the management team. You will be notified once it’s approved.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isResolved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (response?.status != 'pending' ? Colors.green : Colors.blue).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isResolved ? Colors.green : Colors.blue),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            response?.status != 'pending' ? Icons.check_circle : Icons.person_pin_circle,
            color: response?.status != 'pending' ? Colors.green : Colors.blue,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            response?.status??'NA',
            style: TextStyle(
              color: isResolved ? Colors.green : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _tenantFileRemove(){
    setState(() => tenantAgreement = null);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final File? image = await MediaPickerHelper.pickImageFile(context: context, source: source);

      if (image != null) {
        final String fileExtension = path.extension(image.path).toLowerCase();

        setState(() {
          tenantAgreement = image;
          tenantAgreementType = fileExtension;
        });
      }
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Error picking image: $e',
        type: SnackBarType.error,
      );
    }
  }
}