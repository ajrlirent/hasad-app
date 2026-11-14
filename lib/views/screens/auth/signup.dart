import 'package:hasad/controller/auth/signup_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/views/screens/auth/verifyotp.dart';
import 'package:hasad/widgets/auth/signup/chooserole.dart';
import 'package:hasad/widgets/auth/signup/clientdocText.dart';
import 'package:hasad/widgets/auth/signup/clientdocsection.dart';
import 'package:hasad/widgets/auth/signup/profilepicBtn.dart';
import 'package:hasad/widgets/auth/signup/signup_btn.dart';
import 'package:hasad/widgets/home/add/descriptionsection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends GetView<SignupControllerImp> {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignupControllerImp());
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: controller.signupformkey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
          height: Get.height,
          width: Get.width,
          child: GetBuilder<SignupControllerImp>(
            builder: (controller) => ListView(
              children: [
                Customtitle(
                  titre: "signuptitle".tr,
                  space: -1.8,
                ),
                SmallDescSection(desc: "signupsmalldesc".tr),
                const SizedBox(height: 15),

                // Profile Picture Button
                ProfilePictureBtn(
                  onFileSelected: (file) {
                    controller.profilePicture = file;
                  },
                ),
                const SizedBox(height: 5),

                Text(
                  "signupaddphototext".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColor.textColor,
                      fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Name and Surname Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 10,
                      child: CustomTextfield(
                        () {},
                        icon: AppImageAsset.person,
                        hinttext: "signupHintName".tr,
                        isvalid: (val) => null,
                        mycontroller: controller.nom,
                        bordercolor: AppColor.backgroundColor,
                        radius: 34,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 10,
                      child: CustomTextfield(
                        () {},
                        icon: AppImageAsset.person,
                        hinttext: "signupHintPrename".tr,
                        isvalid: (val) => null,
                        mycontroller: controller.prenom,
                        bordercolor: AppColor.backgroundColor,
                        radius: 34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Phone Number Field
                CustomTextfield(
                  () {},
                  icon: AppImageAsset.phoneIcon,
                  hinttext: "Phone Number",
                  isvalid: (val) =>
                      val!.isEmpty ? "Phone number is required" : null,
                  mycontroller: controller.phone,
                  bordercolor: AppColor.backgroundColor,
                  radius: 34,
                ),
                const SizedBox(height: 20),

                // Role and Target Audience Selection
                const ChooseRole(),
                const SizedBox(height: 20),
                const ChooseTargetAudiance(),
                const SizedBox(height: 20),

                // Email and Password Fields
                CustomTextfield(
                  () {},
                  icon: AppImageAsset.emailIcon,
                  hinttext: "signupHintEmail".tr,
                  isvalid: (val) => null,
                  mycontroller: controller.email,
                  bordercolor: AppColor.backgroundColor,
                  radius: 34,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  () {},
                  icon: AppImageAsset.passIcon,
                  hinttext: "signupHintPass".tr,
                  isvalid: (val) => null,
                  mycontroller: controller.password,
                  bordercolor: AppColor.backgroundColor,
                  radius: 34,
                ),
                const SizedBox(height: 10),

                // Client Document Section
                if (controller.role != null) const ClientDocumentText(),
                if (controller.role != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      controller.role == "provider"
                          ? "Soumettez votre registre commerce pour verification"
                          : "Soumettez votre permis de conduire ou votre pièce d'identité pour les clients uniquement",
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColor.secondaryColor,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Document Upload Section
                if (controller.role != null)
                  ClientDocumentSection(
                    onFilesSelected: (files) {
                      controller.documents = files;
                    },
                  ),
                const SizedBox(height: 20),

                // Signup Button
                SignupBtn(
                  onPressed: () => controller.signup(),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
