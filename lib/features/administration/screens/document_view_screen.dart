import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class DocumentViewScreen extends StatefulWidget {
  final String? documentUrl;
  final String? title;
  final bool? isTenantAgreement;
  final String? startDate;
  final String? endDate;

  const DocumentViewScreen({
    super.key,
    this.documentUrl,
    this.title,
    this.isTenantAgreement = false,
    this.startDate,
    this.endDate,
  });

  @override
  State<DocumentViewScreen> createState() => _DocumentViewScreenState();
}

class _DocumentViewScreenState extends State<DocumentViewScreen> {
  bool _isLoading = true;
  String? _localPath;
  bool _isPDF = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    setState(() => _isLoading = true);
    try {
      _isPDF = widget.documentUrl!.toLowerCase().endsWith('.pdf');

      if (_isPDF || widget.documentUrl!.toLowerCase().endsWith(('.jpg')) ||
          widget.documentUrl!.toLowerCase().endsWith(('.png'))) {
        final response = await http.get(Uri.parse(widget.documentUrl!));
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/document${_isPDF ? '.pdf' : '.jpg'}');
        await file.writeAsBytes(bytes);
        _localPath = file.path;
      }
    } catch (e) {
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading document: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Downloads the document to the device's download directory
  Future<void> _downloadDocument() async {
    if (widget.documentUrl == null) return;

    setState(() => _isDownloading = true);
    try {
      // Fetch the document
      final response = await http.get(Uri.parse(widget.documentUrl!));

      // Get the download directory
      final downloadDir = await getDownloadsDirectory();
      if (downloadDir == null) {
        throw Exception('Could not access download directory');
      }

      // Create a file with a unique name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = _isPDF ? '.pdf' : '.jpg';
      final file = File('${downloadDir.path}/document_$timestamp$fileExtension');

      // Write bytes and save the file
      await file.writeAsBytes(response.bodyBytes);

      // Show success message
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document downloaded to ${file.path}')),
      );
    } catch (e) {
      // Handle download errors
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  /// Shares the document using share_plus package
  Future<void> _shareDocument() async {
    if (widget.documentUrl == null) return;

    try {
      // If local file exists, share the local file
      if (_localPath != null) {
        await Share.shareXFiles([XFile(_localPath!)], text: widget.title);
        return;
      }

      // If no local file, share the URL
      await Share.share(widget.documentUrl!, subject: widget.title);
    } catch (e) {
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sharing failed: $e')),
      );
    }
  }

  Widget _buildDocumentView() {
    if (_isPDF && _localPath != null) {
      return PDFView(
        filePath: _localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        onError: (error) {
          debugPrint(error.toString());
        },
        onPageError: (page, error) {
          debugPrint('$page: ${error.toString()}');
        },
      );
    } else {
      return PhotoView(
        imageProvider: NetworkImage(widget.documentUrl!),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        title: Text(widget.title!, style: const TextStyle(color: Colors.white),),
        actions: [
          // Download button with loading indicator
          IconButton(
            icon: _isDownloading
                ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2)
            )
                : const Icon(Icons.file_download),
            onPressed: _isDownloading ? null : _downloadDocument,
          ),
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareDocument,
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.isTenantAgreement! && widget.startDate != null && widget.endDate != null)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDateInfo('Start Date', widget.startDate!),
                  const SizedBox(width: 16),
                  _buildDateInfo('End Date', widget.endDate!),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildDocumentView(),
          ),
        ],
      ),
    );
  }

  // Rest of the existing helper methods remain unchanged
  Widget _buildDateInfo(String label, String date) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}