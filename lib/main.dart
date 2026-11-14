// import 'package:hasad/controller/auth/login_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/localization/changelocale.dart';
// import 'package:hasad/core/localization/translations.dart';

// import 'package:hasad/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initialservices();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     LocaleController controller = Get.put(LocaleController());
//     Get.isDarkMode
//         ? SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//             statusBarColor: AppColor.backgroundColorDark))
//         : SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//             statusBarColor: AppColor.backgroundColor));
//     return GetMaterialApp(
//       locale: controller.langage,
//       translations: MyTranslations(),
//       themeMode: ThemeMode.system,
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           fontFamily: "Montsserat",
//           brightness: Brightness.light,
//           appBarTheme: const AppBarTheme(color: AppColor.primaryColor)),
//       darkTheme: ThemeData(
//           fontFamily: "Montsserat",
//           brightness: Brightness.dark,
//           appBarTheme:
//               const AppBarTheme(backgroundColor: AppColor.backgroundColorDark)),
//       getPages: routes,
//     );
//   }
// }import 'package:flutter/material.dart';
// hada code li takhdam fih notificatoin
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Request permission for Android notifications
//   await requestAndroidNotificationPermission();

//   // Request permission for iOS notifications
//   await requestIOSPermissions();

//   // Initialize the notifications
//   await initializeNotifications();

//   runApp(MyApp());
// }

// Future<void> requestAndroidNotificationPermission() async {
//   // Request notification permission for Android (for Android 13 and above)
//   if (await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }
// }

// Future<void> requestIOSPermissions() async {
//   // Request permission for iOS notifications
//   final IOSFlutterLocalNotificationsPlugin? iosNotificationPlugin =
//       flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//           IOSFlutterLocalNotificationsPlugin>();

//   iosNotificationPlugin?.requestPermissions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
// }

// // Define the initializeNotifications function
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher'); // Use your app icon

//   final DarwinInitializationSettings initializationSettingsDarwin =
//       DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//     onDidReceiveLocalNotification:
//         (int id, String? title, String? body, String? payload) async {
//       // Handle local notification for iOS if needed
//       debugPrint('Received local notification: $title');
//     },
//   );

//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsDarwin,
//   );

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse:
//         (NotificationResponse notificationResponse) async {
//       if (notificationResponse.payload != null) {
//         debugPrint('notification payload: ${notificationResponse.payload}');
//       }
//     },
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Notification Test',
//       home: NotificationTestScreen(),
//     );
//   }
// }

// class NotificationTestScreen extends StatelessWidget {
//   const NotificationTestScreen({Key? key}) : super(key: key);

//   void showLocalNotification(String title, String body) async {
//     debugPrint("Attempting to show local notification");

//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'default_channel_id',
//       'default_channel',
//       channelDescription: 'default description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const DarwinNotificationDetails iosPlatformChannelSpecifics =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iosPlatformChannelSpecifics,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch.remainder(100000),
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: 'data',
//     );

//     debugPrint("Local notification shown");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification Test'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Test notification
//             showLocalNotification(
//                 "Test Title", "This is a test notification body");
//           },
//           child: const Text('Show Test Notification'),
//         ),
//       ),
//     );
//   }
// }
// dart:async';import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/core/localization/changelocale.dart';
import 'package:hasad/core/localization/translations.dart';
import 'package:hasad/routes.dart';
import 'package:hasad/controller/settings/settingscontroller.dart';
import 'package:hasad/views/screens/splashscreen/splashscreen.dart';
import 'package:hasad/views/screens/notifications/NotificationController.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences and services
  await _initializeServices();

  // Request notification permissions
  await _requestNotificationPermission();

  // Initialize local notifications
  await _initializeLocalNotifications();

  // Lock the app orientation to portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize SettingsController globally
  Get.put<SettingsControllerImp>(SettingsControllerImp());

  // Check if the user is logged in
  bool isLoggedIn = await _checkLoginStatus();

  // Initialize NotificationController globally
  Get.put(NotificationController());

  // Run the app
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<void> _initializeServices() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  MyServices myServices = MyServices()..sharedprefs = prefs;
  Get.put<MyServices>(myServices, permanent: true);
}

Future<void> _requestNotificationPermission() async {
  if (await Permission.notification.isDenied ||
      await Permission.notification.isRestricted) {
    // Request notification permission
    await Permission.notification.request();
  }
}

Future<void> _initializeLocalNotifications() async {
  try {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'app_icon'); // Replace 'app_icon' with your app's icon

    // iOS initialization settings
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle notification tapped on iOS
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the notification plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          debugPrint('Notification payload: ${notificationResponse.payload}');
        }
      },
    );
  } catch (e) {
    print("Error initializing local notifications: $e");
  }
}

