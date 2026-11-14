import 'package:hasad/constant/ApiLinkNames.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon'); // Replace with your app icon

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: NotificaitonScreenProvider(),
//     );
//   }
// }

// class NotificaitonScreenProvider extends StatefulWidget {
//   const NotificaitonScreenProvider({super.key});

//   @override
//   _NotificaitonScreenProviderState createState() =>
//       _NotificaitonScreenProviderState();
// }

// class _NotificaitonScreenProviderState
//     extends State<NotificaitonScreenProvider> {
//   List<dynamic> notifications = [];
//   bool isLoading = true;
//   Timer? _pollingTimer;

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//     startPollingNotifications();
//   }

//   @override
//   void dispose() {
//     _pollingTimer?.cancel();
//     super.dispose();
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
//       setState(() {
//         isLoading = false;
//       });
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

//         // Get current time
//         DateTime now = DateTime.now();

//         // Filter relevant notifications by type and time
//         List<dynamic> newNotifications = rawNotifications.where((notification) {
//           DateTime createdAt = DateTime.parse(notification['created_at']);
//           bool isWithinLast5Minutes = now.difference(createdAt).inSeconds <= 5;

//           return isWithinLast5Minutes &&
//               (notification['type'] ==
//                       "construction-vehicle-renting-request-placed" ||
//                   notification['type'] ==
//                       "construction-attachment-renting-request-placed" ||
//                   notification['type'] ==
//                       "construction-equipment-renting-request-placed" ||
//                   notification['type'] ==
//                       "transportation-vehicle-renting-request-placed");
//         }).toList();

//         // Check for new notifications and show a local notification
//         for (var notification in newNotifications) {
//           // Customize the title and body of the notification
//           String title = 'New Renting Request';
//           String body =
//               'You have a new ${notification['type']} request. Check it out!';

//           _showLocalNotification(title, body);
//         }

//         setState(() {
//           notifications = newNotifications;
//           isLoading = false;
//         });
//       } else {
//         print(
//             'Error fetching notifications: ${response.statusCode} - ${response.reasonPhrase}');
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Failed to fetch notifications: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Method to show local notification

//   Future<void> _showLocalNotification(String title, String body) async {
//     print('Attempting to show notification: $title'); // Debugging log

//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'channel_id', // Channel ID
//       'Test Channel',
//       channelDescription: 'This channel is used for test notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: iosDetails);

//     try {
//       await flutterLocalNotificationsPlugin.show(
//         0, // Notification ID
//         title,
//         body,
//         platformChannelSpecifics,
//       );
//       print('Notification should be shown'); // Success log
//     } catch (e) {
//       print('Error showing notification: $e'); // Error log
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: fetchNotifications,
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   final notification = notifications[index];
//                   final data = notification['data'];

//                   return FoundCard(
//                     title: data['sub_category_label'] ?? 'Unknown Sub Category',
//                     subtitle: "${data['brand']} ${data['model']}" ??
//                         'Unknown Brand Model',
//                     type: data['renter_type'] ?? 'Unknown',
//                     location: "${data['city']}, ${data['region']}" ??
//                         'Unknown City, Unknown Region',
//                     price: data['order_total_price']?.toString() ?? '0',
//                     message: "You have a new request!",
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }

// class FoundCard extends StatelessWidget {
//   final String? title, subtitle, type, price, location, message;

//   const FoundCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.type,
//     required this.price,
//     required this.location,
//     required this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.yellow.shade50,
//       elevation: 20,
//       margin: EdgeInsets.symmetric(
//           horizontal: Get.context!.width * .03,
//           vertical: Get.context!.height * .02),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: Get.context!.height * .02),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const Icon(Icons.notifications, color: Colors.grey),
//                           const SizedBox(width: 5),
//                           Expanded(
//                             child: Text(
//                               title ?? 'Unknown Sub Category',
//                               style: const TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.w700),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(
//                         subtitle ?? 'Unknown Brand Model',
//                         style:
//                             const TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.person, color: Colors.grey),
//                           Expanded(
//                             child: Text(
//                               type ?? 'N/A',
//                               style: const TextStyle(fontSize: 12),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on, color: Colors.grey),
//                           Expanded(
//                             child: Text(
//                               location ?? 'Unknown City, Unknown Region',
//                               style: const TextStyle(fontSize: 12),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.monetization_on,
//                               color: Colors.green),
//                           Expanded(
//                             child: Text(
//                               "${price ?? '0'} DZD",
//                               style: const TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.w700),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           message ?? 'No Message Available',
//                           style: const TextStyle(
//                               fontSize: 14, color: Colors.blueGrey),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
