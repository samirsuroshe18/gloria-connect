import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_error.dart';

class CheckInRepository {
  Future<List<String>> getBlocks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    try {
      const apiUrl = 'https://invite.iotsense.in/api/v1/check-in/get-blocks';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse['data'].map<String>((e) => e.toString()).toList();
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

  Future<List<String>> getApartments({required String blockName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final Map<String, dynamic> data = {
      'blockName': blockName,
    };

    try {
      const apiUrl =
          'https://invite.iotsense.in/api/v1/check-in/get-apartments';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse['data'].map<String>((e) => e.toString()).toList();
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

  Future<Map<String, dynamic>> getMobile(
      {required String mobNumber, required String entryType}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final Map<String, dynamic> data = {
      'mobNumber': mobNumber,
      'entryType': entryType,
    };

    try {
      const apiUrl = 'https://invite.iotsense.in/api/v1/check-in/get-mobile';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse['data'];
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
