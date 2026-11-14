// import 'package:hasad/controller/settings/settingscontroller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:hasad/core/localization/changelocale.dart';
// import 'package:hasad/data/datasource/static/static.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// import '../../../widgets/home/homepagelogo.dart';

// class CustomOption extends StatelessWidget {
//   final String title;
//   final Widget leading;
//   final VoidCallback ontap;
//   const CustomOption({
//     super.key,
//     required this.title,
//     required this.leading,
//     required this.ontap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//       leading: leading,
//       title: Text(title.tr),
//       onTap: ontap,
//     );
//   }
// }

// class Settings extends GetView<LocaleController> {
//   const Settings({super.key});

//   // Asynchronous function to call the logout API using Dio
//   Future<void> _logout() async {
//     var dio = Dio();

//     // Retrieve the token from SharedPreferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token"); // Make sure "token" is your key

//     if (token == null) {
//       Get.snackbar("Error", "Token not found. Please log in again.");
//       Get.offAllNamed(AppRoutesNames.login);
//       return;
//     }

//     var headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token', // Use the retrieved token
//     };

//     try {
//       final response = await dio.request(
//         '${ApiLinkNames.server}/api/auth/signout',
//         options: Options(
//           method: 'POST',
//           headers: headers,
//         ),
//       );

//       if (response.statusCode == 200) {
//         print(json.encode(response.data)); // Print response for debugging
//         prefs.remove("token"); // Clear the token
//         prefs.setString("skip", "1");
//         Get.offAllNamed(AppRoutesNames.login);
//       } else {
//         // Handle failure
//         Get.snackbar("Logout Failed", response.statusMessage ?? "Error");
//       }
//     } catch (error) {
//       // Handle error
//       Get.snackbar("Error", "Unable to logout. Please try again.");
//     }
//   }

