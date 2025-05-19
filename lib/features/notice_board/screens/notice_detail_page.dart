// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
// import 'package:gloria_connect/utils/custom_snackbar.dart';
// // ignore: depend_on_referenced_packages
// import 'package:intl/intl.dart';
// import 'package:flutter_blurhash/flutter_blurhash.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:open_file/open_file.dart';
//
// class NoticeDetailPage extends StatelessWidget {
//   final Notice data;
//
//   const NoticeDetailPage({super.key, required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     // Get screen size for responsive layout
//     final Size screenSize = MediaQuery.of(context).size;
//     final bool isTablet = screenSize.width > 600;
//
//     // Format date
//     String formattedDate = data.createdAt != null
//         ? DateFormat('EEEE, MMMM d, yyyy • h:mm a').format(data.createdAt!)
//         : 'Date not available';
//
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           // Custom app bar with image if available
//           SliverAppBar(
//             expandedHeight: data.image != null &&
//                     data.image is String &&
//                     data.image!.isNotEmpty
//                 ? 240.0
//                 : 0.0,
//             pinned: true,
//             backgroundColor: Colors.black.withValues(alpha: 0.2),
//             leading: IconButton(
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.arrow_back, color: Colors.white70),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//             actions: [
//               IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.2),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(Icons.share, color: Colors.white70),
//                 ),
//                 onPressed: () async {
//                   String shareText =
//                       'Check out this important notice: ${data.title}\n\n${data.description}';
//
//                   if (data.image != null && data.image!.isNotEmpty) {
//                     try {
//                       // Download the image
//                       final response = await http.get(Uri.parse(data.image!));
//                       final bytes = response.bodyBytes;
//
//                       // Get temporary directory
//                       final tempDir = await getTemporaryDirectory();
//                       final file = File('${tempDir.path}/notice_image.jpg');
//
//                       // Save the image
//                       await file.writeAsBytes(bytes);
//
//                       // Share image + text
//                       await Share.shareXFiles(
//                         [XFile(file.path)],
//                         text: shareText,
//                         subject: data.title,
//                       );
//                     } catch (e) {
//                       debugPrint('Error sharing image: $e');
//                       // Fallback to text only
//                       await Share.share(
//                         shareText,
//                         subject: data.title,
//                       );
//                     }
//                   } else {
//                     // Share text only
//                     await Share.share(
//                       shareText,
//                       subject: data.title,
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(width: 8),
//             ],
//             // ✅ FIXED HERE: only render if valid image
//             flexibleSpace: (data.image != null && data.image!.isNotEmpty)
//                 ? FlexibleSpaceBar(
//               background: Hero(
//                 tag: 'notice-image-${data.id}',
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     CachedNetworkImage(
//                       imageUrl: data.image!,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => const BlurHash(
//                         hash: "L6PZfSi_.AyE_3t7t7R**0o#DgR4",
//                         imageFit: BoxFit.cover,
//                       ), // ✅ FIXED HERE: removed image param
//                       errorWidget: (context, url, error) => Container(
//                         color: Colors.grey[200],
//                         child: const Icon(
//                           Icons.image_not_supported,
//                           size: 50,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     Positioned.fill(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withValues(alpha: 0.7),
//                             ],
//                             stops: const [0.6, 1.0],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//                 : null,
//           ),
//
//           // Content
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: isTablet ? screenSize.width * 0.1 : 20,
//                 vertical: 24,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Category chip
//                   if (data.category != null && data.category!.isNotEmpty)
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withValues(alpha: 0.2), // background of chip container
//                         borderRadius: BorderRadius.circular(20), // match Chip’s roundness
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                         child: Text(
//                           data.category!,
//                             style: const TextStyle(
//                               color: Colors.white70, // your preferred text color
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             )
//                         ),
//                       ),
//                     ),
//
//                   // Title
//                   Text(
//                     data.title ?? 'No Title',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white70,
//                       height: 1.3,
//                     ),
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.calendar_today,
//                         size: 14,
//                         color: Colors.white60,
//                       ),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           formattedDate,
//                           style: const TextStyle(
//                             color: Colors.white60,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   if (data.publishedBy != null &&
//                       (data.publishedBy!.userName?.isNotEmpty ?? false))
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 14,
//                             backgroundColor: Colors.white.withValues(alpha: 0.2),
//                             child: Text(
//                               (data.publishedBy?.userName?.isNotEmpty ?? false)
//                                   ? data.publishedBy!.userName![0].toUpperCase()
//                                   : 'A',
//                               style: const TextStyle(
//                                 color: Colors.white60,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Posted by ${data.publishedBy?.userName ?? "Unknown"}',
//                             style: const TextStyle(
//                               color: Colors.white60,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                   const Divider(
//                     height: 32,
//                     color: Colors.white30,
//                   ),
//
//                   // Description
//                   Text(
//                     data.description ?? 'No Description',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.white60,
//                       height: 1.6,
//                     ),
//                   ),
//                   if (data.image != null && data.image!.isNotEmpty)
//                     _buildAttachments(data.image!, context), // ✅ Only called when image is valid
//
//                   const SizedBox(height: 40),
//
//                   // Action buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton.icon(
//                         onPressed: () async {
//                           String shareText =
//                               'Check out this important notice: ${data.title}\n\n${data.description}';
//                           if (data.image != null && data.image!.isNotEmpty) {
//                             try {
//                               // Download the image
//                               final response = await http.get(Uri.parse(data.image!));
//                               final bytes = response.bodyBytes;
//
//                               // Get temporary directory
//                               final tempDir = await getTemporaryDirectory();
//                               final file = File('${tempDir.path}/notice_image.jpg');
//
//                               // Save the image
//                               await file.writeAsBytes(bytes);
//
//                               // Share image + text
//                               await Share.shareXFiles(
//                                 [XFile(file.path)],
//                                 text: shareText,
//                                 subject: data.title,
//                               );
//                             } catch (e) {
//                               debugPrint('Error sharing image: $e');
//                               // Fallback to text only
//                               await Share.share(
//                                 shareText,
//                                 subject: data.title,
//                               );
//                             }
//                           } else {
//                             // Share text only
//                             await Share.share(
//                               shareText,
//                               subject: data.title,
//                             );
//                           }
//                         },
//                         icon: const Icon(
//                           Icons.share,
//                           size: 18,
//                           color: Colors.white60,
//                         ),
//                         label: const Text(
//                           'Share',
//                           style: TextStyle(color: Colors.white60),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       OutlinedButton.icon(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back,
//                           size: 18,
//                           color: Colors.white60,
//                         ),
//                         label: const Text(
//                           'Back to Notices',
//                           style: TextStyle(color: Colors.white60),
//                         ),
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
//                           side: const BorderSide(color: Color(0xFF3498DB)),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAttachments(String imageUrl, BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 24),
//         const Text(
//           'Attachment',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white70,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Card(
//           color: Colors.black.withValues(alpha: 0.2),
//           margin: const EdgeInsets.only(bottom: 8),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//             side: BorderSide(color: Colors.grey.shade200),
//           ),
//           child: ListTile(
//             leading: const Icon(
//               Icons.image,
//               color: Color(0xFF3498DB),
//             ),
//             title: const Text(
//               'Image Attachment',
//               style: TextStyle(fontSize: 14),
//             ),
//             trailing: IconButton(
//               icon: const Icon(
//                 Icons.download,
//                 color: Color(0xFF3498DB),
//               ),
//               onPressed: () async {
//                 await _downloadFile(imageUrl, context);
//               },
//             ),
//             onTap: () {
//               // Handle open image
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _downloadFile(String url, BuildContext context) async {
//
//   try {
//     CustomSnackBar.show(context: context, message: "Downloading file...", type: SnackBarType.info);
//
//       var response = await http.get(Uri.parse(url));
//       if (!context.mounted) return;
//
//       if (response.statusCode == 200) {
//         Directory? directory = await getExternalStorageDirectory();
//         if (!context.mounted) return;
//
//         if (directory == null) {
//           CustomSnackBar.show(context: context, message: "Unable to find directory.", type: SnackBarType.error);
//           return;
//         }
//
//         String fileName = url.split('/').last;
//         String filePath = "${directory.path}/$fileName";
//
//         File file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);
//
//         if (!context.mounted) return;
//         CustomSnackBar.show(context: context, message: "Downloaded to $filePath", type: SnackBarType.success);
//
//         OpenFile.open(filePath);
//       } else {
//         if (!context.mounted) return;
//         CustomSnackBar.show(context: context, message: "Download failed: Server error.", type: SnackBarType.error);
//       }
//     } catch (e) {
//       if (!context.mounted) return;
//       CustomSnackBar.show(context: context, message: "Download failed: $e", type: SnackBarType.error);
//     }
//   }
// }

// lib/features/notice_board/presentation/pages/notice_detail_page.dart
import 'package:flutter/material.dart';
import 'package:gloria_connect/config/theme/app_colors.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/features/notice_board/widgets/notice_action_buttons.dart';
import 'package:gloria_connect/features/notice_board/widgets/notice_attachment_card.dart';
import 'package:gloria_connect/features/notice_board/widgets/notice_detail_header.dart';
import 'package:gloria_connect/features/notice_board/widgets/notice_metadata.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class NoticeDetailPage extends StatelessWidget {
  final Notice notice;

  const NoticeDetailPage({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;

    // Format date
    String formattedDate = notice.createdAt != null
        ? DateFormat('EEEE, MMMM d, yyyy • h:mm a').format(notice.createdAt!)
        : 'Date not available';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom app bar with image if available
          NoticeDetailHeader(notice: notice),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? screenSize.width * 0.1 : 20,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  if (notice.category != null && notice.category!.isNotEmpty)
                    CategoryChip(category: notice.category!),

                  // Title
                  Text(
                    notice.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Notice metadata (date, author)
                  NoticeMetadata(
                    date: formattedDate,
                    publisher: notice.publishedBy,
                  ),

                  const Divider(
                    height: 32,
                    color: AppColors.divider,
                  ),

                  // Description
                  Text(
                    notice.description ?? 'No Description',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),

                  // Attachment section
                  if (notice.image != null && notice.image!.isNotEmpty)
                    NoticeAttachmentSection(imageUrl: notice.image!),

                  const SizedBox(height: 40),

                  // Action buttons
                  NoticeActionButtons(notice: notice),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Small widget for category display
class CategoryChip extends StatelessWidget {
  final String category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.chipBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
            category,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )
        ),
      ),
    );
  }
}