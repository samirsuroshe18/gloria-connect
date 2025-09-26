// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gloria_connect/features/auth/models/get_user_model.dart';
import 'package:gloria_connect/features/auth/models/society_model.dart';
import 'package:gloria_connect/utils/auth_http_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class AuthRepository {
  Future<Map<String, dynamic>> signUpUser({required String userName, required String email, required String password, required String confirmPassword}) async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/users/register';
      final Map<String, dynamic> data = {
        'userName': userName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      };

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: false
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
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

  Future<GetUserModel> signInUser({required String email, required String password}) async {
    try {
      String? FCMToken = await FirebaseMessaging.instance.getToken();

      final Map<String, dynamic> data = {
        'email': email,
        'password': password,
        'FCMToken': FCMToken
      };
      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/login';
      final response = await AuthHttpClient.instance.post(
          apiKey,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: false
      );

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 401) {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
      }

      if (response.statusCode == 200) {
        final accessToken = jsonBody['data']['accessToken'].toString();
        final refreshToken = jsonBody['data']['refreshToken'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", accessToken);
        await prefs.setString("refreshToken", refreshToken);

        return GetUserModel.fromJson(jsonBody['data']['loggedInUser']);
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

  Future<GetUserModel> googleSigning() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      String? FCMToken = await FirebaseMessaging.instance.getToken();

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw ApiError(message: 'Sign-in was canceled by the user.');
      }

      final Map<String, dynamic> data = {
        'userName': googleSignInAccount.displayName,
        'email': googleSignInAccount.email,
        'profile': googleSignInAccount.photoUrl,
        'FCMToken': FCMToken
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/google-signin';
      final response = await AuthHttpClient.instance.post(
          apiKey,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: false
      );

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 409) {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
      }

      if (response.statusCode == 200) {
        final accessToken = jsonBody['data']['accessToken'].toString();
        final refreshToken = jsonBody['data']['refreshToken'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("accessToken", accessToken);
        await prefs.setString("refreshToken", refreshToken);

        return GetUserModel.fromJson(jsonBody['data']['loggedInUser']);
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

  Future<Map<String, dynamic>> googleLinked() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw ApiError(message: 'Sign-in was canceled by the user.');
      }

      final Map<String, dynamic> data = {
        'userName': googleSignInAccount.displayName,
        'email': googleSignInAccount.email,
        'profile': googleSignInAccount.photoUrl
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/link-google';
      final response = await AuthHttpClient.instance.post(
          apiKey,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: false
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

  Future<Map<String, dynamic>> logoutUser() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString('refreshToken');

      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/logout';

      final response = await AuthHttpClient.instance.get(
          apiKey,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $refreshToken',
          },
          requiresAuth: false
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await googleSignIn.signOut();
        await prefs.remove("accessToken");
        await prefs.remove("refreshMode");
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

  Future<GetUserModel> getUser() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/users/get-current-user';
      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GetUserModel.fromJson(jsonBody['data']);
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

  Future<GetUserModel> addCompleteProfile({required String phoneNo, required String profileType, required String societyName, String? blockName, String? apartment, String? ownershipStatus, String? gateName, String? startDate, String? endDate, File? tenantAgreement, File? ownershipDocument}) async {
    try {
      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/extra-info';
      final Map<String, String> fields = {};
      List<http.MultipartFile> files = [];

      if (profileType == 'Resident' && ownershipStatus == 'Owner') {
        fields['phoneNo'] = phoneNo;
        fields['profileType'] = profileType;
        fields['societyName'] = societyName;
        fields['societyBlock'] = blockName!;
        fields['apartment'] = apartment!;
        fields['ownership'] = ownershipStatus!;
        if (ownershipDocument != null) {
          files.add(await http.MultipartFile.fromPath('file', ownershipDocument.path));
        }
      } else if (profileType == 'Resident' && ownershipStatus == 'Tenant') {
        fields['phoneNo'] = phoneNo;
        fields['profileType'] = profileType;
        fields['societyName'] = societyName;
        fields['societyBlock'] = blockName!;
        fields['apartment'] = apartment!;
        fields['ownership'] = ownershipStatus!;
        fields['startDate'] = startDate!; // Assuming startDate is a DateTime object
        fields['endDate'] = endDate!;     // Assuming endDate is a DateTime object
        if (tenantAgreement != null) {
          files.add(await http.MultipartFile.fromPath('file', tenantAgreement.path));
        }
      } else {
        fields['phoneNo'] = phoneNo;
        fields['profileType'] = profileType;
        fields['societyName'] = societyName;
        fields['gateAssign'] = gateName!;
      }

      final response = await AuthHttpClient.instance.multipartRequest(
        'POST',
        apiKey,
        fields: fields,
        files: files,
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return GetUserModel.fromJson(jsonBody['data']);
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

  Future<Map<String, dynamic>> addApartment({required String societyName, required String societyBlock, required String apartment, required String role}) async {
    try {
      final Map<String, dynamic> data = {
        'societyName': societyName,
        'societyBlock': societyBlock,
        'apartment': apartment,
        'role': role,
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/add-apartment';

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
        throw ApiError(statusCode: response.statusCode, message: jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

  Future<Map<String, dynamic>> addGate({required String societyName, required String gateAssign}) async {
    try {
      final Map<String, dynamic> data = {
        'societyName': societyName,
        'gateAssign': gateAssign,
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/add-gate';

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

  Future<Map<String, dynamic>> updateFCM({required String FCMToken}) async {
    try {
      final Map<String, dynamic> data = {
        'FCMToken': FCMToken,
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/update-fcm';

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

  Future<List<Society>> getSocietyDetails() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/society/get-all-societies';

      final response = await AuthHttpClient.instance.get(apiUrl, requiresAuth: false);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => Society.fromJson(data))
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

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
      };

      const apiKey = '${ServerConstant.baseUrl}/api/v1/users/forgot-password';

      final response = await AuthHttpClient.instance.post(
          apiKey,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
          requiresAuth: false
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

  Future<Map<String, dynamic>> getContactEmail() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/users/get-contact-email';

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
}
