import 'dart:convert';
import 'dart:io';

import 'package:gloria_connect/constants/server_constant.dart';
import 'package:gloria_connect/features/technician_home/models/resolution_model.dart';
import 'package:gloria_connect/utils/api_error.dart';
import 'package:gloria_connect/utils/auth_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TechnicianHomeRepository{

  Future<List<ResolutionElement>> getAssignComplaints() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/get-assigned-complaints';

      final response = await AuthHttpClient.instance.get(apiUrl);

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

  Future<List<ResolutionElement>> getResolvedComplaints() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/get-resolved-complaints';

      final response = await AuthHttpClient.instance.get(apiUrl);

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

  Future<ResolutionElement> getTechnicianDetails({required String complaintId}) async {
    try {
      Map<String, dynamic> payload = {
        'complaintId': complaintId,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/get-technician-details';

      final response = await AuthHttpClient.instance.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(payload),
      );

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

  Future<ResolutionElement> addComplaintResolution({required String complaintId, required String resolutionNote, required File file}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrlFile = '${ServerConstant.baseUrl}/api/v1/technician/add-complaint-resolution';
      final Map<String, String> fields = {};
      List<http.MultipartFile> files = [];

      fields['resolutionNote'] = resolutionNote;
      fields['complaintId'] = complaintId;
      files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await AuthHttpClient.instance.multipartRequest(
        'POST',
        apiUrlFile,
        fields: fields,
        files: files,
      );

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

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/approve-resolution';

      final response = await AuthHttpClient.instance.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
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

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/technician/reject-resolution';

      final response = await AuthHttpClient.instance.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
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