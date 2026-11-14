// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// abstract class EditprofileController extends GetxController {
//   updateprofile();
// }

// class EditprofileControllerImp extends EditprofileController {
//   late bool isdark;

//   late GlobalKey<FormState> myformkey;
//   late TextEditingController username;
//   late TextEditingController email;
//   late TextEditingController phone;
//   late TextEditingController password;

//   @override
//   void onInit() {
//     super.onInit();
//     myformkey = GlobalKey<FormState>();
//     username = TextEditingController();
//     email = TextEditingController();
//     phone = TextEditingController();
//     password = TextEditingController();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     username.dispose();
//     email.dispose();
//     phone.dispose();
//     password.dispose();
//   }

//   @override
//   updateprofile() {}
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

abstract class EditprofileController extends GetxController {
  Future<void> updateProfile();
}

class EditprofileControllerImp extends EditprofileController {
  late GlobalKey<FormState> myFormKey;
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController password;

  @override
  void onInit() {
    super.onInit();
    myFormKey = GlobalKey<FormState>();
    username = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Future<void> updateProfile() async {
    // Check if all fields are empty
    if (username.text.isEmpty &&
        email.text.isEmpty &&
        phone.text.isEmpty &&
        password.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill at least one field to update.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return;
    }

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
        if (username.text.isNotEmpty) 'first_name': username.text,
        if (email.text.isNotEmpty) 'email': email.text,
        if (phone.text.isNotEmpty) 'phone': phone.text,
        if (password.text.isNotEmpty) 'password': password.text,
      };

      var response = await Dio().post(
        '${ApiLinkNames.server}/api/update-user',
        data: data,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Profile updated successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      } else {
        // Generic error handling for non-200/201 status codes
        Get.snackbar(
          "Error",
          "Failed to update profile: ${response.data['message'] ?? response.statusMessage ?? 'Unknown error'}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    } on DioError catch (e) {
      // Handle specific 422 error
      if (e.response?.statusCode == 422) {
        final message = e.response?.data['message'] ?? "Validation error.";
        final errors = e.response?.data['errors'];
        if (errors != null) {
          // Extract errors for each field
          String detailedMessage = errors.entries
              .map((entry) => "${entry.key}: ${entry.value.join(", ")}")
              .join("\n");
          Get.snackbar(
            "Error",
            detailedMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          );
        } else {
          Get.snackbar(
            "Error",
            message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          );
        }
      } else {
        // Fallback for other errors
        Get.snackbar(
          "Error",
          "An error occurred: ${e.message}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }
}
