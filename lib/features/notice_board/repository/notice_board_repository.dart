import 'dart:convert';
import 'dart:io';

import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/utils/auth_http_client.dart';
import 'package:http/http.dart' as http;

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class NoticeBoardRepository {

  Future<Notice> createNotice({required String title, required String description, required String category, File? file}) async {
    try {
      const apiUrlFile = '${ServerConstant.baseUrl}/api/v1/notice/create-notice';
      final Map<String, String> fields = {};
      List<http.MultipartFile> files = [];

      fields['title'] = title;
      fields['description'] = description;
      fields['category'] = category;
      if (file != null) files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await AuthHttpClient.instance.multipartRequest(
        'POST',
        apiUrlFile,
        fields: fields,
        files: files,
      );

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
    try {
      final apiUrlFile = '${ServerConstant.baseUrl}/api/v1/notice/update-notice/$id';
      final Map<String, String> fields = {};
      List<http.MultipartFile> files = [];

      fields['title'] = title;
      fields['description'] = description;
      if(image!=null)fields['image'] = image;
      if (file != null) files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await AuthHttpClient.instance.multipartRequest(
        'PUT',
        apiUrlFile,
        fields: fields,
        files: files,
      );

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
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/get-notices';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

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
      final apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/get-notice/$id';

      final response = await AuthHttpClient.instance.get(apiUrl);

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
      final apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/delete-notice/$id';

      final response = await AuthHttpClient.instance.delete(apiUrl);

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
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/notice/is-unread-notice';

      final response = await AuthHttpClient.instance.get(apiUrl);

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
