import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloria_connect/features/auth/bloc/auth_bloc.dart';
import 'package:gloria_connect/features/notice_board/models/notice_board_model.dart';
import 'package:gloria_connect/firebase_options.dart';
import 'package:gloria_connect/utils/route_observer_with_stack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

part 'notifications.dart';

class NotificationController {
  static ReceivedAction? initialAction;
  static bool isInForeground = false;

  static Future<void> initializeLocalNotifications() async {
    AwesomeNotifications().initialize(
      'resource://drawable/small_icon_gloria',
      [
        NotificationChannel(
          channelKey: 'app_notifications',
          channelName: 'App Notifications',
          channelDescription: 'Notifications related to app activities and updates.',
          soundSource: 'resource://raw/res_emergency_sound',
          enableVibration: true,
          importance: NotificationImportance.High,
        )
      ],
    );

    AwesomeNotifications().initialize(
      'resource://drawable/small_icon_gloria',
      [
        NotificationChannel(
          channelKey: 'alert_notification',
          channelName: 'Alert Notifications',
          channelDescription: 'Notifications related to app activities and updates.',
          soundSource: 'resource://raw/res_bell_sound',
          enableVibration: true,
          importance: NotificationImportance.High,
        )
      ],
    );

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications().getInitialNotificationAction(removeFromActionEvents: true);

    Future<void> markNotificationAsProcessed(String notificationId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String> processedNotifications = prefs.getStringList('processed_notifications')?.toSet() ?? <String>{};
      processedNotifications.add(notificationId);
      await prefs.setStringList('processed_notifications', processedNotifications.toList());
    }

    Future<bool> isNotificationProcessed(String notificationId) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Set<String> processedNotifications = prefs.getStringList('processed_notifications')?.toSet() ?? <String>{};
      return processedNotifications.contains(notificationId);
    }

    FirebaseMessaging.onMessage.listen((message) async {
      String? notificationId = message.messageId;

      // Check if this notification was already processed
      bool isProcessed = await isNotificationProcessed(notificationId!);

      if (!isProcessed) {
        // Handle the notification (show it or perform actions)
        NotificationController().handleNotification(message, "onMessage");

        // Mark it as processed so it won't be handled again
        await markNotificationAsProcessed(notificationId);
      }
    });

