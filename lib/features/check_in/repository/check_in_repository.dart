import 'dart:convert';

import 'package:gloria_connect/utils/auth_http_client.dart';

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class CheckInRepository {
  Future<List<String>> getBlocks() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/check-in/get-blocks';

      final response = await AuthHttpClient.instance.get(apiUrl);

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
    final Map<String, dynamic> data = {
      'blockName': blockName,
    };

    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/check-in/get-apartments';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
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

  Future<Map<String, dynamic>> getMobile({required String mobNumber, required String entryType}) async {
    final Map<String, dynamic> data = {
      'mobNumber': mobNumber,
      'entryType': entryType,
    };

    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/check-in/get-mobile';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
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
