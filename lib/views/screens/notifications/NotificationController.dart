// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class NotificationController extends GetxController {
//   List<dynamic> notifications = [];
//   bool isLoading = true;
//   Timer? _pollingTimer;

//   @override
//   void onInit() {
//     super.onInit();
//     initializeNotifications(); // Step 4: Initialize notifications
//     fetchNotifications(); // Step 5: Fetch notifications initially
//     startPollingNotifications(); // Step 6: Poll for new notifications
//   }

//   @override
//   void onClose() {
//     _pollingTimer?.cancel();
//     super.onClose();
//   }

//   // Step 4: Initialize the notification plugin
//   Future<void> initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('splash'); // Use your app icon

//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification:
//           (int id, String? title, String? body, String? payload) async {
//         // Handle local notification for iOS if needed
//       },
//     );

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {
//         // Handle what happens when a user taps a notification
//         if (notificationResponse.payload != null) {
//           debugPrint('notification payload: ${notificationResponse.payload}');
//         }
//       },
//     );
//   }

//   // Poll every 15 seconds to fetch new notifications
//   void startPollingNotifications() {
//     _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
//       fetchNotifications();
//     });
//   }

//   Future<void> fetchNotifications() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       print("Error: Token is null. User may not be logged in.");
//       isLoading = false;
//       return;
//     }

//     var headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     try {
//       var response = await http.get(
//         Uri.parse('${ApiLinkNames.server}/api/notifications/'),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> rawNotifications = jsonDecode(response.body);

//         // Filter notifications that haven't been read yet
//         List<dynamic> newNotifications = rawNotifications.where((notification) {
//           return notification['read_at'] == null;
//         }).toList();

//         // Show the notification
//         for (var notification in newNotifications) {
//           String title = "New Notification";
//           String body = "";
//           if (notification['data'] != null) {
//             title = notification['data']['construction_vehicle_sub_category'] ??
//                 title;
//             body =
//                 "Brand: ${notification['data']['construction_vehicle_brand']}, Model: ${notification['data']['construction_vehicle_model']}, City: ${notification['data']['construction_vehicle_city']}, Price: ${notification['data']['order_total_price']} DZD";
//           }
//           _showLocalNotification(title, body);
//         }

//         notifications = newNotifications;
//         isLoading = false;
//       } else {
//         print(
//             'Error fetching notifications: ${response.statusCode} - ${response.reasonPhrase}');
//         isLoading = false;
//       }
//     } catch (e) {
//       print('Failed to fetch notifications: $e');
//       isLoading = false;
//     }
//   }

//   Future<void> _showLocalNotification(String? title, String? body) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'channel_ID',
//       'channel name',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'data',
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationController extends GetxController {
  List<dynamic> notifications = [];
  bool isLoading = true;
  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    initializeNotifications(); // Step 4: Initialize notifications
    fetchNotifications(); // Step 5: Fetch notifications initially
    startPollingNotifications(); // Step 6: Poll for new notifications
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  // Step 4: Initialize the notification plugin
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('splash'); // Use your app icon

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle local notification for iOS if needed
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Handle what happens when a user taps a notification
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: ${notificationResponse.payload}');
        }
      },
    );
  }

  // Poll every 15 seconds to fetch new notifications
  void startPollingNotifications() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      fetchNotifications();
    });
  }

  Future<void> fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Error: Token is null. User may not be logged in.");
      isLoading = false;
      return;
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.get(
        Uri.parse('${ApiLinkNames.server}/api/notifications/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> rawNotifications = jsonDecode(response.body);

        // Get the current time
        DateTime currentTime = DateTime.now();

        // Filter notifications that match specific types, are unread, and were created within the last 2 minutes
        List<dynamic> newNotifications = rawNotifications.where((notification) {
          if (notification['read_at'] != null) return false;

          String notificationType = notification['type'];
          DateTime createdAt = DateTime.parse(notification['created_at']);

          // Calculate the difference in minutes between now and the notification creation time
          Duration timeDifference = currentTime.difference(createdAt);

          // Check if the type matches and if it was created in the last 2 minutes
          return (notificationType ==
                      "construction-vehicle-renting-request-placed" ||
                  notificationType ==
                      "construction-attachment-renting-request-placed" ||
                  notificationType ==
                      "construction-equipment-renting-request-placed" ||
                  notificationType ==
                      "transportation-vehicle-renting-request-placed") &&
              timeDifference.inMinutes < 2;
        }).toList();

        // Show the notification if it matches the criteria
        for (var notification in newNotifications) {
          String title = "New Notification";
          String body = "";
          if (notification['data'] != null) {
            title = notification['data']['construction_vehicle_sub_category'] ??
                notification['data']['construction_attachment_sub_category'] ??
                title;
            body =
                "Brand: ${notification['data']['construction_vehicle_brand'] ?? notification['data']['construction_attachment_brand']}, "
                "Model: ${notification['data']['construction_vehicle_model'] ?? notification['data']['construction_attachment_model']}, "
                "City: ${notification['data']['construction_vehicle_city'] ?? notification['data']['construction_attachment_city']}, "
                "Price: ${notification['data']['order_total_price']} DZD";
          }
          _showLocalNotification(title, body);
        }

        notifications = newNotifications;
        isLoading = false;
      } else {
        print(
            'Error fetching notifications: ${response.statusCode} - ${response.reasonPhrase}');
        isLoading = false;
      }
    } catch (e) {
      print('Failed to fetch notifications: $e');
      isLoading = false;
    }
  }

  Future<void> _showLocalNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_ID',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'data',
    );
  }
}