//   // Function to show the confirmation dialog
//   void _showLogoutConfirmation(BuildContext context) {
//     Get.dialog(
//       AlertDialog(
//         title: Text("Logout Confirmation"),
//         content: Text("Are you sure you want to log out?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.back(); // Close dialog
//             },
//             child: Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               Get.back(); // Close dialog
//               _logout(); // Call the logout function
//             },
//             child: Text("Yes, Logout"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Get.put(SettingsControllerImp());
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 20),
//           width: Get.width,
//           height: Get.height,
//           child: ListView(
//             children: [
//               const HomepageLogo(),
//               CustomOption(
//                 title: "settingseditprofile",
//                 leading: const Icon(Icons.person_rounded),
//                 ontap: () {
//                   Get.toNamed(AppRoutesNames.editprofile);
//                 },
//               ),
//               CustomOption(
//                 title: "settingsverifynumber",
//                 leading: const Icon(Icons.phone),
//                 ontap: () {
//                   Get.toNamed(AppRoutesNames.verifyOtp);
//                 },
//               ),
//               GetBuilder<SettingsControllerImp>(
//                 builder: (controller) => ListTile(
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                   leading: const Icon(Icons.nightlight_round_rounded),
//                   title: Text("settingsnightmode".tr),
//                   trailing: Switch(
//                     activeColor: AppColor.backgroundColorDark,
//                     activeTrackColor: AppColor.backgroundColor,
//                     inactiveThumbColor: AppColor.backgroundColorDark,
//                     value: controller.isdark,
//                     onChanged: (val) {
//                       controller.isdark = val;
//                       controller.changetheme(val);
//                     },
//                   ),
//                   onTap: () {
//                     Get.isDarkMode
//                         ? controller.changetheme(false)
//                         : controller.changetheme(true);
//                   },
//                 ),
//               ),
//               GetBuilder<SettingsControllerImp>(
//                 builder: (controller) => ListTile(
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                   leading: const Icon(Icons.track_changes),
//                   title: Text("settingsTargetcustomer".tr),
//                   trailing: DropdownButtonHideUnderline(
//                       child: DropdownButton(
//                     borderRadius: BorderRadius.circular(20),
//                     value: controller.target,
//                     onChanged: (val) {
//                       controller.changeTarget(val!);
//                     },
//                     items: const [
//                       DropdownMenuItem(
//                         value: "B2B",
//                         child: Text("B2B"),
//                       ),
//                       DropdownMenuItem(
//                         value: "Individuel",
//                         child: Text("Individuel"),
//                       )
//                     ],
//                   )),
//                   onTap: () {},
//                 ),
//               ),
//               CustomOption(
//                   title: "settingsterms",
//                   leading: const Icon(Icons.gavel_rounded),
//                   ontap: () {}),
//               CustomOption(
//                   title: "settingsaboutus",
//                   leading: const Icon(Icons.info),
//                   ontap: () {}),
//               CustomOption(
//                 title: "settingschangelanguage",
//                 leading: const Icon(Icons.language_rounded),
//                 ontap: () {
//                   Get.dialog(
//                     SizedBox(
//                       height: Get.height * 0.2,
//                       child: Container(
//                         margin: EdgeInsets.symmetric(
//                           vertical: Get.height * .37,
//                           horizontal: Get.width * .2,
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: Material(
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   ListTile(
//                                     leading: const Icon(Icons.flag),
//                                     title: const Text("français"),
//                                     onTap: () => controller.changelang("fr"),
//                                   ),
//                                   ListTile(
//                                     trailing: const Icon(Icons.flag),
//                                     title: const Text(
//                                       "العربية",
//                                       textDirection: TextDirection.rtl,
//                                     ),
//                                     onTap: () => controller.changelang("ar"),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               CustomOption(
//                 title: "settingslogout",
//                 leading: const Icon(Icons.exit_to_app_rounded),
//                 ontap: () => _showLogoutConfirmation(
//                     context), // Show confirmation dialog
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:hasad/controller/settings/settingscontroller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/home/homepagelogo.dart';
import 'package:hasad/controller/settings/settingscontroller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/home/homepagelogo.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

class CustomOption extends StatelessWidget {
  final String title;
  final Widget leading;
  final VoidCallback ontap;

  const CustomOption({
    super.key,
    required this.title,
    required this.leading,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      leading: leading,
      title: Text(title.tr),
      onTap: ontap,
    );
  }
}

class Settings extends GetView<SettingsControllerImp> {
  const Settings({super.key});

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        Get.snackbar(
          "Error",
          "Token not found. Please log in again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        Get.offAllNamed(AppRoutesNames.login);
        return;
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await Dio().post(
        '${ApiLinkNames.server}/api/auth/signout',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        prefs.remove("token");
        prefs.setString("skip", "1");
        Get.snackbar(
          "Success",
          "Logged out successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
        Get.offAllNamed(AppRoutesNames.login);
      } else {
        Get.snackbar(
          "Error",
          "Failed to log out. Please try again.",
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

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _logout();
            },
            child: const Text("Yes, Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsControllerImp());
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ListView(
            children: [
              const HomepageLogo(),
              CustomOption(
                title: "settingseditprofile",
                leading: const Icon(Icons.person_rounded),
                ontap: () {
                  Get.toNamed(AppRoutesNames.editprofile);
                },
              ),
              CustomOption(
                title: "settingsverifynumber",
                leading: const Icon(Icons.phone),
                ontap: () {
                  Get.toNamed(AppRoutesNames.verifyOtp);
                },
              ),
              GetBuilder<SettingsControllerImp>(
                builder: (controller) => ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  leading: const Icon(Icons.nightlight_round_rounded),
                  title: const Text("Night Mode"),
                  trailing: Switch(
                    activeColor: AppColor.backgroundColorDark,
                    activeTrackColor: AppColor.backgroundColor,
                    inactiveThumbColor: AppColor.backgroundColorDark,
                    value: controller.themeMode.value == ThemeMode.dark,
                    onChanged: (val) {
                      controller.changetheme(val);
                    },
                  ),
                ),
              ),
              CustomOption(
                title: "settingsterms",
                leading: const Icon(Icons.gavel_rounded),
                ontap: () {},
              ),
              CustomOption(
                title: "settingsaboutus",
                leading: const Icon(Icons.info),
                ontap: () {},
              ),
              GetBuilder<SettingsControllerImp>(
                builder: (controller) => ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  leading: const Icon(Icons.language),
                  title: const Text("Change Language"),
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Choose Language"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text("English"),
                              onTap: () {
                                Get.back();
                                controller.changeLanguage("en");
                              },
                            ),
                            ListTile(
                              title: const Text("العربية"),
                              onTap: () {
                                Get.back();
                                controller.changeLanguage("ar");
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomOption(
                title: "settingslogout",
                leading: const Icon(Icons.exit_to_app),
                ontap: _showLogoutConfirmation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
