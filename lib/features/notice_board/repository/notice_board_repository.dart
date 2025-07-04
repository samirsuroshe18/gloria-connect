import 'dart:convert';
import 'dart:io';

import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class NoticeBoardRepository {

  Future<Notice> createNotice({required String title, required String description, required String category, File? file}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      const apiUrlFile = '${ServerConstant.baseUrl}/api/v1/notice/create-notice';

      // Multipart request for both file and text fields
      var request = http.MultipartRequest('POST', Uri.parse(apiUrlFile))
        ..headers['Authorization'] = 'Bearer $accessToken';

      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category'] = category;
      if (file != null)request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle the response
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return Notice.fromJson(jsonResponse['data']);
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

  Future<NoticeBoardModel> updateNotice({required String id, required String title, required String description, File? file, String? image}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      final apiUrlFile =
          '${ServerConstant.baseUrl}/api/v1/notice/update-notice/$id';

      // Multipart request for both file and text fields
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrlFile))
        ..headers['Authorization'] = 'Bearer $accessToken';

      request.fields['title'] = title;
      request.fields['description'] = description;
      if (image != null) request.fields['image'] = image;
      if (file != null) request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle the response
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NoticeBoardModel.fromJson(jsonResponse['data']);
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

  Future<NoticeBoardModel> getAllNotices({ required Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/get-notices';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NoticeBoardModel.fromJson(jsonBody['data']);
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

  Future<NoticeBoardModel> getNotice({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/get-notice/$id';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NoticeBoardModel.fromJson(jsonBody['data']);
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

  Future<NoticeBoardModel> deleteNotice({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrl =
          '${ServerConstant.baseUrl}/api/v1/notice/delete-notice/$id';
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NoticeBoardModel.fromJson(jsonBody['data']);
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

  Future<List<NoticeBoardModel>> unreadNotice() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          '${ServerConstant.baseUrl}/api/v1/notice/is-unread-notice';
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
            .map((data) => NoticeBoardModel.fromJson(data))
            .toList();
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
