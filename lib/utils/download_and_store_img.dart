import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String?> downloadAndSaveImage(String url, String fileName) async {
  try {
    final response = await http.get(Uri.parse(url));
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  } catch (e) {
    debugPrint("Error saving image: $e");
    return null;
  }
}