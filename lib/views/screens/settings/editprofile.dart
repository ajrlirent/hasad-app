// import 'package:hasad/controller/settings/editprofile_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/core/functions/validinput.dart';

// import 'package:hasad/widgets/home/add/descriptionsection.dart';
// import 'package:hasad/widgets/home/homepagelogo.dart';
// import 'package:hasad/widgets/home/providerhome/provider_widgets.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Editprofile extends GetView<EditprofileControllerImp> {
//   const Editprofile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => EditprofileControllerImp());
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: Get.width * .13),
//           height: Get.height,
//           width: Get.width,
//           decoration: BoxDecoration(
//               color: Get.isDarkMode
//                   ? AppColor.backgroundColorDark
//                   : AppColor.primaryColor),
//           child: Form(
//             child: ListView(
//               children: [
//                 const HomepageLogo(),
//                 const ReviewAvatar(),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 CustomTextfield(() {},
//                     icon: AppImageAsset.person,
//                     hinttext: "Username",
//                     isvalid: (val) => validInput(val!, 4, 20, "username"),
//                     mycontroller: controller.username),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextfield(() {},
//                     icon: AppImageAsset.emailIcon,
//                     hinttext: "Email",
//                     isvalid: (val) => validInput(val!, 8, 20, "email"),
//                     mycontroller: controller.email),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextfield(() {},
//                     icon: AppImageAsset.phoneIcon,
//                     hinttext: "Phone number",
//                     isvalid: (val) => validInput(val!, 4, 20, "phone"),
//                     mycontroller: controller.phone),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 CustomTextfield(() {},
//                     icon: AppImageAsset.passIcon,
//                     hinttext: "Password",
//                     isvalid: (val) => validInput(val!, 4, 20, "password"),
//                     mycontroller: controller.password),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         foregroundColor: AppColor.primaryColor,
//                         backgroundColor: AppColor.backgroundColor,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 6, horizontal: 16)),
//                     onPressed: () {},
//                     child: const Text("Update",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600))),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:hasad/controller/settings/editprofile_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/functions/validinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Editprofile extends GetView<EditprofileControllerImp> {
  const Editprofile({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => EditprofileControllerImp());

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width * .13),
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? AppColor.backgroundColorDark
                : AppColor.primaryColor,
          ),
          child: Form(
            key: controller.myFormKey,
            child: ListView(
              children: [
                const SizedBox(height: 30),
                CustomTextfield(
                  onSubmit: () {},
                  icon: "assets/icons/person.svg",
                  hinttext: "Username",
                  isvalid: (val) => validInput(val!, 4, 20, "username"),
                  mycontroller: controller.username,
                ),
                const SizedBox(height: 15),
                CustomTextfield(
                  onSubmit: () {},
                  icon: "assets/icons/email.svg",
                  hinttext: "Email",
                  isvalid: (val) => validInput(val!, 8, 30, "email"),
                  mycontroller: controller.email,
                ),
                const SizedBox(height: 15),
                CustomTextfield(
                  onSubmit: () {},
                  icon: "assets/icons/phone.svg",
                  hinttext: "Phone number",
                  isvalid: (val) => validInput(val!, 10, 15, "phone"),
                  mycontroller: controller.phone,
                ),
                const SizedBox(height: 15),
                CustomTextfield(
                  onSubmit: () {},
                  icon: "assets/icons/password.svg",
                  hinttext: "Password",
                  isvalid: (val) => validInput(val!, 4, 20, "password"),
                  mycontroller: controller.password,
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColor.primaryColor,
                    backgroundColor: AppColor.backgroundColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  ),
                  onPressed: () async {
                    await controller.updateProfile();
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextfield extends StatelessWidget {
  final TextEditingController mycontroller;
  final Function() onSubmit;
  final String hinttext;
  final String? Function(String?) isvalid;
  final String icon;
  final bool obscureText;

  const CustomTextfield({
    super.key,
    required this.mycontroller,
    required this.onSubmit,
    required this.hinttext,
    required this.isvalid,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: mycontroller,
      obscureText: obscureText,
      validator: isvalid,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            icon,
            height: 20,
            width: 20,
          ),
        ),
        hintText: hinttext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