    ///It is used to handle incoming Firebase Cloud Messaging (FCM) messages when the app is in the background or terminated.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  ///your app can handle incoming FCM messages even when it's not in the foreground and you can ensure Firebase is correctly initialized and functional in the background context.
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await NotificationController().handleNotification(message, "firebaseMessagingBackgroundHandler");
  }

  Future<void> handleNotification(RemoteMessage message, String from) async {
    if (message.data['action'] == 'VERIFY_RESIDENT_PROFILE_TYPE') {
      residentVerifyNotification(message.data['payload']);
    } else if (message.data['action'] == 'VERIFY_GUARD_PROFILE_TYPE') {
      guardVerifyNotification(message.data['payload']);
    } else if (message.data['action'] == 'VERIFY_DELIVERY_ENTRY') {
      showNotificationWithActions(message.data['payload']);
    } else if (message.data['action'] == 'DELIVERY_ENTRY_APPROVE') {
      deliveryEntryApprovedNotification(message.data['payload']);
    } else if (message.data['action'] == 'DELIVERY_ENTRY_REJECTED') {
      deliveryEntryRejectedNotification(message.data['payload']);
    } else if (message.data['action'] == 'NOTIFY_GUARD_APPROVE') {
      notifyGuardApprove(message.data['payload']);
    } else if (message.data['action'] == 'NOTIFY_GUARD_REJECTED') {
      notifyGuardReject(message.data['payload']);
    } else if (message.data['action'] == 'NOTIFY_EXIT_ENTRY') {
      notifyResident(message.data['payload']);
    } else if (message.data['action'] == 'NOTIFY_CHECKED_IN_ENTRY') {
      notifyCheckedInEntry(message.data['payload']);
    } else if (message.data['action'] == 'RESIDENT_APPROVE') {
      notifyRoleVerification(message.data['payload']);
    } else if (message.data['action'] == 'RESIDENT_REJECT') {
      notifyRoleVerification(message.data['payload']);
    } else if (message.data['action'] == 'GUARD_APPROVE') {
      notifyRoleVerification(message.data['payload']);
    } else if (message.data['action'] == 'GUARD_REJECT') {
      notifyRoleVerification(message.data['payload']);
    }else if (message.data['action'] == 'NOTIFY_NOTICE_CREATED') {
      notifyNoticeCreated(message.data['payload']);
    }else if (message.data['action'] == 'NOTIFY_COMPLAINT_CREATED') {
      notifyComplaintCreated(message.data['payload']);
    }else if (message.data['action'] == 'NOTIFY_RESIDENT_REPLIED') {
      notifyResidentReplied(message.data['payload']);
    }else if (message.data['action'] == 'NOTIFY_ADMIN_REPLIED') {
      notifyAdminReplied(message.data['payload']);
    }else if (message.data['action'] == 'NOTIFY_COMPLAINT_REOPENED') {
      notifyComplaintReopened(message.data['payload']);
    }else if (message.data['action'] == 'NOTIFY_COMPLAINT_RESOLVED') {
      notifyComplaintResolved(message.data['payload']);
    }else if (message.data['action'] == 'CANCEL') {
      await AwesomeNotifications().cancel(jsonDecode(message.data['payload'])['notificationId']);
    }
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    NavigatorState? currentState = MyApp.navigatorKey.currentState;

    if (jsonDecode(receivedAction.payload!['data']!)['action'] == 'VERIFY_RESIDENT_PROFILE_TYPE' && isInForeground == true) {
      currentState?.pushNamed('/resident-approval');
    } else if (jsonDecode(receivedAction.payload!['data']!)['action'] == 'VERIFY_GUARD_PROFILE_TYPE' && isInForeground == true) {
      currentState?.pushNamed('/guard-approval');
    } else if (jsonDecode(receivedAction.payload!['data']!)['action'] == 'VERIFY_DELIVERY_ENTRY') {
      if (receivedAction.buttonKeyPressed == 'APPROVE') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accessToken = prefs.getString('accessToken');
        const apiKey = 'https://invite.iotsense.in/api/v1/delivery-entry/approve-delivery';
        final Map<String, dynamic> data = {
          'id': jsonDecode(receivedAction.payload!['data']!)['id'],
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
      } else if (receivedAction.buttonKeyPressed == 'REJECT') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? accessToken = prefs.getString('accessToken');
        const apiKey = 'https://invite.iotsense.in/api/v1/delivery-entry/reject-delivery';
        final Map<String, dynamic> data = {
          'id': jsonDecode(receivedAction.payload!['data']!)['id'],
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
        currentState?.pushNamedAndRemoveUntil('/delivery-approval-screen', (route) => route.isFirst, arguments: jsonDecode(receivedAction.payload!['data']!));
      }
    } else if (jsonDecode(receivedAction.payload!['data']!)['action'] == 'NOTIFY_NOTICE_CREATED' && isInForeground == true) {
      currentState?.pushNamed('/notice-board-details-screen', arguments: NoticeBoardModel.fromJson(jsonDecode(receivedAction.payload!['data']!)));
    } else if (jsonDecode(receivedAction.payload!['data']!)['action'] == 'NOTIFY_COMPLAINT_CREATED' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': jsonDecode(receivedAction.payload!['data']!)['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': jsonDecode(receivedAction.payload!['data']!)['id']});
        });
      }
    } else if (jsonDecode(receivedAction.payload!['data']!)['action'] == 'NOTIFY_RESIDENT_REPLIED' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': jsonDecode(receivedAction.payload!['data']!)['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': jsonDecode(receivedAction.payload!['data']!)['id']});
        });
      }
    } else if (jsonDecode(receivedAction.payload!['data']!)['action'] == 'NOTIFY_ADMIN_REPLIED' && isInForeground == true) {
      if(getCurrentRouteName() == '/complaint-details-screen'){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushReplacementNamed('/complaint-details-screen', arguments: {'id': jsonDecode(receivedAction.payload!['data']!)['id']});
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          currentState?.pushNamed('/complaint-details-screen', arguments: {'id': jsonDecode(receivedAction.payload!['data']!)['id']});
        });
      }
    }
  }

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

  Future<String?> getDeviceToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> updateDeviceToken(BuildContext context,) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // ignore: use_build_context_synchronously
      context.read<AuthBloc>().add(AuthUpdateFCM(FCMToken: newToken));
    });
  }
}
