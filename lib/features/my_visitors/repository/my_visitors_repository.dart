import 'dart:convert';

import 'package:gloria_connect/features/guard_waiting/models/entry.dart';
import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:gloria_connect/features/my_visitors/models/past_delivery_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_error.dart';

class MyVisitorsRepository {
  Future<List<VisitorEntries>> getCurrentEntries() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/delivery-entry/get-current';
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

  Future<PastDeliveryModel> getPastEntries({ required final Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrl = Uri.https('invite.iotsense.in', '/api/v1/delivery-entry/get-past', queryParams);
      final response = await http.get(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return PastDeliveryModel.fromJson(jsonBody['data']);
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

  Future<PastDeliveryModel> getDeniedEntries({ required final Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final apiUrl = Uri.https('invite.iotsense.in', '/api/v1/delivery-entry/get-denied', queryParams);
      final response = await http.get(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return PastDeliveryModel.fromJson(jsonBody['data']);
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

  Future<List<PreApprovedBanner>> getExpectedEntries() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/invite-visitors/get-expected';
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
            .map((data) => PreApprovedBanner.fromJson(data))
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

  Future<VisitorEntries> getServiceRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/delivery-entry/get-service-entries';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
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
}
