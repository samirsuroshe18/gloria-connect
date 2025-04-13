import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_error.dart';

class GuardEntryRepository {

  Future<Map<String, dynamic>> addDeliveryEntry({
    required String name,
    required String mobNumber,
    required dynamic profileImg,
    String? companyName,
    String? companyLogo,
    String? serviceName,
    String? serviceLogo,
    String? accompanyingGuest,
    String? vehicleType,
    String? vehicleNumber,
    required String entryType,
    required String societyName,
    required List<Map<String, String>> societyApartments,
    required String societyGates,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final Map<String, dynamic> data = {
      'name': name,
      'mobNumber': mobNumber,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'serviceName': serviceName,
      'serviceLogo': serviceLogo,
      'entryType': entryType,
      'accompanyingGuest': accompanyingGuest,
      'vehicleDetails': {
        'vehicleType': vehicleType,
        'vehicleNumber': vehicleNumber
      },
      'societyDetails': {
        'societyName': societyName,
        'societyApartments': societyApartments,
        'societyGates': societyGates
      }
    };

    try {
      // Determine which API URL to use based on whether it's a multipart request
      const apiUrlString =
          'https://invite.iotsense.in/api/v1/delivery-entry/add-delivery-entry-2';
      const apiUrlFile =
          'https://invite.iotsense.in/api/v1/delivery-entry/add-delivery-entry';

      http.Response response;

      if (profileImg is String) {
        // Normal POST request
        data['profileImg'] = profileImg;

        response = await http.post(
          Uri.parse(apiUrlString),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(data),
        );
      } else if (profileImg is File) {
        // Multipart request for uploading the image file
        var request = http.MultipartRequest('POST', Uri.parse(apiUrlFile))
          ..headers['Authorization'] = 'Bearer $accessToken';

        // Add fields (convert complex objects to JSON strings)
        request.fields['name'] = name;
        request.fields['mobNumber'] = mobNumber;
        companyName != null
            ? request.fields['companyName'] = companyName
            : null;
        companyLogo != null
            ? request.fields['companyLogo'] = companyLogo
            : null;
        serviceName != null
            ? request.fields['serviceName'] = serviceName
            : null;
        serviceLogo != null
            ? request.fields['serviceLogo'] = serviceLogo
            : null;
        accompanyingGuest != null
            ? request.fields['accompanyingGuest'] = accompanyingGuest
            : null;
        request.fields['entryType'] = entryType;

        // Convert vehicleDetails and societyDetails to JSON strings
        request.fields['vehicleDetails'] = jsonEncode({
          'vehicleType': vehicleType,
          'vehicleNumber': vehicleNumber,
        });
        request.fields['societyDetails'] = jsonEncode({
          'societyName': societyName,
          'societyApartments': societyApartments,
          'societyGates': societyGates,
        });

        // Add the profile image file
        request.files.add(
            await http.MultipartFile.fromPath('profileImg', profileImg.path));

        // Send the multipart request and get the response
        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        throw ApiError(message: 'Invalid profileImg type.');
      }

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<Map<String, dynamic>> approveDeliveryEntry({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> data = {
        'id': id,
      };
      const apiKey =
          'https://invite.iotsense.in/api/v1/delivery-entry/approve-delivery';
      final response = await http.post(
        Uri.parse(apiKey),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody;
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<Map<String, dynamic>> rejectDeliveryEntry({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> data = {
        'id': id,
      };
      const apiKey =
          'https://invite.iotsense.in/api/v1/delivery-entry/reject-delivery';
      final response = await http.post(
        Uri.parse(apiKey),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody;
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<Map<String, dynamic>> checkInByCode(
      {required String checkInCode}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> data = {
        'checkInCode': checkInCode,
      };
      const apiKey =
          'https://invite.iotsense.in/api/v1/check-in-by-code/add-entry';
      final response = await http.post(
        Uri.parse(apiKey),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody;
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }
}
