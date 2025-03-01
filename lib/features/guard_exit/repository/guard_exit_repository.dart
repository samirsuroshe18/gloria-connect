import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_error.dart';
import '../../guard_waiting/models/entry.dart';

class GuardExitRepository {
  Future<List<Entry>> getAllowedEntries() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/delivery-entry/get-allowed-entries';
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
            .map((data) => Entry.fromJson(data))
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

  Future<List<Entry>> getGuestEntries() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/delivery-entry/get-allowed-guest-entries';
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
            .map((data) => Entry.fromJson(data))
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

  Future<List<Entry>> getCabEntries() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/delivery-entry/get-allowed-cab-entries';
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
            .map((data) => Entry.fromJson(data))
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

  Future<List<Entry>> getDeliveryEntries() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/delivery-entry/get-allowed-delivery-entries';
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
            .map((data) => Entry.fromJson(data))
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

  Future<List<Entry>> getServiceEntries() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/delivery-entry/get-allowed-other-entries';
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
            .map((data) => Entry.fromJson(data))
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

  Future<Map<String, dynamic>> exitEntry(
      {required String id, required String entryType}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> data = {'id': id};

      String apiUrl = entryType == 'delivery'
          ? 'https://invite.iotsense.in/api/v1/delivery-entry/exit-entry'
          : 'https://invite.iotsense.in/api/v1/invite-visitors/exit-entry';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
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
