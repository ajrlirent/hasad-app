// import 'package:hasad/controller/auth/login_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

// class Splashscreen extends StatefulWidget {
//   const Splashscreen({super.key});

//   @override
//   _SplashscreenState createState() => _SplashscreenState();
// }

// class _SplashscreenState extends State<Splashscreen> {
//   MyServices myServices = Get.find();

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 2), () {
//       // Check if onboarding is completed
//       if (myServices.sharedprefs.getString("skip") == null) {
//         // Show onboarding if "skip" is not set
//         Get.offAllNamed(AppRoutesNames.onBoarding);
//       } else if (myServices.sharedprefs.getString("isLoggedIn") == "true") {
//         // Redirect to homepage if logged in
//         Get.offAllNamed(AppRoutesNames.homepage,
//             arguments: {"inservice": false});
//       } else {
//         // Redirect to login if not logged in
//         Get.offAllNamed(AppRoutesNames.login);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xFF6FCB3B), Color(0xFF0A6B3A)],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Spacer(),
//               Image.asset(AppImageAsset.splashlogo),
//               const SizedBox(height: 20),
//               SvgPicture.asset(AppImageAsset.splashTitle),
//               const SizedBox(height: 180),
//               Lottie.asset(
//                 AppImageAsset.loading,
//                 height: 130,
//                 width: 130,
//                 repeat: true,
//                 frameRate: const FrameRate(40),
//               ),
//               Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SplashscreenController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   MyServices myServices = Get.find();

//   @override
//   void onInit() {
//     super.onInit();
//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(statusBarColor: Color(0xFFFF5D00)));
//   }

//   @override
//   void onClose() {
//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(statusBarColor: AppColor.backgroundColor));
//     super.onClose();
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     if (myServices.sharedprefs.getString("skip") == null) {
//       Future.delayed(const Duration(seconds: 2), () {
//         Get.offAllNamed(AppRoutesNames.onBoarding);
//       });
//     } else if (myServices.sharedprefs.getString("skip") == "1") {
//       Future.delayed(const Duration(seconds: 2), () {
//         Get.offAllNamed(AppRoutesNames.login);
//       });
//     } else {
//       Future.delayed(const Duration(seconds: 2), () {
//         Get.offAllNamed(AppRoutesNames.homepage,
//             arguments: {"inservice": false});
//       });
//     }
//   }
// }
import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  MyServices myServices = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _navigateToNextScreen);
  }

  void _navigateToNextScreen() {
    if (myServices.sharedprefs.getString("skip") == null) {
      // Navigate to onboarding if it's the user's first time
      Get.offAllNamed(AppRoutesNames.onBoarding);
    } else if (myServices.sharedprefs.getString("isLoggedIn") == "true") {
      // Navigate to homepage if the user is logged in
      Get.offAllNamed(AppRoutesNames.homepage, arguments: {"inservice": false});
    } else {
      // Otherwise, navigate to login
      Get.offAllNamed(AppRoutesNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6FCB3B), Color(0xFF0A6B3A)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                AppImageAsset.splashlogo,
                width: 230,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 180),
              Lottie.asset(
                AppImageAsset.loading,
                height: 130,
                width: 130,
                repeat: true,
                frameRate: const FrameRate(40),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
