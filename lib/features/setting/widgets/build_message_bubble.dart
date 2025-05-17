import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class BuildMessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final String userId;
  const BuildMessageBubble({super.key, required this.message, required this.userId});

  @override
  Widget build(BuildContext context) {
    final isMe = userId == message['responseBy']['_id'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) CustomCachedNetworkImage(
            size: 32,
            borderWidth: 1,
            errorImage: Icons.person,
            isCircular: true,
            imageUrl: message['responseBy']['profile'],
            onTap: ()=> CustomFullScreenImageViewer.show(
                context,
                message['responseBy']['profile']
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.black.withOpacity(0.2)
                    : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message['responseBy']['userName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      if (message['responseBy']['role'] == 'admin')
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.white.withOpacity(0.2)
                                : Theme.of(context)
                                .primaryColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['message'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, h:mm a').format(
                      DateTime.parse(message['date']).toLocal(),
                    ),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isMe) CustomCachedNetworkImage(
            size: 32,
            borderWidth: 1,
            errorImage: Icons.person,
            isCircular: true,
            imageUrl: message['responseBy']['profile'],
            onTap: ()=> CustomFullScreenImageViewer.show(
                context,
                message['responseBy']['profile']
            ),
          ),
        ],
      ),
    );
  }
}
