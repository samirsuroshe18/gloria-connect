import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:gloria_connect/utils/custom_snackbar.dart';
import 'package:path/path.dart' as path;

class PdfPreviewScreen extends StatefulWidget {
  final File file;
  const PdfPreviewScreen({super.key, required this.file});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  bool _isLoading = true; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        title: Text(
          path.basename(widget.file.path),
          style: const TextStyle(color: Colors.white70),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          PDFView(
            filePath: widget.file.path,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageSnap: true,
            onRender: (pages) {
              setState(() {
                _isLoading = false; // Hide loading when rendering is complete
              });
            },
            onError: (error) {
              CustomSnackbar.show(
                context: context,
                message: error,
                type: SnackbarType.error,
              );
            },
          ),

          // Show loading indicator while PDF is loading
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3), // Slight dim effect
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white, // White spinner for contrast
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

