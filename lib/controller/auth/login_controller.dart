import 'package:hasad/core/constants/routes_names.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio; // Use prefix for Dio
import 'package:hasad/constant/ApiLinkNames.dart';

abstract class LoginController extends GetxController {
  goToSignup();
  signIn();
  signOut();
}

class LoginControllerImp extends LoginController {
  MyServices myServices = Get.find<MyServices>();

  late TextEditingController email;
  late TextEditingController password;

  GlobalKey<FormState> loginform = GlobalKey<FormState>();

  @override
  signIn() async {
    var loginformdata = loginform.currentState;
    if (loginformdata!.validate()) {
      var emailInput = email.text;
      var passwordInput = password.text;

      try {
        var userRole =
            await myServices.authenticateUser(emailInput, passwordInput);

        // Store the user's role in SharedPreferences
        myServices.sharedprefs.setString('role', userRole);

        switch (userRole) {
          case 'provider_individual':
          case 'provider_society':
          case 'renter_individual':
          case 'renter_society':
            Get.offAllNamed(AppRoutesNames.homepage);
            break;
          default:
            Get.snackbar(
              'Error',
              'Invalid role or login details.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            break;
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  goToSignup() {
    Get.toNamed(AppRoutesNames.signup);
  }

  @override
  signOut() async {
    await myServices.clearToken();
    Get.offAllNamed(AppRoutesNames.login);
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}

class MyServices extends GetxService {
  String? token;
  late SharedPreferences sharedprefs;

  Future<MyServices> init() async {
    print('Initializing SharedPreferences...');
    sharedprefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized.');
    return this;
  }

  // Future<MyServices> setToken(String thistoken) async {
  //   print("Saving token: $thistoken");
  //   sharedprefs.setString("token", thistoken);
  //   return this;
  // }

  // String? getToken() {
  //   String? token = sharedprefs.getString("token");
  //   print("Retrieved token: $token");
  //   return token;
  // }
  Future<MyServices> setToken(String thistoken) async {
    print("Saving token: $thistoken");
    await sharedprefs.setString("token", thistoken);
    return this;
  }

  String? getToken() {
    String? token = sharedprefs.getString("token");
    print("Retrieved token: $token");
    return token;
  }

  Future<MyServices> clearToken() async {
    sharedprefs.remove("token");
    return this;
  }

  bool isFirstTime() {
    return sharedprefs.getBool('isFirstTime') ?? true;
  }

  Future<void> setFirstTime(bool isFirstTime) async {
    await sharedprefs.setBool('isFirstTime', isFirstTime);
  }

  bool isLoggedIn() {
    token = sharedprefs.getString("token");
    return token != null && token!.isNotEmpty;
  }
  // bool isLoggedIn() {
  //   String? token = sharedprefs.getString("token");
  //   if (token == null || token.isEmpty) return false;

  //   // Optionally, check token expiry if your API provides expiration logic.
  //   // For instance, decode a JWT token and check expiry date.

  //   return true;
  // }

  Future<String> authenticateUser(String email, String password) async {
    for (int i = 0; i < 3; i++) {
      try {
        var headers = {'Accept': 'application/json'};
        var data = dio.FormData.fromMap({
          'email': email,
          'password': password,
        });

        var dioInstance = dio.Dio(
          BaseOptions(
            connectTimeout:
                Duration(milliseconds: 10000), // Updated to Duration
            receiveTimeout:
                Duration(milliseconds: 10000), // Updated to Duration
          ),
        );

        var response = await dioInstance.post(
          '${ApiLinkNames.server}/api/auth/signin',
          options: dio.Options(
            headers: headers,
          ),
          data: data,
        );

        if (response.statusCode == 200) {
          var accessToken = response.data['access_token'];
          await setToken(accessToken); // Save token
          if (response.data is Map<String, dynamic> &&
              response.data.containsKey('user')) {
            var userType = response.data['user']['user_type'];
            return userType;
          } else {
            throw Exception('Invalid response structure: Missing user object');
          }
        } else {
          throw Exception('Invalid credentials: ${response.data}');
        }
      } catch (e) {
        print('Attempt ${i + 1} failed: $e');
        if (i == 2) {
          throw Exception(
              'Failed to authenticate user after multiple attempts: $e');
        }
      }
    }
    return ''; // Just to satisfy return, it will never reach here
  }
}

// Future<void> initialservices() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   // MyServices myServices = MyServices();
//   MyServices myServices = MyServices();
//   myServices.sharedprefs = prefs;

//   await myServices.init();
//   Get.put<MyServices>(myServices, permanent: true);
//   await Get.putAsync(() => MyServices().init());
// }


// Future<void> initialservices() async {await Get.putAsync(() => MyServices().init());}
