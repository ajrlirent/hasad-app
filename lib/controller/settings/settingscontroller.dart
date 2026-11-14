// import 'package:hasad/core/constants/color.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// abstract class Settingscontroller extends GetxController {
//   changetheme(bool state);
//   changeTarget(String newTarget);
// }

// class SettingsControllerImp extends Settingscontroller {
//   late bool isdark;
//   String target = "B2B";

//   @override
//   void onInit() {
//     super.onInit();
//     Get.isDarkMode ? isdark = true : isdark = false;
//   }

//   @override
//   changetheme(bool state) {
//     if (state) {
//       isdark = true;
//       Get.changeThemeMode(ThemeMode.dark);
//       Get.changeTheme(ThemeData(
//         fontFamily: "Montsserat",
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: AppColor.backgroundColor,
//       ));
//     } else {
//       isdark = false;
//       Get.changeThemeMode(ThemeMode.light);

//       Get.changeTheme(ThemeData(
//         fontFamily: "Montsserat",
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: AppColor.primaryColor,
//       ));
//     }
//     update();
//   }

//   @override
//   changeTarget(String newTarget) {
//     target = newTarget;
//     update();
//   }
// }
import 'package:hasad/core/constants/color.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

abstract class Settingscontroller extends GetxController {
  changetheme(bool state);
  changeTarget(String newTarget);
  Future<void> updateNotificationsPreference(String preference);
  void changeLanguage(String langCode);
}

class SettingsControllerImp extends Settingscontroller {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs; // Reactive theme mode
  String notificationsPreference = "both"; // Default preference

  @override
  void onInit() async {
    super.onInit();
    await _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool("isDarkMode") ?? false;
    themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
  }

  @override
  changetheme(bool state) async {
    themeMode.value = state ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDarkMode", state);
    update(); // Update UI
  }

  @override
  changeTarget(String newTarget) {
    // Placeholder if you need target functionality later
    update();
  }

  @override
  Future<void> updateNotificationsPreference(String preference) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        Get.snackbar(
          "Error",
          "Authentication token not found.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        return;
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var data = {
        'receive_notifications_from': preference,
      };

      var response = await Dio().post(
        '${ApiLinkNames.server}/api/update-user',
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        notificationsPreference = preference;
        update();
        Get.snackbar(
          "Success",
          "Notification preference updated to $preference.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      } else if (response.statusCode == 422) {
        final errorMessage = response.data['message'] ?? "An error occurred.";
        Get.snackbar(
          "Validation Error",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
        );
      } else {
        Get.snackbar(
          "Error",
          "Unexpected status code: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  // @override
  // void changeLanguage(String langCode) {
  //   var locale = Locale(langCode);
  //   Get.updateLocale(locale);
  //   update();
  // }
  @override
  void changeLanguage(String langCode) {
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
    update(); // Trigger UI rebuild
  }
}

// import 'package:hasad/core/constants/color.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// abstract class Settingscontroller extends GetxController {
//   changetheme(bool state);
//   changeTarget(String newTarget);
//   Future<void> updateNotificationsPreference(String preference);
//   void changeLanguage(String langCode);
// }

// class SettingsControllerImp extends Settingscontroller {
//   late bool isdark;
//   String notificationsPreference = "both"; // Default preference

//   @override
//   void onInit() {
//     super.onInit();
//     Get.isDarkMode ? isdark = true : isdark = false;
//   }

//   @override
//   changetheme(bool state) {
//     if (state) {
//       isdark = true;
//       Get.changeThemeMode(ThemeMode.dark);
//     } else {
//       isdark = false;
//       Get.changeThemeMode(ThemeMode.light);
//     }
//     update();
//   }

//   @override
//   changeTarget(String newTarget) {
//     // Placeholder if you need target functionality later
//     update();
//   }

//   @override
//   Future<void> updateNotificationsPreference(String preference) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       if (token == null) {
//         Get.snackbar(
//           "Error",
//           "Authentication token not found.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//         );
//         return;
//       }

//       var headers = {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       var data = {
//         'receive_notifications_from': preference,
//       };

//       var response = await Dio().post(
//         '${ApiLinkNames.server}/api/update-user',
//         data: data,
//         options: Options(headers: headers),
//       );

//       print("Status Code: ${response.statusCode}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         notificationsPreference = preference;
//         update();
//         Get.snackbar(
//           "Success",
//           "Notification preference updated to $preference.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//         );
//       } else if (response.statusCode == 422) {
//         final errorMessage = response.data['message'] ?? "An error occurred.";
//         Get.snackbar(
//           "Validation Error",
//           errorMessage,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.orange,
//         );
//       } else {
//         Get.snackbar(
//           "Error",
//           "Unexpected status code: ${response.statusCode}",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//       );
//     }
//   }

//   @override
//   void changeLanguage(String langCode) {
//     var locale = Locale(langCode);
//     Get.updateLocale(locale);
//     update();
//   }
// }
