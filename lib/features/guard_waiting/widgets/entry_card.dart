import 'package:flutter/material.dart';
import 'package:gloria_connect/common_widgets/custom_cached_network_image.dart';
import 'package:gloria_connect/common_widgets/custom_full_screen_image_viewer.dart';

import '../models/entry.dart';

class EntryCard extends StatelessWidget {
  final VisitorEntries data;

  const EntryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomCachedNetworkImage(
                      imageUrl: data.profileImg,
                      size: 90,
                      isCircular: true,
                      borderWidth: 2,
                      errorImage: Icons.person,
                      onTap: ()=> CustomFullScreenImageViewer.show(
                          context,
                          data.profileImg
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name!,
                            style: const TextStyle(
                              fontSize: 20, // Larger font size for name
                              fontWeight: FontWeight.bold,
                              color: Colors.white70
                            ),
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              data.entryType!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.apartment,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                // Wrap Text with Expanded
                                child: Text(
                                  data.societyDetails!.societyApartments!
                                      .map((item) => item.apartment as String)
                                      .toList()
                                      .join(', '),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                      overflow: TextOverflow
                                          .ellipsis // Handle overflow
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Full-width VIEW APPROVALS button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/view-resident-approval',
                          arguments: data);
                    },
                    child: const Text(
                      'VIEW APPROVALS',
                      style: TextStyle(
                        color: Colors.white70,
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
      ],
    );
  }
}
