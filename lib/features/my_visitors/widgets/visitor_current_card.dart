import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../guard_waiting/models/entry.dart';

class VisitorCurrentCard extends StatelessWidget {
  final Entry data;

  const VisitorCurrentCard({super.key, required this.data});

  void _makePhoneCall(String? phoneNo) async {
    // Check if the phone number is valid
    if (phoneNo == null || phoneNo.isEmpty) {
      // Optionally show an error message to the user
      print('Invalid phone number');
      return;
    }

    // Create the URI using Uri.parse
    final Uri url = Uri.parse('tel:$phoneNo');

    // Check if the device supports launching the URL
    if (await canLaunchUrl(url)) {
      try {
        await launchUrl(url);
      } catch (e) {
        // Handle any errors during launch
        print('Error launching URL: $e');
        // Optionally show an error message
      }
    } else {
      // Inform the user the action isn't supported
      print('Could not launch $url');
      // Optionally show a dialog or snackbar
    }
  }

  // void _makePhoneCall(BuildContext context) async {
  //   final String phoneNumber = data.mobNumber?.replaceAll(RegExp(r'[^\d+]'), '') ?? '';
  //   if (phoneNumber.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Phone number is not available'),
  //         duration: Duration(seconds: 2),
  //         behavior: SnackBarBehavior.floating,
  //       ),
  //     );
  //     return;
  //   }
  //
  //   final Uri uri = Uri.parse('tel:$phoneNumber');
  //   try {
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Could not launch phone app'),
  //           duration: Duration(seconds: 2),
  //           behavior: SnackBarBehavior.floating,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${e.toString()}'),
  //         duration: const Duration(seconds: 2),
  //         behavior: SnackBarBehavior.floating,
  //       ),
  //     );
  //   }
  // }

  Color _getStatusColor() {
    switch (data.entryType?.toLowerCase() ?? data.profileType?.toLowerCase()) {
      case 'delivery':
        return const Color(0xFF2196F3); // Blue
      case 'service':
        return const Color(0xFF1976D2); // Darker Blue
      case 'guest':
        return const Color(0xFF42A5F5); // Lighter Blue
      default:
        return const Color(0xFF0D47A1); // Very Dark Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showImageDialog(context, data),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileImage(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _buildTimeInfo(),
                          ),
                          const SizedBox(height: 12),
                          _buildApprovalInfo(),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1),
                ),
                _buildCallButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Hero(
      tag: 'visitor-${data.id}',
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _getStatusColor(),
            width: 2,
          ),
        ),
        child: ClipOval(
          child: data.entryType == 'service'
              ? Image.network(
            data.profileImg!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
            ),
          )
              : data.allowedBy != null && data.approvedBy?.user != null
              ? Image.asset(
            data.profileImg!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
            ),
          )
              : data.profileImg != null
              ? Image.network(
            data.profileImg!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
            ),
          )
              : Image.asset(
            'assets/images/profile.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            data.name!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            data.entryType ?? data.profileType!,
            style: TextStyle(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInfoChip(
          Icons.access_time_rounded,
          DateFormat('hh:mm a').format(data.entryTime!),
        ),
        const SizedBox(width: 12),
        _buildInfoChip(
          Icons.calendar_today_rounded,
          DateFormat('dd MMM, yyyy').format(data.entryTime!),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.approvedBy?.user != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _buildInfoRow(
              Icons.check_circle_outline_rounded,
              'Approved by ${data.allowedBy != null ? data.approvedBy!.user!.userName : data.societyDetails?.societyApartments?[0].entryStatus?.approvedBy?.userName ?? 'NA'}',
            ),
          ),
        _buildInfoRow(
          Icons.security_rounded,
          'Allowed by Guard (${data.allowedBy != null ? data.allowedBy!.user!.userName : data.guardStatus!.guard!.userName})',
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCallButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _makePhoneCall(data.mobNumber),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getStatusColor(),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Call Visitor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showImageDialog(BuildContext context) {
  //   if (data.profileImg == null) return;
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: Colors.transparent,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           child: Stack(
  //             clipBehavior: Clip.none,
  //             children: [
  //               Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   ClipRRect(
  //                     borderRadius: const BorderRadius.vertical(
  //                       top: Radius.circular(16),
  //                     ),
  //                     child: Hero(
  //                       tag: 'visitor-${data.id}',
  //                       child: data.profileImg!.contains("assets")
  //                           ? Image.asset(
  //                         data.profileImg!,
  //                         height: MediaQuery.of(context).size.height * 0.4,
  //                         width: double.infinity,
  //                         fit: BoxFit.cover,
  //                       )
  //                           : Image.network(
  //                         data.profileImg!,
  //                         height: MediaQuery.of(context).size.height * 0.4,
  //                         width: double.infinity,
  //                         fit: BoxFit.cover,
  //                         errorBuilder: (_, __, ___) => const Icon(
  //                           Icons.error_outline_rounded,
  //                           size: 100,
  //                           color: Colors.grey,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(16),
  //                     child: Text(
  //                       data.name!,
  //                       style: const TextStyle(
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Positioned(
  //                 top: -20,
  //                 right: -20,
  //                 child: Material(
  //                   color: Colors.transparent,
  //                   child: InkWell(
  //                     onTap: () => Navigator.of(context).pop(),
  //                     borderRadius: BorderRadius.circular(30),
  //                     child: Container(
  //                       padding: const EdgeInsets.all(8),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         shape: BoxShape.circle,
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.black.withOpacity(0.1),
  //                             spreadRadius: 1,
  //                             blurRadius: 5,
  //                           ),
  //                         ],
  //                       ),
  //                       child: const Icon(
  //                         Icons.close_rounded,
  //                         color: Colors.black87,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showImageDialog(BuildContext context, Entry data) {
    if (data.profileImg == null) return;

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 500,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main Content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Container
                    Hero(
                      tag: 'visitor-${data.id}',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Image
                            Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              child: data.profileImg!.contains("assets")
                                  ? Image.asset(
                                data.profileImg!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                data.profileImg!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image_rounded,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Image not available',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Image Overlay Gradient
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 80,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Visitor Information
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name ?? 'Visitor',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (data.entryTime != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Visited on ${_formatDateTime(data.entryTime!)}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                // Close Button
                Positioned(
                  top: 16,
                  right: 16,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}