Future<bool> _checkLoginStatus() async {
  MyServices myServices = Get.find<MyServices>();
  return myServices.isLoggedIn();
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocaleController localeController = Get.put(LocaleController());

    // Get the settings controller
    final SettingsControllerImp settingsController =
        Get.find<SettingsControllerImp>();

    return Obx(() {
      return GetMaterialApp(
        fallbackLocale: Locale('en'),
        locale: localeController.langage,
        translations: MyTranslations(),
        debugShowCheckedModeBanner: false,
        themeMode: settingsController.themeMode.value,
        theme: ThemeData(
          fontFamily: "Montsserat",
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(color: AppColor.primaryColor),
        ),
        darkTheme: ThemeData(
          fontFamily: "Montsserat",
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.backgroundColorDark,
          ),
        ),
        getPages: routes, // Define all routes in routes.dart
        initialRoute: isLoggedIn
            ? AppRoutesNames.homepage
            : AppRoutesNames.splashscreen, // Dynamically decide the route
        home: Splashscreen(), // Always show splash screen on startup
      );
    });
  }
}

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
                      "transportation-vehicle-renting-request-placed" ||
                  // A provider submitted an offer for the renter's demand
                  notificationType ==
                      "construction-vehicle-renting-request-provider-found" ||
                  notificationType ==
                      "construction-attachment-renting-request-provider-found" ||
                  notificationType ==
                      "construction-equipment-renting-request-provider-found" ||
                  notificationType ==
                      "transportation-vehicle-renting-request-provider-found") &&
              timeDifference.inMinutes < 2;
        }).toList();

        // Show the notification if it matches the criteria
        for (var notification in newNotifications) {
          String title = "New Notification";
          String body = "";
          if (notification['data'] != null) {
            final data = notification['data'];
            // Category-prefixed machine keys (vehicle / attachment /
            // equipment / transportation).
            final prefixes = [
              'construction_vehicle',
              'construction_attachment',
              'construction_equipment',
              'transportation_vehicle'
            ];
            String? subCategory;
            String? brand;
            String? model;
            String? city;
            for (final prefix in prefixes) {
              subCategory ??= data['${prefix}_sub_category'];
              brand ??= data['${prefix}_brand'];
              model ??= data['${prefix}_model'];
              city ??= data['${prefix}_city'];
            }
            title = subCategory ?? title;
            // New demands carry the machine's price per day; offer
            // notifications carry the offer total price.
            final price = data['machine_price_per_day'] ??
                data['order_total_price'] ??
                'N/A';
            final priceLabel = data['machine_price_per_day'] != null
                ? 'Price/day: $price DZD'
                : 'Price: $price DZD';
            body = "Brand: ${brand ?? '-'}, "
                "Model: ${model ?? '-'}, "
                "City: ${city ?? '-'}, "
                "$priceLabel";
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

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}


// import 'package:hasad/controller/auth/login_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/routes_names.dart';

// import 'package:hasad/core/localization/changelocale.dart';
// import 'package:hasad/core/localization/translations.dart';
// import 'package:hasad/routes.dart';
// import 'package:hasad/views/screens/notifications/NotificationController.dart';
// import 'package:hasad/views/screens/splashscreen/splashscreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   try {
//     // Initialize MyServices with Get.putAsync to ensure completion before access
//     await Get.putAsync(() async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       MyServices myServices = MyServices();
//       myServices.sharedprefs = prefs;
//       return myServices;
//     });
//     MyServices myServices = Get.find<MyServices>();
//     await initialservices(); // Ensure services are initialized fully
//     bool isLoggedIn = myServices.isLoggedIn();
//     bool isFirstTime = myServices.isFirstTime();
//     // Request notification permission for Android 13 and above
//     await _requestNotificationPermission();
//     // Initialize notification plugin
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('splash');

//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
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
//         if (notificationResponse.payload != null) {
//           debugPrint('notification payload: ${notificationResponse.payload}');
//         }
//       },
//     );

//     // Initialize services and check for login status
//     // await initialservices();
//     // bool isLoggedIn = Get.find<MyServices>().isLoggedIn();

//     // Initialize controllers and set orientation
//     Get.put(NotificationController());
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//     // Pass isFirstTime and isLoggedIn to MyApp
//     runApp(MyApp(isLoggedIn: isLoggedIn)); // Do not use const here
//   } catch (e) {
//     print("Error in main initialization: $e");
//   }
// }

// Future<void> _requestNotificationPermission() async {
//   if (await Permission.notification.isDenied ||
//       await Permission.notification.isRestricted) {
//     // Request permission if not granted
//     await Permission.notification.request();
//   }
// }

// Future<void> initialservices() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   MyServices myServices = MyServices();
//   myServices.sharedprefs = prefs;
//   Get.put<MyServices>(myServices,
//       permanent: true); // Register MyServices with GetX
// }

// class MyApp extends StatelessWidget {
//   final bool isLoggedIn;

//   const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     LocaleController controller = Get.put(LocaleController());

//     _configureSystemUIOverlay();

//     return GetMaterialApp(
//       locale: controller.langage,
//       translations: MyTranslations(),
//       themeMode: ThemeMode.system,
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: "Montsserat",
//         brightness: Brightness.light,
//         appBarTheme: const AppBarTheme(color: AppColor.primaryColor),
//       ),
//       darkTheme: ThemeData(
//         fontFamily: "Montsserat",
//         brightness: Brightness.dark,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColor.backgroundColorDark,
//         ),
//       ),
//       getPages: routes, // Your route definitions
//       // initialRoute:
//       //     isLoggedIn ? AppRoutesNames.homepage : AppRoutesNames.login);
//       initialRoute: Splashscreen(),
//     );
//   }

//   void _configureSystemUIOverlay() {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarColor: Get.isDarkMode
//             ? AppColor.backgroundColorDark
//             : AppColor.backgroundColor,
//         statusBarIconBrightness:
//             Get.isDarkMode ? Brightness.light : Brightness.dark,
//       ),
//     );
//   }
// }
