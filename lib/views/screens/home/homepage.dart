import 'package:hasad/controller/home/homepage_controller.dart';
import 'package:hasad/data/datasource/static/static.dart';

import 'package:hasad/widgets/home/navbar_with_icons.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class Homepage extends StatelessWidget {
//   const Homepage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(HomeScreenControllerImp());
//     return Scaffold(
//       bottomNavigationBar: const Mynavbar(),
//       body: GetBuilder<HomeScreenControllerImp>(
//           builder: (controller) => PageTransitionSwitcher(
//                 duration: const Duration(milliseconds: 400),
//                 transitionBuilder:
//                     (child, primaryAnimation, secondaryAnimation) =>
//                         FadeThroughTransition(
//                   animation: primaryAnimation,
//                   secondaryAnimation: secondaryAnimation,
//                   child: child,
//                 ),
//                 child: pages.elementAt(controller.currentpage),
//               )),
//     );
//   }
// }
class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenControllerImp());
    return Scaffold(
      bottomNavigationBar: const Mynavbar(), // Ensure this is always here
      body: GetBuilder<HomeScreenControllerImp>(
        builder: (controller) => PageTransitionSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
              FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: pages.elementAt(
              controller.currentpage), // Ensure Providerhome is in pages
        ),
      ),
    );
  }
}
