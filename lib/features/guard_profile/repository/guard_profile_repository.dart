import 'dart:convert';
import 'dart:io';

import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/features/guard_profile/models/checkout_history.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_error.dart';

class GuardProfileRepository{

  Future<Map<String, dynamic>> updateDetails({String? userName, File? profile,}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      const apiUrlFile = 'https://invite.iotsense.in/api/v1/users/update-details';

      // Multipart request for both file and text fields
      var request = http.MultipartRequest('POST', Uri.parse(apiUrlFile))
        ..headers['Authorization'] = 'Bearer $accessToken';

      // Add userName to fields if not null
      if (userName != null && userName.isNotEmpty) {
        request.fields['userName'] = userName;
      }

      // Add the profile image if it is not null
      if (profile != null) {
        request.files.add(await http.MultipartFile.fromPath('profile', profile.path));
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle the response
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonResponse['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<CheckoutHistoryModel> getCheckoutHistory({ required Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrl = Uri.https('invite.iotsense.in', '/api/v1/delivery-entry/get-checkout-history', queryParams);
      final response = await http.get(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CheckoutHistoryModel.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<GatePassBanner> addGatePass({String? name, File? profile, String? mobNumber, String? gender, String? serviceName, String? serviceLogo, String? address, File? addressProof, List<Map<String, String>>? gatepassAptDetails, String? checkInCodeStartDate, String? checkInCodeExpiryDate, String? checkInCodeStart, String? checkInCodeExpiry,}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      const apiUrlFile = 'https://invite.iotsense.in/api/v1/invite-visitors/add-gate-pass';

      // Multipart request for both file and text fields
      var request = http.MultipartRequest('POST', Uri.parse(apiUrlFile))
        ..headers['Authorization'] = 'Bearer $accessToken';

      request.fields['name'] = name!;
      request.files.add(await http.MultipartFile.fromPath('files', profile!.path));
      request.fields['mobNumber'] = mobNumber!;
      request.fields['gender'] = gender!;
      request.fields['serviceName'] = serviceName!;
      request.fields['serviceLogo'] = serviceLogo!;
      request.fields['address'] = address!;
      request.files.add(await http.MultipartFile.fromPath('files', addressProof!.path));
      request.fields['entryType'] = 'service';
      request.fields['gatepassApiDetails'] = jsonEncode(gatepassAptDetails);
      request.fields['checkInCodeStartDate'] = checkInCodeStartDate!;
      request.fields['checkInCodeExpiryDate'] = checkInCodeExpiryDate!;
      request.fields['checkInCodeStart'] = checkInCodeStart!;
      request.fields['checkInCodeExpiry'] = checkInCodeExpiry!;

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle the response
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GatePassBanner.fromJson(jsonResponse['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonResponse['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<GatePassModel> getGatePass({ required Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrl = Uri.https('invite.iotsense.in', '/api/v1/invite-visitors/get-gate-pass', queryParams);
      final response = await http.get(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GatePassModel.fromJson(jsonBody['data']);
      } else {
        throw ApiError(
            statusCode: response.statusCode, message: jsonBody['message']);
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