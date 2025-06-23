import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import '../models/complaint_model.dart';

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;

  const ComplaintDetailsScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    final isResolved = complaint.status == 'Resolved';
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(26, 34, 65, 1.0),
            Color.fromRGBO(42, 29, 61, 1.0),
            Color.fromRGBO(78, 25, 51, 1.0)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complaint Details'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildComplaintInfoCard(context, isResolved),
              const SizedBox(height: 24),
              isResolved
                  ? _buildResolutionInfoCard(context)
                  : _buildResolutionInputCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintInfoCard(BuildContext context, bool isResolved) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (complaint.imageUrl != null)
                GestureDetector(
                  onTap: () {
                    CustomFullScreenImageViewer.show(
                        context, complaint.imageUrl,
                        errorImage: Icons.image);
                  },
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CustomCachedNetworkImage(
                      imageUrl: complaint.imageUrl!,
                      isCircular: true,
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
    Text(
    complaint.title,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
                          ),
    ),
                    const SizedBox(height: 8),
                    _buildStatusChip(isResolved),
                    const SizedBox(height: 16),
                    _buildDetailRow('Category:', complaint.category, context),
                    _buildDetailRow('Date:', complaint.date, context),
                    _buildDetailRow('Resident:', complaint.residentName, context),
                    _buildDetailRow('Flat:', complaint.flatNumber, context),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Description',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(complaint.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  color: AppColors.iconColor, size: 20),
              const SizedBox(width: 8),
              Text('Assigned to: ${complaint.assignedTo}',
                  style: Theme.of(context)
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
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              Text('Resolution completed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            complaint.resolutionNotes ?? 'No notes provided.',
            style:
            Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionInputCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resolution', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
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
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.appBarBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider, width: 1),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file,
                      color: AppColors.iconColor, size: 30),
                  SizedBox(height: 8),
                  Text('Upload Photo',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButtonColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit',
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isResolved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isResolved ? Colors.green : Colors.blue).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isResolved ? Colors.green : Colors.blue),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isResolved ? Icons.check_circle : Icons.person_pin_circle,
            color: isResolved ? Colors.green : Colors.blue,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            complaint.status,
            style: TextStyle(
              color: isResolved ? Colors.green : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}