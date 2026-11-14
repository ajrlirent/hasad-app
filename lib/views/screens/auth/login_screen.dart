import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/core/functions/validinput.dart';
import 'package:hasad/widgets/home/add/descriptionsection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LoginControllerImp());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height *
                0.03, // 3% of screen height
          ),
          child: Center(
            child: const LoginBody(),
          ),
        ),
      ),
    );
  }
}

class LoginBody extends GetView<LoginControllerImp> {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.loginform,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).size.width * 0.05, // 5% of screen width
        ),
        children: [
          Image.asset(AppImageAsset.logoAuth,
            width:
                MediaQuery.of(context).size.width * 0.5, // 50% of screen width
          ),
          const SizedBox(height: 8),
          Text(
            "HASAD",
            style: TextStyle(
              color: Color(0xFF86D620),
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.10,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.05), // 5% of screen height
          Text(
            "loginHeadline1".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width *
                  0.06, // 6% of screen width
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.05), // 5% of screen width
            child: Text(
              "loginHeadline2".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width *
                    0.04, // 4% of screen width
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.02), // 2% of screen height
          Center(
            child: Text(
              "loginsmalltext".tr,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery.of(context).size.width *
                    0.06, // 6% of screen width
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.02), // 2% of screen height
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height *
                  0.01, // 1% of screen height
              horizontal: MediaQuery.of(context).size.width *
                  0.1, // 10% of screen width
            ),
            child: CustomTextfield(
              () {},
              icon: AppImageAsset.person,
              hinttext: "Loginhintusername".tr,
              isvalid: (val) => validInput(val!, 8, 30, "email"),
              mycontroller: controller.email,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height *
                  0.01, // 1% of screen height
              horizontal: MediaQuery.of(context).size.width *
                  0.1, // 10% of screen width
            ),
            child: CustomTextfield(
              () {},
              icon: AppImageAsset.passIcon,
              hinttext: "signupHintPass".tr,
              isvalid: (val) => validInput(val!, 4, 20, "password"),
              mycontroller: controller.password,
              isPassword: true, // Set this to true for password fields
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height *
                  0.01, // 1% of screen height
              horizontal: MediaQuery.of(context).size.width *
                  0.12, // 12% of screen width
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColor.primaryColor,
                backgroundColor: AppColor.backgroundColor,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height *
                      0.015, // 1.5% of screen height
                ),
              ),
              onPressed: () {
                controller.signIn();
              },
              child: Text(
                "loginbtn".tr,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.045, // 4.5% of screen width
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.03), // 3% of screen height
          Divider(
            color: AppColor.backgroundColor,
            indent: MediaQuery.of(context).size.width * 0.1,
            endIndent: MediaQuery.of(context).size.width * 0.1,
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height *
                  0.01, // 1% of screen height
              horizontal: MediaQuery.of(context).size.width *
                  0.15, // 15% of screen width
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColor.primaryColor,
                backgroundColor: AppColor.secondaryColor,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height *
                      0.02, // 2% of screen height
                  horizontal: MediaQuery.of(context).size.width *
                      0.04, // 4% of screen width
                ),
              ),
              onPressed: () {
                Get.toNamed(AppRoutesNames.signup);
              },
              child: Text(
                "loginGoToSignup".tr,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.038, // 4% of screen width
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
