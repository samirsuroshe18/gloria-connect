import 'package:flutter/material.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';

class NoticeCard extends StatelessWidget {
  final NoticeBoardModel data;
  const NoticeCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(data.title ?? 'No Title'),
        subtitle: Text(
          data.description ?? 'No Description',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        leading: data.image != null && data.image is String
            ? Image.network(
                data.image ?? "",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image,
                      size: 50, color: Colors.red);
                },
              )
            : null,
        onTap: () {
          Navigator.pushNamed(context, '/notice-board-details-screen',
              arguments: data);
        },
      ),
    );
  }
}
