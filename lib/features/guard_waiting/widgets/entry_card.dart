import 'package:flutter/material.dart';

import '../models/entry.dart';

class EntryCard extends StatelessWidget {
  final Entry data;

  const EntryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 4,
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
                    CircleAvatar(
                      backgroundImage: data.profileImg != null &&
                              !data.profileImg!.contains('assets')
                          ? NetworkImage(data.profileImg!)
                          : AssetImage(data.profileImg!) as ImageProvider,
                      radius: 50, // Increased radius for larger image circle
                      child: GestureDetector(
                        onTap: () {
                          _showImageDialog(data.profileImg, context);
                        },
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
                            ),
                            overflow: TextOverflow.ellipsis, // Handle overflow
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              data.entryType!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.apartment,
                                color: Colors.grey,
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
                                      color: Colors.grey,
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
                      backgroundColor: Colors.orange,
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
                        color: Colors.white,
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

  void _showImageDialog(String? imageUrl, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent, // Transparent background
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  color:
                      Colors.white, // White background for the image container
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Fit to image size
                    children: [
                      imageUrl!.contains("assets")
                          ? Image.asset(
                              imageUrl,
                              height: MediaQuery.of(context).size.height *
                                  0.5, // Constrain the height
                              width: double
                                  .infinity, // Expand to the width of the dialog
                              fit: BoxFit
                                  .contain, // Contain image within the space, maintaining aspect ratio
                            )
                          : Image.network(
                              imageUrl,
                              height: MediaQuery.of(context).size.height *
                                  0.5, // Constrain the height
                              width: double
                                  .infinity, // Expand to the width of the dialog
                              fit: BoxFit
                                  .contain, // Contain image within the space, maintaining aspect ratio
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 100);
                              },
                            ),
                    ],
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
