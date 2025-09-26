import 'dart:convert';

import 'package:gloria_connect/utils/auth_http_client.dart';

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';
import '../models/entry.dart';

class GuardWaitingRepository {
  Future<List<VisitorEntries>> getEntries() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/get-delivery-waiting-entries';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => VisitorEntries.fromJson(data))
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

  Future<VisitorEntries> getEntry({required String id}) async {
    try {
      final apiUrl ='${ServerConstant.baseUrl}/api/v1/delivery-entry/get-waiting-entry/$id';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return VisitorEntries.fromJson(jsonBody['data']);
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

  Future<Map<String, dynamic>> allowEntryBySecurity({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/allow-delivery-entries';

      final response = await AuthHttpClient.instance.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody;
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

  Future<Map<String, dynamic>> denyEntryBySecurity({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/deny-delivery-entries';

      final response = await AuthHttpClient.instance.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody;
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
