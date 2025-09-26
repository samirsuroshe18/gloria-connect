import 'dart:convert';
import 'dart:io';

import 'package:gloria_connect/features/guard_profile/models/gate_pass_banner.dart';
import 'package:gloria_connect/features/guard_profile/models/checkout_history.dart';
import 'package:gloria_connect/utils/auth_http_client.dart';
import 'package:http/http.dart' as http;

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class GuardProfileRepository{

  Future<Map<String, dynamic>> updateDetails({String? userName, File? profile,}) async {
    try {
      const apiUrlFile = '${ServerConstant.baseUrl}/api/v1/users/update-details';
      final Map<String, String> fields = {};
      List<http.MultipartFile> files = [];

      if (userName != null && userName.isNotEmpty) fields['userName'] = userName;
      if (profile != null) {
        files.add(await http.MultipartFile.fromPath('profile', profile.path));
      }

      final response = await AuthHttpClient.instance.multipartRequest(
        'POST',
        apiUrlFile,
        fields: fields,
        files: files,
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
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

  Future<CheckoutHistoryModel> getCheckoutHistory({ required Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/delivery-entry/get-checkout-history';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return CheckoutHistoryModel.fromJson(jsonBody['data']);
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

  Future<GatePassBannerGuard> addGatePass({String? name, File? profile, String? mobNumber, String? gender, String? serviceName, String? serviceLogo, String? address, File? addressProof, List<Map<String, String>>? gatepassAptDetails, String? checkInCodeStartDate, String? checkInCodeExpiryDate, String? checkInCodeStart, String? checkInCodeExpiry,}) async {
    try {
      const apiUrlFile = '${ServerConstant.baseUrl}/api/v1/invite-visitors/add-gate-pass';
      final Map<String, String> fields = {};
      List<http.MultipartFile> files = [];

      fields['name'] = name!;
      fields['mobNumber'] = mobNumber!;
      fields['gender'] = gender!;
      fields['serviceName'] = serviceName!;
      fields['serviceLogo'] = serviceLogo!;
      fields['address'] = address!;
      fields['entryType'] = 'service';
      fields['aptDetails'] = jsonEncode(gatepassAptDetails);
      fields['checkInCodeStartDate'] = checkInCodeStartDate!;
      fields['checkInCodeExpiryDate'] = checkInCodeExpiryDate!;
      fields['checkInCodeStart'] = checkInCodeStart!;
      fields['checkInCodeExpiry'] = checkInCodeExpiry!;
      if(profile != null )files.add(await http.MultipartFile.fromPath('files', profile.path));
      if(addressProof!=null)files.add(await http.MultipartFile.fromPath('files', addressProof.path));

      final response = await AuthHttpClient.instance.multipartRequest(
        'POST',
        apiUrlFile,
        fields: fields,
        files: files,
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GatePassBannerGuard.fromJson(jsonResponse['data']);
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

  Future<GatePassModel> getGatePass({ required Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/get-gate-pass';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GatePassModel.fromJson(jsonBody['data']);
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

  Future<GatePassBannerGuard> getGatePassDetails({ required String id}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/get-gate-pass-details/$id';

      final response = await AuthHttpClient.instance.get(apiUrl);

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

  Future<Map<String, dynamic>> removeGatePass({ required String id}) async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/remove-gatepass-security/$id';

      final response = await AuthHttpClient.instance.get(apiUrl);

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

  Future<List<GatePassBannerGuard>> getPendingGatePass() async {
    try {
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/get-verification-passes-security';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => GatePassBannerGuard.fromJson(data))
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

  Future<GatePassModel> getExpiredGatePassSecurity({ required Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/invite-visitors/get-expired-passes-security';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GatePassModel.fromJson(jsonBody['data']);
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