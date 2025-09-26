import 'dart:convert';
import 'dart:io';

import 'package:gloria_connect/utils/auth_http_client.dart';
import 'package:http/http.dart' as http;

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class GuardEntryRepository {

  Future<Map<String, dynamic>> addDeliveryEntry({
    required String name,
    required String mobNumber,
    required dynamic profileImg,
    String? companyName,
    String? companyLogo,
    String? serviceName,
    String? serviceLogo,
    String? accompanyingGuest,
    String? vehicleType,
    String? vehicleNumber,
    required String entryType,
    required String societyName,
    required List<Map<String, String>> societyApartments,
    required String societyGates,
  }) async {
    final Map<String, dynamic> data = {
      'name': name,
      'mobNumber': mobNumber,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'serviceName': serviceName,
      'serviceLogo': serviceLogo,
      'entryType': entryType,
      'accompanyingGuest': accompanyingGuest,
      'vehicleDetails': {
        'vehicleType': vehicleType,
        'vehicleNumber': vehicleNumber
      },
      'societyDetails': {
        'societyName': societyName,
        'societyApartments': societyApartments,
        'societyGates': societyGates
      }
    };

    try {
      // Determine which API URL to use based on whether it's a multipart request
      const apiUrlString = '${ServerConstant.baseUrl}/api/v1/delivery-entry/add-delivery-entry-2';
      const apiUrlFile = '${ServerConstant.baseUrl}/api/v1/delivery-entry/add-delivery-entry';

      http.Response response;

      if (profileImg is String) {
        data['profileImg'] = profileImg;

        response = await AuthHttpClient.instance.post(
          apiUrlString,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        );
      } else if (profileImg is File) {
        final Map<String, String> fields = {};
        List<http.MultipartFile> files = [];

        fields['name'] = name;
        fields['mobNumber'] = mobNumber;
        if(companyName!=null) fields['companyName'] = companyName;
        if(companyLogo!=null) fields['companyLogo'] = companyLogo;
        if(serviceName!=null) fields['serviceName'] = serviceName;
        if(serviceLogo!=null) fields['serviceLogo'] = serviceLogo;
        if(accompanyingGuest != null ) fields['accompanyingGuest'] = accompanyingGuest;
        fields['societyName'] = societyName;
        fields['entryType'] = entryType;
        fields['vehicleDetails'] = jsonEncode({
          'vehicleType': vehicleType,
          'vehicleNumber': vehicleNumber,
        });
        fields['societyDetails'] = jsonEncode({
          'societyName': societyName,
          'societyApartments': societyApartments,
          'societyGates': societyGates,
        });
        files.add(await http.MultipartFile.fromPath('profileImg', profileImg.path));

        response = await AuthHttpClient.instance.multipartRequest(
          'POST',
          apiUrlFile,
          fields: fields,
          files: files,
        );
      } else {
        throw ApiError(message: 'Invalid profileImg type.');
      }

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return jsonResponse;
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

  Future<Map<String, dynamic>> approveDeliveryEntry({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/delivery-entry/approve-delivery';

      final response = await AuthHttpClient.instance.post(
        apiKey,
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

  Future<Map<String, dynamic>> rejectDeliveryEntry({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };
      const apiKey = '${ServerConstant.baseUrl}/api/v1/delivery-entry/reject-delivery';

      final response = await AuthHttpClient.instance.post(
        apiKey,
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

  Future<Map<String, dynamic>> checkInByCode({required String checkInCode}) async {
    try {
      final Map<String, dynamic> data = {
        'checkInCode': checkInCode,
      };
      const apiKey = '${ServerConstant.baseUrl}/api/v1/check-in-by-code/add-entry';

      final response = await AuthHttpClient.instance.post(
        apiKey,
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
