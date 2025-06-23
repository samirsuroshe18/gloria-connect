import 'dart:convert';
import 'dart:io';

import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:gloria_connect/features/technician_home/models/resolution_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class TechnicianHomeRepository{

  Future<List<ResolutionElement>> getAssignComplaints() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/get-assigned-complaints';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => ResolutionElement.fromJson(data))
            .toList();
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

  Future<ResolutionElement> addComplaintResolution({required String complaintId, required String resolutionNote, required File file}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrlFile = '${ServerConstant.baseUrl}/api/v1/technician/add-complaint-resolution';

      // Multipart request for both file and text fields
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrlFile))
        ..headers['Authorization'] = 'Bearer $accessToken';

      request.fields['complaintId'] = complaintId;
      request.fields['resolutionNote'] = resolutionNote;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle the response
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ResolutionElement.fromJson(jsonBody['data']);
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

  Future<Map<String, dynamic>> approveResolution({required String resolutionId}) async {
    try {
      final Map<String, dynamic> payload = {
        'resolutionId': resolutionId,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/approve-resolution';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonBody['data'];
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

  Future<Map<String, dynamic>> rejectResolution({required String resolutionId, required String rejectedNote}) async {
    try {
      final Map<String, dynamic> payload = {
        'resolutionId': resolutionId,
        'rejectedNote': rejectedNote,
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/reject-resolution';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonBody['data'];
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