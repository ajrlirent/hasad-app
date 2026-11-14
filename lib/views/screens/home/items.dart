// import 'package:hasad/controller/home/items_controller.dart';
// import 'package:hasad/widgets/home/backbtnlogo.dart';
// import 'package:hasad/widgets/home/discover/mylocationinfo.dart';
// import 'package:hasad/widgets/home/items/caticonsview.dart';
// import 'package:hasad/widgets/home/items/itemsview.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CatItems extends GetView<ItemsControllerImp> {
//   const CatItems({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => ItemsControllerImp());
//     return Scaffold(
//       body: SafeArea(
//         child: SizedBox(
//           width: Get.width,
//           height: Get.height,
//           child: ListView(
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               const Backbtnlogo(),
//               const SizedBox(
//                 height: 5,
//               ),
//               const MyLocationtext(),
//               const LocationDropDownBtn(),
//               CatIconsView(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Text(
//                   "itemsHeadline1".tr,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w600, fontSize: 22),
//                 ),
//               ),
//               const ItemsView()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:hasad/controller/home/items_controller.dart';
import 'package:hasad/widgets/home/backbtnlogo.dart';
import 'package:hasad/widgets/home/discover/mylocationinfo.dart';
import 'package:hasad/widgets/home/items/caticonsview.dart';
import 'package:hasad/widgets/home/items/itemsview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatItems extends StatelessWidget {
  const CatItems({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ItemsControllerImp());
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: GetBuilder<ItemsControllerImp>(
            builder: (controller) {
              return ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Row(
                    children: [
                      const Backbtnlogo(), // Positioned on the left
                      const SizedBox(
                          width: 5), // Space between logo and next widget
                    ],
                  ),
                  const SizedBox(height: 5),
                  const MyLocationtext(),
                  const LocationDropDownBtn(),
                  CatIconsView(scrollController: scrollController),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "itemsHeadline1".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 22),
                    ),
                  ),
                  const ItemsView(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
