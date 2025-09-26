import 'dart:convert';

import 'package:gloria_connect/constants/server_constant.dart';
import 'package:gloria_connect/utils/auth_http_client.dart';

import '../../../utils/api_error.dart';
import '../../guard_waiting/models/entry.dart';

class GuardExitRepository {
  Future<List<VisitorEntries>> getAllowedEntries() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/get-allowed-entries';

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

  Future<List<VisitorEntries>> getGuestEntries() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/get-allowed-guest-entries';

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

  Future<List<VisitorEntries>> getCabEntries() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/get-allowed-cab-entries';

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

  Future<List<VisitorEntries>> getDeliveryEntries() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/get-allowed-delivery-entries';

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

  Future<List<VisitorEntries>> getServiceEntries() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/get-allowed-other-entries';

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

  Future<Map<String, dynamic>> exitEntry({required String id, required String entryType}) async {
    try {
      final Map<String, dynamic> data = {'id': id};

      String apiUrl = entryType == 'delivery'
          ? '${ServerConstant.baseUrl}/api/v1/delivery-entry/exit-entry'
          : '${ServerConstant.baseUrl}/api/v1/invite-visitors/exit-entry';

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
