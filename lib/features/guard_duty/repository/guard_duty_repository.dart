import 'dart:convert';

import 'package:gloria_connect/features/guard_duty/model/guard_info_model.dart';
import 'package:gloria_connect/features/guard_duty/model/guard_log_model.dart';
import 'package:gloria_connect/utils/api_error.dart';
import 'package:gloria_connect/utils/auth_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/server_constant.dart';

class GuardDutyRepository{

  Future<Map<String, dynamic>> guardDutyCheckin({required String gate, required String checkinReason, required String shift}) async {
    try {
      final Map<String, dynamic> data = {
        'gate': gate,
        'shift': shift,
        'checkinReason': checkinReason,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/guard-duty/check-in';

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

  Future<Map<String, dynamic>> guardDutyCheckout({required String checkoutReason}) async {
    try {
      final Map<String, dynamic> data = {
        'checkoutReason': checkoutReason,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/guard-duty/check-out';

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

  Future<GuardInfoModel> getGuardInfo({required String id}) async {
    try {
      final apiUrl = '${ServerConstant.baseUrl}/api/v1/guard-duty/get-report/$id';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GuardInfoModel.fromJson(jsonBody['data']);
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

  Future<GuardLogModel> getGuardLogs({ required final Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/guard-duty/get-logs';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GuardLogModel.fromJson(jsonBody['data']);
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