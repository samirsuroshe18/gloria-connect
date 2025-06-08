import 'dart:convert';

import 'package:gloria_connect/features/gate_pass/models/gate_pass_model.dart';
import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class GatePassRepository {

  Future<GatePassModelResident> getGatePassApproveRes({required Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/get-approved-passes';
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
        return GatePassModelResident.fromJson(jsonBody['data']);
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

  Future<GatePassModelResident> getGatePassExpiredRes({required Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/get-expired-passes';
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
        return GatePassModelResident.fromJson(jsonBody['data']);
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

  Future<GatePassModelResident> getGatePassRejectedRes({required Map<String, dynamic> queryParams}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      // Build query string using the same 'queryParams' name
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/get-rejected-passes';
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
        return GatePassModelResident.fromJson(jsonBody['data']);
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

  Future<List<GatePassBanner>> getPendingGatePass() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/get-verify-passes';

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
            .map((data) => GatePassBanner.fromJson(data))
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

  Future<Map<String, dynamic>> approveGatePass({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/approve-gate-pass/$id';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody['data'];
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

  Future<Map<String, dynamic>> rejectGatePass({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/reject-gate-pass/$id';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody['data'];
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

  Future<Map<String, dynamic>> removeApartmentResident({required String id}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/remove-apartment/$id';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonBody['data'];
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

  Future<GatePassBannerGuard> removeApartmentSecurity({required String id, required String aptId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/remove-apartment-security/$id/$aptId';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GatePassBannerGuard.fromJson(jsonBody['data']);
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

  Future<GatePassBannerGuard> addApartmentSecurity({required String id, required String email}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/add-apartment';

      final Map<String, dynamic> payload = {
        'id': id,
        'email': email
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );
      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GatePassBannerGuard.fromJson(jsonBody['data']);
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
