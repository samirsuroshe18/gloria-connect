import 'dart:convert';

import 'package:gloria_connect/features/administration/models/guard_requests_model.dart';
import 'package:gloria_connect/features/administration/models/resident_requests_model.dart';
import 'package:gloria_connect/features/administration/models/society_guard.dart';
import 'package:gloria_connect/features/administration/models/society_member.dart';
import 'package:gloria_connect/features/administration/models/technician_model.dart';
import 'package:gloria_connect/features/setting/models/complaint_model.dart';
import 'package:gloria_connect/utils/auth_http_client.dart';

import '../../../constants/server_constant.dart';
import '../../../utils/api_error.dart';

class AdministrationRepository {

  Future<List<ResidentRequestsModel>> getPendingResidentRequest() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/profile-verification/get-pending-resident-req';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => ResidentRequestsModel.fromJson(data))
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

  Future<List<GuardRequestsModel>> getPendingGuardRequest() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/profile-verification/get-pending-guard-req';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => GuardRequestsModel.fromJson(data))
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

  Future<Map<String, dynamic>> verifyResidentRequest({required String requestId, required String user, required String residentStatus}) async {
    try {
      final Map<String, dynamic> data = {
        'requestId': requestId,
        'user': user,
        'residentStatus': residentStatus
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/profile-verification/verify-resident-req';

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

  Future<Map<String, dynamic>> verifyGuardRequest({required String requestId, required String user, required String guardStatus}) async {
    try {
      final Map<String, dynamic> data = {
        'requestId': requestId,
        'user': user,
        'guardStatus': guardStatus
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/profile-verification/verify-guard-req';

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

  Future<SocietyMemberModel> getAllResidents({required Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-resident';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SocietyMemberModel.fromJson(jsonBody['data']);
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

  Future<List<SocietyGuard>> getAllGuards() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-guards';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => SocietyGuard.fromJson(data))
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

  Future<List<SocietyMember>> getAllAdmin() async {
    try {
      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-admins';

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (jsonBody['data'] as List)
            .map((data) => SocietyMember.fromJson(data))
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

  Future<Map<String, dynamic>> createAdmin({required String email}) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/make-admin';

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

  Future<Map<String, dynamic>> removeAdmin({required String email}) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/remove-admin';

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

  Future<Map<String, dynamic>> removeResident({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/remove-resident';

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

  Future<Map<String, dynamic>> removeGuard({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/remove-guard';

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

  Future<ComplaintModel> getComplaints({required Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-complaints';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ComplaintModel.fromJson(jsonBody['data']);
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

  Future<ComplaintModel> getPendingComplaints({required Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-pending-complaints';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ComplaintModel.fromJson(jsonBody['data']);
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

  Future<ComplaintModel> getResolvedComplaints({required Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-resolved-complaints';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ComplaintModel.fromJson(jsonBody['data']);
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

  Future<Map<String, dynamic>> addTechnicians({required String userName, required String email, required String phoneNo, required String role}) async {
    try {
      final Map<String, dynamic> payload = {
        'userName': userName,
        'email': email,
        'phoneNo': phoneNo,
        'role': role
      };

      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/create-technician';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(payload),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {...jsonBody, "data": Technician.fromJson(jsonBody['data'])};
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

  Future<TechnicianModel> getTechnician({required Map<String, dynamic> queryParams}) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/get-technicians';
      if (queryString.isNotEmpty) {
        apiUrl += '?$queryString';
      }

      final response = await AuthHttpClient.instance.get(apiUrl);

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return TechnicianModel.fromJson(jsonBody['data']);
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

  Future<Map<String, dynamic>> removeTechnician({required String id}) async {
    try {
      final Map<String, dynamic> data = {
        'id': id,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/remove-technician';

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

  Future<Complaint> assignTechnician({required String complaintId, required String technicianId}) async {
    try {
      final Map<String, dynamic> data = {
        'complaintId': complaintId,
        'technicianId': technicianId,
      };

      const apiUrl = '${ServerConstant.baseUrl}/api/v1/admin/assign-technician';

      final response = await AuthHttpClient.instance.post(
          apiUrl,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
      );

      final jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Complaint.fromJson(jsonBody['data']);
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
