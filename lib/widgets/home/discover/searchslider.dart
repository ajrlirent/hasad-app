// import 'package:hasad/controller/home/discover_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SearchSlider extends GetView<DiscoverControllerImp> {
//   const SearchSlider({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 23),
//       child: Row(
//         children: [
//           const Expanded(
//             flex: 1,
//             child: Text(
//               "20KM",
//               style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0),
//             ),
//           ),
//           Expanded(
//               flex: 4,
//               child: GetBuilder<DiscoverControllerImp>(
//                 builder: (control) => Slider(
//                   value: controller.slidervalue.value.toDouble(),
//                   onChanged: (val) {
//                     controller.changeSearchRadius(val.toInt());
//                   },
//                   activeColor: AppColor.backgroundColor,
//                   inactiveColor: AppColor.backgroundColor,
//                   thumbColor: AppColor.primaryColor,
//                   max: 2000,
//                   min: 20,
//                 ),
//               )),
//           const Expanded(
//             flex: 1,
//             child: Text(
//               "2000KM",
//               style:
//                   TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.3),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
