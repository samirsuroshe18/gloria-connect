import 'dart:convert';

import 'package:gloria_connect/features/invite_visitors/models/pre_approved_banner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_error.dart';

class InviteVisitorsRepository {
  Future<PreApprovedBanner> addPreApproval(
      {required String name,
      required String mobNumber,
      String? profileImg,
      String? companyName,
      String? companyLogo,
      String? serviceName,
      String? serviceLogo,
      String? vehicleNumber,
      required String entryType,
      required String checkInCodeStartDate,
      required String checkInCodeExpiryDate,
      required String checkInCodeStart,
      required String checkInCodeExpiry}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      final Map<String, dynamic> data = {
        'name': name,
        'mobNumber': mobNumber,
        'profileImg': profileImg,
        'companyName': companyName,
        'companyLogo': companyLogo,
        'serviceName': serviceName,
        'serviceLogo': serviceLogo,
        'vehicleNo': vehicleNumber,
        'entryType': entryType,
        'checkInCodeStartDate': checkInCodeStartDate,
        'checkInCodeExpiryDate': checkInCodeExpiryDate,
        'checkInCodeStart': checkInCodeStart,
        'checkInCodeExpiry': checkInCodeExpiry,
      };

      const apiKey =
          'https://invite.iotsense.in/api/v1/invite-visitors/add-pre-approval';
      final response = await http.post(
        Uri.parse(apiKey),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return PreApprovedBanner.fromJson(jsonBody['data'][0]);
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
