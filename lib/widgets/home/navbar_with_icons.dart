// import 'package:hasad/controller/home/homepage_controller.dart';
// import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class NavbarIcons {
//   NavbarIcons._();

//   static const _kFontFam = 'NavbarIcons';
//   static const String? _kFontPkg = null;

//   static const IconData discoverinactive =
//       IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
//   static const IconData homeinactive =
//       IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);
// }

// class Mynavbar extends GetView<HomeScreenControllerImp> {
//   const Mynavbar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HomeScreenControllerImp>(
//       init: Get.put(
//           HomeScreenControllerImp()), // Ensure controller is initialized
//       builder: (controller) => Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SafeArea(
//           child: Container(
//             height: 80, // Adjusted height if needed
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30.0),
//               color: AppColor.backgroundColor,
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(30.0),
//               child: BottomNavigationBar(
//                 elevation: 5,
//                 backgroundColor: AppColor.backgroundColor,
//                 currentIndex: controller.currentpage,
//                 selectedItemColor: AppColor.primaryColor,
//                 unselectedItemColor: Colors.grey,
//                 onTap: (val) {
//                   controller.pageNavigation(val); // Navigate to page
//                 },
//                 items: const [
//                   BottomNavigationBarItem(
//                     icon: Icon(NavbarIcons.homeinactive),
//                     label: '',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(NavbarIcons.discoverinactive),
//                     label: '',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.person),
//                     label: '',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:hasad/controller/home/homepage_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarIcons {
  NavbarIcons._();

  static const _kFontFam = 'NavbarIcons';
  static const String? _kFontPkg = null;

  static const IconData discoverinactive =
      IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData homeinactive =
      IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

class Mynavbar extends GetView<HomeScreenControllerImp> {
  const Mynavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenControllerImp>(
      init: Get.put(HomeScreenControllerImp()),
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 60.0),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 80, // Adjusted height for more space
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: AppColor.backgroundColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                elevation: 4,
                backgroundColor: AppColor.backgroundColor,
                currentIndex: controller.currentpage,
                selectedItemColor: AppColor.primaryColor,
                unselectedItemColor: Colors.grey,
                iconSize: 28, // Increased icon size
                showSelectedLabels: false, // Hide selected labels
                showUnselectedLabels: false, // Hide unselected labels
                onTap: (val) {
                  controller.pageNavigation(val);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Center(
                      // Centering the icon
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (controller.currentpage == 0)
                            Container(
                              width: 36, // Increased circle width
                              height: 36, // Increased circle height
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          Icon(
                            NavbarIcons.homeinactive,
                            color: controller.currentpage == 0
                                ? AppColor.backgroundColor
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Center(
                      // Centering the logo (mark only, no "HASAD" word)
                      child: Image.asset(
                        AppImageAsset.logoNav,
                        height: 26,
                        fit: BoxFit.contain,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Center(
                      // Centering the icon
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (controller.currentpage == 2)
                            Container(
                              width: 36, // Increased circle width
                              height: 36, // Increased circle height
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          Icon(
                            Icons.person,
                            color: controller.currentpage == 2
                                ? AppColor.backgroundColor
                                : Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
