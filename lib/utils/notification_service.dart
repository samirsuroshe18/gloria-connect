import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/utils/route_observer_with_stack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/server_constant.dart';
import '../main.dart';
import '../constants/notification_constant.dart';

@pragma('vm:entry-point')
class NotificationController {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static NotificationAppLaunchDetails? notificationAppLaunchDetails;
  static bool isInForeground = false;

  @pragma('vm:entry-point')
  static Future<void> initializeLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('ic_notification');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [/* ... */],
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onResponse,
      onDidReceiveBackgroundNotificationResponse: _onResponseBackground,
    );

    await _createChannels();

    notificationAppLaunchDetails = await _plugin.getNotificationAppLaunchDetails();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final int? id = jsonDecode(message.data['payload'])['notificationId'];
      if(message.data['action']=='CANCEL' && id!=null){
        cancelLocalNotification(id);
      }else{
        NotificationController.showLocalNotification(message: message);
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _createChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      await android.createNotificationChannel(const AndroidNotificationChannel(
          NotificationConstant.actionChannelId, NotificationConstant.actionChannelName,
          description: NotificationConstant.actionChannelDesc,
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('res_emergency_sound'),
          enableLights: true,
          enableVibration: true
      ));

      await android.createNotificationChannel(const AndroidNotificationChannel(
          NotificationConstant.basicChannelId, NotificationConstant.basicChannelName,
          description: NotificationConstant.basicChannelDesc,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('res_bell_sound'),
          importance: Importance.max,
          enableLights: true,
          enableVibration: true
      ));
    }
  }

  @pragma('vm:entry-point')
  static Future<void> showLocalNotification({required RemoteMessage message}) async {
    final payload = jsonDecode(message.data['payload']);
    final action = message.data['action'];
    BigPictureStyleInformation? style;

    final id = payload['notificationId'] ?? DateTime.now().millisecondsSinceEpoch.remainder(100000);
    final title = getTitle(action, payload);
    final body = getBody(action, payload);
    final String? imageUrl = payload['profileImg'];
    final withActions = shouldShowActions(action);

    if (imageUrl != null && imageUrl.isNotEmpty && withActions==true) {
      try {
        final resp = await http.get(Uri.parse(imageUrl));
        final bytes = resp.bodyBytes;
        style = BigPictureStyleInformation(
          ByteArrayAndroidBitmap(bytes),
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          contentTitle: title,
          summaryText: body,
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true,
        );
      } catch (_) {}
    }

    final androidDetails = AndroidNotificationDetails(
      withActions ? NotificationConstant.actionChannelId : NotificationConstant.basicChannelId,
      withActions ? NotificationConstant.actionChannelName : NotificationConstant.basicChannelName,
      channelDescription: withActions ? NotificationConstant.actionChannelDesc : NotificationConstant.basicChannelDesc,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      visibility: NotificationVisibility.public,
      importance: Importance.max,
      priority: Priority.max,
      category: AndroidNotificationCategory.alarm,
      styleInformation: style,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      actions: withActions
          ? [
        const AndroidNotificationAction('APPROVE', 'Approve'),
        const AndroidNotificationAction('REJECT', 'Reject'),
      ]
          : null,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        categoryIdentifier: 'actionable',
        attachments:
        imageUrl != null ? [DarwinNotificationAttachment(imageUrl)] : null,
      ),
    );

    await _plugin.show(id, title, body, details, payload: message.data['payload']);
  }

  @pragma('vm:entry-point')
  static Future<void> cancelLocalNotification(int id) => _plugin.cancel(id);

  @pragma('vm:entry-point')
  static Future<void> cancelAllLocalNotification() => _plugin.cancelAll();

  // Internal callbacks
  @pragma('vm:entry-point')
  static void _onResponse(NotificationResponse response) {
    _handleAction(response);
  }

  @pragma('vm:entry-point')
  static void _onResponseBackground(NotificationResponse response) {
    _handleAction(response);
  }

  @pragma('vm:entry-point')
  static void _handleAction(NotificationResponse response) async {
    String? actionId = response.actionId;
    Map<String, dynamic>? payload = response.payload!=null ? jsonDecode(response.payload!) : null;
    if (actionId == null || payload == null) return;

    NavigatorState? currentState = MyApp.navigatorKey.currentState;

    if (payload['action'] == 'VERIFY_RESIDENT_PROFILE_TYPE' && isInForeground == true) {
      currentState?.pushNamed('/resident-approval');
    } else if (payload['action'] == 'VERIFY_GUARD_PROFILE_TYPE' && isInForeground == true) {
      currentState?.pushNamed('/guard-approval');
    } else if (payload['action'] == 'VERIFY_DELIVERY_ENTRY') {
      if (actionId == 'APPROVE') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accessToken = prefs.getString('accessToken');
        const apiKey = '${ServerConstant.baseUrl}/api/v1/delivery-entry/approve-delivery';
        final Map<String, dynamic> data = {
          'id': payload['id'],
        };

        final response = await http.post(
          Uri.parse(apiKey),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          debugPrint('successfully');
        } else {
          debugPrint('error : statusCode: ${response.statusCode}, message: ${jsonDecode(response.body)['message']}');
        }
      } else if (actionId == 'REJECT') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accessToken = prefs.getString('accessToken');
        const apiKey = '${ServerConstant.baseUrl}/api/v1/delivery-entry/reject-delivery';
        final Map<String, dynamic> data = {
          'id': payload['id'],
        };

        final response = await http.post(
          Uri.parse(apiKey),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          debugPrint('successfully');
        } else {
          debugPrint('error : statusCode: ${response.statusCode}, message: ${jsonDecode(response.body)['message']}');
        }
      } else if (isInForeground == true) {
        currentState?.pushNamedAndRemoveUntil('/delivery-approval-screen', (route) => route.isFirst, arguments: payload);
      }
    } else if (payload['action'] == 'NOTIFY_NOTICE_CREATED' && isInForeground == true) {
      if(getCurrentRouteName() == '/create-notice-board-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/notice-board-details-screen', arguments: NoticeBoardModel.fromJson(payload));
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/notice-board-details-screen', arguments: NoticeBoardModel.fromJson(payload));
        });
      }
    } else if (payload['action'] == 'NOTIFY_COMPLAINT_CREATED' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'NOTIFY_RESIDENT_REPLIED' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'NOTIFY_ADMIN_REPLIED' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'REVIEW_RESOLUTION' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'ASSIGN_COMPLAINT' && isInForeground == true) {
      if(getCurrentRouteName() == '/tech-complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'RESOLUTION_APPROVED' && isInForeground == true) {
      if(getCurrentRouteName() == '/tech-complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    } else if (payload['action'] == 'RESOLUTION_REJECTED' && isInForeground == true) {
      if(getCurrentRouteName() == '/tech-complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/tech-complaint-details-screen', arguments: {'id': payload['id']});
        });
      }
    }
  }

  @pragma('vm:entry-point')
  static bool shouldShowActions(String action) {
    // Define which notification types should have actions
    switch (action) {
      case "VERIFY_DELIVERY_ENTRY":
        return true;
      default:
        return false;
    }
  }

  @pragma('vm:entry-point')
  static String getTitle(String action, Map<String, dynamic> payload) {
    switch (action) {
      case "VERIFY_RESIDENT_PROFILE_TYPE":
        return "Verify resident profile";

      case "VERIFY_GUARD_PROFILE_TYPE":
        return "Verify security guard profile";

      case "VERIFY_DELIVERY_ENTRY":
        Map<String, String> message =  getVerifyNotification(payload['entryType'], payload['societyDetails']['societyGates']);
        return message['title'] ?? 'Not available';

      case "DELIVERY_ENTRY_APPROVE":
        return "Entry Approved";

      case "DELIVERY_ENTRY_REJECTED":
        return "Entry Rejected";

      case "NOTIFY_GUARD_APPROVE":
        return "Entry Confirmed";

      case "NOTIFY_GUARD_REJECTED":
        return "Entry Confirmed";

      case "NOTIFY_CHECKED_IN":
        return "New Visitor Checked In";

      case "NOTIFY_EXIT_ENTRY":
        return "Entry Exited";

      case "NOTIFY_CHECKED_IN_ENTRY":
        String entryType = payload['entryType'] ?? 'NA';
        return 'Entry Confirmed: $entryType';

      case "RESIDENT_APPROVE":
      case "RESIDENT_REJECT":
      case "GUARD_APPROVE":
      case "GUARD_REJECT":
        String title = _getTitle(action);
        return title;

      case "NOTIFY_NOTICE_CREATED":
        String societyName = payload['society'] ?? 'Unknown Society';
        String noticeCategory = payload['category'] ?? 'General';

        // Format the title based on category
        String categoryLabel;
        switch (noticeCategory.toLowerCase()) {
          case "important":
            categoryLabel = "📢 Important Notice";
            break;
          case "event":
            categoryLabel = "🎉 Upcoming Event";
            break;
          case "maintenance":
            categoryLabel = "🛠️ Maintenance Update";
            break;
          default:
            categoryLabel = "📌 Notice Board";
        }
        return "$categoryLabel in $societyName";

      case "NOTIFY_COMPLAINT_CREATED":
        String complaintType = payload['category'] ?? 'Unknown';
        String societyName = payload['societyName'] ?? 'Unknown';
        return "New Complaint: $complaintType in $societyName";

      case "NOTIFY_RESIDENT_REPLIED":
        return "📩 New Reply on Complaint";

      case "NOTIFY_ADMIN_REPLIED":
        return "🛠️ Admin Responded to Your Complaint";

      case "NOTIFY_COMPLAINT_REOPENED":
        String complaintType = payload['category'] ?? 'Unknown';
        bool isReopenedByResident = payload['isReopenedByResident'];
        String title = isReopenedByResident ? "Complaint Reopened by Resident: $complaintType" : "Complaint Reopened: $complaintType";
        return title;

      case "NOTIFY_COMPLAINT_RESOLVED":
        String complaintType = payload['category'] ?? 'Unknown';
        bool isResolvedByResident = payload['isResolvedByResident'];
        String title = isResolvedByResident ? "Complaint Resolved by Resident: $complaintType" : "Complaint Resolved: $complaintType";
        return title;

      case "GUARD_DUTY_CHECKIN":
        return 'Guard duty started';

      case "GUARD_DUTY_CHECKOUT":
        return 'Guard duty ended';

      case "NOTIFY_GATE_PASS_RESIDENT":
        return payload['title'];

      case "NOTIFY_GATE_PASS_APPROVED":
        return payload['title'];

      case "NOTIFY_GUARD_PASS_EXPIRED":
        return payload['title'];

      case "NOTIFY_RESIDENT_PASS_EXPIRED":
        return payload['title'];

      case "NOTIFY_GATE_PASS_ACTIVATED":
        return payload['title'];

      case "ADD_APARTMENT_TO_GATE_PASS":
        return payload['title'];

      case "REMOVE_APARTMENT_FROM_GATE_PASS":
        return payload['title'];

      case "ASSIGN_COMPLAINT":
        return payload['title'];

      case "REVIEW_RESOLUTION":
        return payload['title'];

      case "RESOLUTION_APPROVED":
        return payload['title'];

      case "RESOLUTION_REJECTED":
        return payload['title'];

      default:
        return payload['title'] ?? "Notification";
    }
  }

  @pragma('vm:entry-point')
  static String getBody(String action, Map<String, dynamic> payload) {
    switch (action) {
      case "VERIFY_RESIDENT_PROFILE_TYPE":
        String societyBlock = payload['societyBlock'] ?? 'NA';
        String societyName = payload['societyName'] ?? 'NA';
        String apartment = payload['societyName'] ?? 'NA';
        String ownership = payload['societyName'] ?? 'NA';
        String userName = payload['userName'] ?? 'Anonymous';
        return 'New resident profile submitted for verification. \n\nName: $userName \nSociety: $societyName \nBlock: $societyBlock \nApartment: $apartment \nOwnership: $ownership \n\n Please review and approve or reject the profile.';

      case "VERIFY_GUARD_PROFILE_TYPE":
        String userName = payload['userName'] ?? 'NA';
        String societyName = payload['societyName'] ?? 'NA';
        String gateAssign = payload['gateAssign'] ?? 'NA';
        return 'New security guard profile submitted for verification. \n\nName: $userName \nSociety: $societyName \nGate assigned: $gateAssign \n\n Please review and approve or reject the profile.';

      case "VERIFY_DELIVERY_ENTRY":
        Map<String, String> message =  getVerifyNotification(payload['entryType'], payload['societyDetails']['societyGates']);
        String name = payload['name'] ?? 'NA';
        return '${message['body']}\n$name';

      case "DELIVERY_ENTRY_APPROVE":
        String? companyName = payload['companyName'] ?? 'NA';
        String? serviceName = payload['serviceName'] ?? 'NA';
        String visitorName = payload['visitorName'] ?? 'NA';
        String userName = payload['userName'] ?? 'NA';
        String entryType = payload['entryType'] ?? 'NA';
        String bodyMessage = deliveryEntryApprovedNotificationMessage(entryType, userName, visitorName, serviceName, companyName);
        return bodyMessage;

      case "DELIVERY_ENTRY_REJECTED":
        String? companyName = payload['companyName'] ?? 'NA';
        String? serviceName = payload['serviceName'] ?? 'NA';
        String visitorName = payload['visitorName'] ?? 'NA';
        String userName = payload['userName'] ?? 'NA';
        String entryType = payload['entryType'] ?? 'NA';
        String bodyMessage = deliveryEntryDeniedNotificationMessage(entryType, userName, visitorName, serviceName, companyName);
        return bodyMessage;

      case "NOTIFY_GUARD_APPROVE":
        String deliveryName = payload['deliveryName'] ?? 'NA';
        String userName = payload['userName'] ?? 'NA';
        return '$userName (Resident) has approved $deliveryName. Please proceed.';

      case "NOTIFY_GUARD_REJECTED":
        String deliveryName = payload['deliveryName'] ?? 'NA';
        String userName = payload['userName'] ?? 'NA';
        return '$userName (Resident) has rejected $deliveryName. Please proceed.';

      case "NOTIFY_CHECKED_IN":
        String name = payload['name'] ?? 'NA';
        return '$name has checked in';

      case "NOTIFY_EXIT_ENTRY":
        String deliveryName = payload['deliveryName'] ?? 'NA';
        return '$deliveryName has been checked out.';

      case "NOTIFY_CHECKED_IN_ENTRY":
        String entryType = payload['entryType'] ?? 'NA';
        String deliveryName = payload['deliveryName'] ?? 'NA';
        String guardName = payload['guardName'] ?? 'NA';
        return 'The $entryType ($deliveryName) you pre-approved has been securely checked in by the guard ($guardName).';

      case "RESIDENT_APPROVE":
      case "RESIDENT_REJECT":
      case "GUARD_APPROVE":
      case "GUARD_REJECT":
        String message = _getBody(action);
        return message;

      case "NOTIFY_NOTICE_CREATED":
        String noticeTitle = payload['title'] ?? 'New Notice';
        String publishedBy = payload['publishedBy']['userName'] ?? 'Admin';
        return "$noticeTitle\nPublished by: $publishedBy";

      case "NOTIFY_COMPLAINT_CREATED":
        String userName = payload['raisedBy']['userName'] ?? 'Anonymous';
        return '$userName has registered a complaint.';

      case "NOTIFY_RESIDENT_REPLIED":
        String complaintType = payload['category'] ?? 'Unknown';
        String societyName = payload['societyName'] ?? 'Unknown';
        String userName = payload['raisedBy']['userName'] ?? 'Anonymous';
        return "$userName has responded to the complaint regarding $complaintType in $societyName. Check now for details.";

      case "NOTIFY_ADMIN_REPLIED":
        String complaintType = payload['category'] ?? 'Unknown';
        String societyName = payload['societyName'] ?? 'Unknown';
        return "Your complaint regarding $complaintType in $societyName has received a response from the admin. Check now for updates.";

      case "NOTIFY_COMPLAINT_REOPENED":
        String complaintType = payload['category'] ?? 'Unknown';
        String societyName = payload['societyName'] ?? 'Unknown';
        String reopenedBy = payload['reopenedBy'] ?? 'Unknown';
        bool isReopenedByResident = payload['isReopenedByResident'];
        String body = isReopenedByResident ? "$reopenedBy has reopened the complaint regarding $complaintType in $societyName." : "Your complaint regarding $complaintType has been reopened by $reopenedBy.";
        return body;

      case "NOTIFY_COMPLAINT_RESOLVED":
        String complaintType = payload['category'] ?? 'Unknown';
        String resolvedBy = payload['resolvedBy'] ?? 'Unknown';
        bool isResolvedByResident = payload['isResolvedByResident'];
        String body = isResolvedByResident ? "$resolvedBy has marked the complaint regarding $complaintType as resolved." : "Your complaint regarding $complaintType has been resolved by $resolvedBy.";
        return body;

      case "GUARD_DUTY_CHECKIN":
        String guardName = payload['guardName'] ?? 'Unknown';
        String guardGate = payload['guardGate'];
        return '$guardName has started duty at $guardGate.';

      case "GUARD_DUTY_CHECKOUT":
        String guardName = payload['guardName'] ?? 'Unknown';
        String guardGate = payload['guardGate'];
        return '$guardName has ended duty at $guardGate.';

      case "NOTIFY_GATE_PASS_RESIDENT":
        return payload['message'];

      case "NOTIFY_GATE_PASS_APPROVED":
        return payload['message'];

      case "NOTIFY_GUARD_PASS_EXPIRED":
        return payload['message'];

      case "NOTIFY_RESIDENT_PASS_EXPIRED":
        return payload['message'];

      case "NOTIFY_GATE_PASS_ACTIVATED":
        return payload['message'];

      case "ADD_APARTMENT_TO_GATE_PASS":
        return payload['message'];

      case "REMOVE_APARTMENT_FROM_GATE_PASS":
        return payload['message'];

      case "ASSIGN_COMPLAINT":
        return payload['message'];

      case "REVIEW_RESOLUTION":
        return payload['message'];

      case "RESOLUTION_APPROVED":
        return payload['message'];

      case "RESOLUTION_REJECTED":
        return payload['message'];

      default:
        return payload['body'] ?? "You have a new notification";
    }
  }

  @pragma('vm:entry-point')
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('user granted provisional permission');
    } else {
      debugPrint('user denied permission');
    }
  }

  @pragma('vm:entry-point')
  Future<String?> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @pragma('vm:entry-point')
  Future<void> getDeviceTokenAndSaveToDb(BuildContext context) async {
    final token = await FirebaseMessaging.instance.getToken();
    // ignore: use_build_context_synchronously
    context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: token!));
  }

  @pragma('vm:entry-point')
  Future<void> updateDeviceToken(BuildContext context,) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // ignore: use_build_context_synchronously
      context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
    });
  }

  // Helper method to generate a message based on entryType
  @pragma('vm:entry-point')
  static Map<String, String> getVerifyNotification(String entryType, String gate) {
    if (entryType == 'delivery') {
      return {'title': 'Verify delivery', 'body': 'You have got a Delivery at the $gate.'};
    } else if(entryType == 'guest'){
      return {'title': 'Verify Guest', 'body': 'You have got a Guest at the $gate.'};
    } else if(entryType == 'other'){
      return {'title': 'Verify Other Services', 'body': 'You have got a Other service at the $gate.'};
    } else{
      return {'title': 'Verify Cab', 'body': 'You have got a Cab at the $gate.'};
    }
  }

  // Helper method to generate a message based on entryType
  @pragma('vm:entry-point')
  static String deliveryEntryApprovedNotificationMessage(String entryType, String userName, String visitorName, String? serviceName, String? companyName, ) {
    if (entryType == 'delivery') {
      return 'The delivery entry for $companyName ($visitorName) has been approved by $userName.';
    } else if(entryType == 'guest'){
      return 'The guest entry ($visitorName) has been approved by $userName.';
    } else if(entryType == 'other'){
      return 'The other services entry for $serviceName ($visitorName) has been approved by $userName.';
    } else{
      return 'The cab entry for $companyName ($visitorName) has been approved by $userName.';
    }
  }

  @pragma('vm:entry-point')
  static String deliveryEntryDeniedNotificationMessage(String entryType, String userName, String visitorName, String? serviceName, String? companyName) {
    if (entryType == 'delivery') {
      return 'The delivery entry for $companyName ($visitorName) has been rejected by $userName.';
    } else if(entryType == 'guest'){
      return 'The guest entry ($visitorName) has been rejected by $userName.';
    } else if(entryType == 'other'){
      return 'The other services entry for $serviceName ($visitorName) has been rejected by $userName.';
    } else{
      return 'The cab entry for $companyName ($visitorName) has been rejected by $userName.';
    }
  }

  // Helper method to generate a message based on action
  @pragma('vm:entry-point')
  static String _getBody(String action) {
    if (action == 'RESIDENT_APPROVE') {
      return "Congratulations! Your resident profile has been successfully approved.";
    } else if(action == 'RESIDENT_REJECT'){
      return "Unfortunately, your resident profile was not approved. For more information, please reach out to us.";
    } else if(action == 'GUARD_APPROVE'){
      return "Congratulations! Your guard profile has been successfully approved.";
    } else{
      return "Unfortunately, your guard profile was not approved. For more information, please reach out to us.";
    }
  }

// Helper method to generate a message based on action
  @pragma('vm:entry-point')
  static String _getTitle(String action) {
    if (action == 'RESIDENT_APPROVE') {
      return "Resident Profile Approved";
    } else if(action == 'RESIDENT_REJECT'){
      return "Resident Profile Rejected";
    } else if(action == 'GUARD_APPROVE'){
      return "Security Guard Profile Approved";
    } else{
      return "Security Guard Profile Rejected";
    }
  }
}