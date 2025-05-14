import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gloria_connect/features/auth/widgets/date_picker_field.dart';
import 'package:gloria_connect/utils/document_picker_utils.dart';
import 'package:image_picker/image_picker.dart';

import 'document_upload_card.dart';

class VerificationSection extends StatelessWidget {
  final String? ownershipStatus;
  final File? ownershipDocument;
  final String? tenantAgreementType;
  final String? ownershipDocumentType;
  final File? tenantAgreement;
  final VoidCallback ownerFileRemove;
  final VoidCallback tenantFileRemove;
  final TextEditingController startDateController;
  final Future<void> Function(BuildContext, bool) selectDate;
  final TextEditingController endDateController;
  final Future<void> Function(ImageSource) onPickImage;
  final Future<void> Function() onPickPDF;

  const VerificationSection({super.key, this.ownershipStatus, this.ownershipDocument, required this.ownerFileRemove, this.tenantAgreementType, this.ownershipDocumentType, this.tenantAgreement, required this.tenantFileRemove, required this.startDateController, required this.selectDate, required this.endDateController, required this.onPickImage, required this.onPickPDF});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        if (ownershipStatus == 'Owner')
          DocumentUploadCard(
            title: 'Upload Ownership Document',
            subtitle: 'Please provide your Index2 or Resident Smart card photo',
            file: ownershipDocument,
            onUpload: () => DocumentPickerUtils.showDocumentPickerSheet(context: context, onPickImage: onPickImage, onPickPDF: onPickPDF),
            onRemove: ownerFileRemove,
            isOwner: ownershipStatus == 'Owner',
            tenantAgreementType: tenantAgreementType,
            ownershipDocumentType: ownershipDocumentType,
          )
        else if (ownershipStatus == 'Tenant')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Agreement Duration'),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: DatePickerField(
                      controller: startDateController,
                      label: 'Start Date',
                      onTap: () => selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DatePickerField(
                      controller: endDateController,
                      label: 'End Date',
                      onTap: () => selectDate(context, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              DocumentUploadCard(
                title: 'Upload Rental Agreement',
                subtitle: 'Please provide your rental agreement document',
                file: tenantAgreement,
                onUpload: () => DocumentPickerUtils.showDocumentPickerSheet(context: context, onPickImage: onPickImage, onPickPDF: onPickPDF),
                onRemove: tenantFileRemove,
                isOwner: ownershipStatus == 'owner',
                tenantAgreementType: tenantAgreementType,
                ownershipDocumentType: ownershipDocumentType,
              ),
            ],
          ),
      ],
    );
  }
}
