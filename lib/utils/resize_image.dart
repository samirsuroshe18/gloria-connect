import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
// import 'dart:typed_data';

Future<File?> resizeImage(File? imageFile, {int width = 800, int quality = 85}) async {
  try {
    if (imageFile != null) {
      // Read the image bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Decode the image
      img.Image? image = img.decodeImage(imageBytes);

      if (image != null) {
        // Resize the image to the specified width, maintaining aspect ratio
        img.Image resizedImage = img.copyResize(image, width: width);

        // Encode the resized image with the specified quality
        Uint8List resizedImageBytes = Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));

        // Write the resized image back to a file
        File resizedImageFile = await File(imageFile.path).writeAsBytes(resizedImageBytes);

        return resizedImageFile; // Return the resized image file
      }
    } else {
      return null;
    }
  } catch (e) {
    debugPrint("Error resizing image: $e");
  }
  return null;
}
