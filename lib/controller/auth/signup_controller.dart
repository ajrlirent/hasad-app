import 'dart:convert';
import 'dart:io';
import 'package:hasad/controller/auth/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

class SignupControllerImp extends GetxController {
  // Services
  MyServices myServices = Get.find();

  // Text editing controllers for the signup form
  late TextEditingController nom;
  late TextEditingController prenom;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController phone;
  String? role;
  String? type;

  // Form key
  final GlobalKey<FormState> signupformkey = GlobalKey<FormState>();

  // User-selected profile picture and documents
  File? profilePicture;
  List<File>? documents = [];

  @override
  void onInit() {
    nom = TextEditingController();
    prenom = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    phone = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    nom.dispose();
    prenom.dispose();
    email.dispose();
    password.dispose();
    phone.dispose();
    super.dispose();
  }

  // Set the role and type for the signup
  void setRole(String chosenRole) {
    role = chosenRole;
    update();
  }

  void setType(String chosenType) {
    type = chosenType;
    update();
  }

  // Function to handle user signup
  Future<void> signup() async {
    if (!signupformkey.currentState!.validate()) return;

    String userType;
    String notificationPreference;

    // Determine user_type and receive_notifications_from values
    if (role == "provider") {
      userType = type == "society" ? "provider_society" : "provider_individual";
      notificationPreference = "both";
    } else {
      userType = type == "society" ? "renter_society" : "renter_individual";
      notificationPreference = "none";
    }

    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      // Prepare multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiLinkNames.server}/api/auth/signup'),
      );
      request.headers.addAll(headers);

      // Add fields including phone
      request.fields['first_name'] = nom.text;
      request.fields['last_name'] = prenom.text;
      request.fields['email'] = email.text;
      request.fields['password'] = password.text;
      request.fields['phone'] = phone.text;
      request.fields['user_type'] = userType;
      request.fields['receive_notifications_from'] = notificationPreference;

      // Attach profile picture if selected
      if (profilePicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicture!.path,
        ));
      }

      // Attach documents if selected
      for (var document in documents ?? []) {
        request.files.add(await http.MultipartFile.fromPath(
          'documents[]',
          document.path,
        ));
      }

      // Execute the request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("Status Code: ${response.statusCode}"); // Print status code

      if (response.statusCode == 201) {
        // Successful signup
        print("Success Response: $responseBody"); // Print success response
        Get.snackbar('Success', 'Signup successful!',
            snackPosition: SnackPosition.BOTTOM);

        myServices.sharedprefs.setString("skip", "2");
        myServices.sharedprefs.setString("role", role!);
        Get.offAllNamed(AppRoutesNames.login);
      } else {
        // Handle errors and print error response
        print("Error Response: $responseBody"); // Print error response
        String message = 'Signup failed. Please try again.';
        try {
          final decoded = jsonDecode(responseBody);
          if (decoded is Map && decoded['errors'] is Map) {
            final errors = decoded['errors'] as Map;
            if (errors.isNotEmpty) {
              final first = errors.values.first;
              if (first is List && first.isNotEmpty) {
                message = first.first.toString();
              }
            }
          } else if (decoded is Map && decoded['message'] is String) {
            message = decoded['message'] as String;
          }
        } catch (_) {}
        Get.snackbar('Signup failed', message,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Print any exceptions that occur
      print("Exception: $e");
      Get.snackbar('Error',
          'An error occurred. Please check your connection and try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
