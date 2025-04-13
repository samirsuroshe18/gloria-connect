part of 'notification_service.dart';

Future<void> showNotificationWithActions(payloadString) async {
  final payload = jsonDecode(payloadString);

  Map<String, String> message =  _getVerifyNotification(payload['entryType'], payload['societyDetails']['societyGates']);
  int notificationId = payload['notificationId'] ?? 'NA';
  String profileImg = payload['profileImg'] ?? 'NA';
  String name = payload['name'] ?? 'NA';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: notificationId,
      channelKey: 'app_notifications',
      title: message['title'],
      body: '${message['body']}\n$name',
      notificationLayout: NotificationLayout.BigPicture,
      bigPicture: profileImg,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': payloadString},
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

Future<void> residentVerifyNotification(payloadString) async {
  final payload = jsonDecode(payloadString);

  String societyBlock = payload['societyBlock'] ?? 'NA';
  String societyName = payload['societyName'] ?? 'NA';
  String apartment = payload['societyName'] ?? 'NA';
  String ownership = payload['societyName'] ?? 'NA';
  String userName = payload['userName'] ?? 'Anonymous';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Verify resident profile',
      body: 'New resident profile submitted for verification. \n\nName: $userName \nSociety: $societyName \nBlock: $societyBlock \nApartment: $apartment \nOwnership: $ownership \n\n Please review and approve or reject the profile.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': payloadString},
    ),
  );
}

Future<void> guardVerifyNotification(payloadString) async {
  final payload = jsonDecode(payloadString);

  String userName = payload['userName'] ?? 'NA';
  String societyName = payload['societyName'] ?? 'NA';
  String gateAssign = payload['gateAssign'] ?? 'NA';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Verify security guard profile',
      body: 'New security guard profile submitted for verification. \n\nName: $userName \nSociety: $societyName \nGate assigned: $gateAssign \n\n Please review and approve or reject the profile.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': payloadString},
    ),
  );
}

Future<void> deliveryEntryApprovedNotification(stringPayload) async {
  final payload = jsonDecode(stringPayload);

  String? companyName = payload['companyName'] ?? 'NA';
  String? serviceName = payload['serviceName'] ?? 'NA';
  String visitorName = payload['visitorName'] ?? 'NA';
  String userName = payload['userName'] ?? 'NA';
  String entryType = payload['entryType'] ?? 'NA';
  String bodyMessage = deliveryEntryApprovedNotificationMessage(entryType, userName, visitorName, serviceName, companyName);

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Approved',
      body: bodyMessage,
      notificationLayout: NotificationLayout.Default,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': stringPayload},
    ),
  );
}

Future<void> deliveryEntryRejectedNotification(stringPayload) async {
  final payload = jsonDecode(stringPayload);

  String? companyName = payload['companyName'] ?? 'NA';
  String? serviceName = payload['serviceName'] ?? 'NA';
  String visitorName = payload['visitorName'] ?? 'NA';
  String userName = payload['userName'] ?? 'NA';
  String entryType = payload['entryType'] ?? 'NA';
  String bodyMessage = deliveryEntryDeniedNotificationMessage(entryType, userName, visitorName, serviceName, companyName);

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Rejected',
      body: bodyMessage,
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': stringPayload},
    ),
  );
}


Future<void> notifyGuardApprove(stringPayload) async {
  final payload = jsonDecode(stringPayload);

  String deliveryName = payload['deliveryName'] ?? 'NA';
  String userName = payload['userName'] ?? 'NA';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Confirmed',
      body: '$userName (Resident) has approved $deliveryName. Please proceed.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': stringPayload},
    ),
  );
}

Future<void> notifyGuardReject(stringPayload) async {
  final payload = jsonDecode(stringPayload);

  String deliveryName = payload['deliveryName'] ?? 'NA';
  String userName = payload['userName'] ?? 'NA';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Confirmed',
      body: '$userName (Resident) has rejected $deliveryName. Please proceed.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': stringPayload},
    ),
  );
}

Future<void> notifyResident(stringPayload) async {
  final payload = jsonDecode(stringPayload);

  String deliveryName = payload['deliveryName'] ?? 'NA';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Exited',
      body: '$deliveryName has been checked out.',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': stringPayload},
    ),
  );
}

Future<void> notifyResidentCheckedIn(stringPayload) async {
  final payload = jsonDecode(stringPayload);

  String name = payload['name'] ?? 'NA';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'New Visitor Checked In',
      body: '$name has checked in',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': stringPayload},
    ),
  );
}

Future<void> notifyCheckedInEntry(stringPayload) async {
  final payload = jsonDecode(stringPayload);

  String entryType = payload['entryType'] ?? 'NA';
  String deliveryName = payload['deliveryName'] ?? 'NA';
  String guardName = payload['guardName'] ?? 'NA';

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'alert_notification',
      title: 'Entry Confirmed: $entryType',
      body: 'The $entryType ($deliveryName) you pre-approved has been securely checked in by the guard ($guardName).',
      notificationLayout: NotificationLayout.Inbox,
      largeIcon: 'asset://assets/images/app_logo.png',
      wakeUpScreen: true,
      displayOnForeground: true,
      displayOnBackground: true,
      actionType: ActionType.Default,
      payload: {'data': stringPayload},
    ),
  );
}

Future<void> notifyRoleVerification(stringPayload) async {
  final payload = jsonDecode(stringPayload);

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
      payload: {'data': stringPayload},
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
String _getTitle(String action) {
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

// Helper method to generate a message based on entryType
Map<String, String> _getVerifyNotification(String entryType, String gate) {
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
String deliveryEntryApprovedNotificationMessage(String entryType, String userName, String visitorName, String? serviceName, String? companyName, ) {
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

String deliveryEntryDeniedNotificationMessage(String entryType, String userName, String visitorName, String? serviceName, String? companyName) {
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
