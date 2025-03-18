part of 'notification_service.dart';

Future<void> showNotificationWithActions(payload) async {

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: int.parse(payload['notificationId']),
      channelKey: 'app_notifications',
      title: 'Verify delivery',
      body: 'You have got a Delivery at the main gate.\n${payload['name']}',
      notificationLayout: NotificationLayout.BigPicture,
      bigPicture: payload['profileImg'],
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'APPROVE',
        label: 'Approve',
        autoDismissible: true,
        actionType: ActionType.SilentBackgroundAction,
        enabled: true,
      ),
      NotificationActionButton(
        key: 'REJECT',
        label: 'Reject',
        autoDismissible: true,
        actionType: ActionType.SilentBackgroundAction,
        enabled: true,
      ),
    ],
  );
}

Future<void> residentVerifyNotification(payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Verify resident profile',
      body: 'New resident profile submitted for verification. \n\nName: ${payload['userName']} \nSociety: ${payload['societyName'] ?? 'Society name'} \nBlock: ${payload['societyBlock'] ?? 'Society block'} \nApartment: ${payload['apartment'] ?? 'Society apartment'} \nOwnership: ${payload['ownership'] ?? 'Ownership'} \n\n Please review and approve or reject the profile.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> guardVerifyNotification(payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Verify security guard profile',
      body: 'New security guard profile submitted for verification. \n\nName: ${payload['userName']} \nSociety: ${payload['societyName']} \nGate assigned: ${payload['gateAssign']} \n\n Please review and approve or reject the profile.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> deliveryEntryApprovedNotification(payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Approved',
      body: 'The delivery entry for ${payload['companyName']} (${payload['deliveryName']}) has been approved by ${payload['userName']}.',
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> deliveryEntryRejectedNotification(payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Rejected',
      body: 'The delivery entry for ${payload['companyName']} (${payload['deliveryName']}) has been rejected by ${payload['userName']}.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> notifyGuardApprove(payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Confirmed',
      body: '${payload['userName']} (Resident) has approved ${payload['deliveryName']}. Please proceed.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> notifyGuardReject(payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Confirmed',
      body: '${payload['userName']} (Resident) has rejected ${payload['deliveryName']}. Please proceed.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> notifyResident(payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Exited',
      body: '${payload['deliveryName']} has been checked out.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> notifyCheckedInEntry(payload) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Confirmed: ${payload['entryType']}',
      body: 'The ${payload['entryType']} (${payload['deliveryName']}) you pre-approved has been securely checked in by the guard (${payload['guardName']}).',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> notifyRoleVerification(payload) async {
  String message = _getBody(payload["action"]);
  String title = _getTitle(payload["action"]);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: title,
      body: message,
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: payload,
    ),
  );
}

Future<void> notifyNoticeCreated(payloadString) async {
  final payload = jsonDecode(payloadString);

  String societyName = payload['society'] ?? 'Unknown Society';
  String noticeTitle = payload['title'] ?? 'New Notice';
  String noticeCategory = payload['category'] ?? 'General';
  String publishedBy = payload['publishedBy']['userName'] ?? 'Admin';

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

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: "$categoryLabel in $societyName",
      body: "$noticeTitle\nPublished by: $publishedBy",
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      category: NotificationCategory.Reminder,
      payload: {'data': payloadString}, // Ensure payload is properly formatted
    ),
  );
}

Future<void> notifyComplaintCreated(payloadString) async {
  final payload = jsonDecode(payloadString);
  String complaintType = payload['category'] ?? 'Unknown';
  String societyName = payload['societyName'] ?? 'Unknown';
  String userName = payload['raisedBy']['userName'] ?? 'Anonymous';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: "New Complaint: $complaintType in $societyName",
      body: '$userName has registered a complaint.',
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      category: NotificationCategory.Reminder,
      payload: {'data': payloadString}, // Ensure payload is properly formatted
    ),
  );
}

Future<void> notifyAdminReplied(String payloadString) async {
  final payload = jsonDecode(payloadString);
  String complaintType = payload['category'] ?? 'Unknown';
  String societyName = payload['societyName'] ?? 'Unknown';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: "🛠️ Admin Responded to Your Complaint",
      body: "Your complaint regarding $complaintType in $societyName has received a response from the admin. Check now for updates.",
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      category: NotificationCategory.Reminder,
      payload: {'data': payloadString}, // Ensure payload is properly formatted
    ),
  );
}

Future<void> notifyResidentReplied(String payloadString) async {
  final payload = jsonDecode(payloadString);
  String complaintType = payload['category'] ?? 'Unknown';
  String societyName = payload['societyName'] ?? 'Unknown';
  String userName = payload['raisedBy']['userName'] ?? 'Anonymous';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: "📩 New Reply on Complaint",
      body: "$userName has responded to the complaint regarding $complaintType in $societyName. Check now for details.",
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      category: NotificationCategory.Reminder,
      payload: {'data': payloadString}, // Ensure payload is properly formatted
    ),
  );
}

Future<void> notifyComplaintResolved(String payloadString) async {
  final payload = jsonDecode(payloadString);

  String complaintType = payload['category'] ?? 'Unknown';
  String societyName = payload['societyName'] ?? 'Unknown';
  String resolvedBy = payload['resolvedBy'] ?? 'Unknown';
  bool isResolvedByResident = payload['isResolvedByResident'];

  String title = isResolvedByResident
      ? "Complaint Resolved by Resident: $complaintType"
      : "Complaint Resolved: $complaintType";

  String body = isResolvedByResident
      ? "$resolvedBy has marked the complaint regarding $complaintType as resolved."
      : "Your complaint regarding $complaintType has been resolved by $resolvedBy.";

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      category: NotificationCategory.Reminder,
      payload: {'data': payloadString},
    ),
  );
}

Future<void> notifyComplaintReopened(String payloadString) async {
  final payload = jsonDecode(payloadString);
  String complaintType = payload['category'] ?? 'Unknown';
  String societyName = payload['societyName'] ?? 'Unknown';
  String reopenedBy = payload['reopenedBy'] ?? 'Unknown';
  bool isReopenedByResident = payload['isReopenedByResident'];

  String title = isReopenedByResident
      ? "Complaint Reopened by Resident: $complaintType"
      : "Complaint Reopened: $complaintType";

  String body = isReopenedByResident
      ? "$reopenedBy has reopened the complaint regarding $complaintType in $societyName."
      : "Your complaint regarding $complaintType has been reopened by $reopenedBy.";

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      category: NotificationCategory.Reminder,
      payload: {'data': payloadString},
    ),
  );
}



// Helper method to generate a message based on action
String _getBody(String action) {
  if (action == "RESIDENT_APPROVE") {
    return "Congratulations! Your resident profile has been successfully approved.";
  } else if(action == "RESIDENT_REJECT"){
    return "Unfortunately, your resident profile was not approved. For more information, please reach out to us.";
  } else if(action == "GUARD_APPROVE"){
    return "Congratulations! Your guard profile has been successfully approved.";
  } else{
    return "Unfortunately, your guard profile was not approved. For more information, please reach out to us.";
  }
}

// Helper method to generate a message based on action
String _getTitle(String action) {
  if (action == "RESIDENT_APPROVE") {
    return "Resident Profile Approved";
  } else if(action == "RESIDENT_REJECT"){
    return "Resident Profile Rejected";
  } else if(action == "GUARD_APPROVE"){
    return "Security Guard Profile Approved";
  } else{
    return "Security Guard Profile Rejected";
  }
}
