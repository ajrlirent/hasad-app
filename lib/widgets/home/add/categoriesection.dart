// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/data/datasource/static/static.dart';
// import 'package:hasad/widgets/home/add/entryItem.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CategorieSection extends StatelessWidget {
//   const CategorieSection({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//           backgroundColor: AppColor.backgroundColor,
//           foregroundColor: AppColor.primaryColor,
//           padding: const EdgeInsets.symmetric(vertical: 10)),
//       child: const Text(
//         "Choisir la categorie",
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//       ),
//       onPressed: () => showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) => SizedBox(
//           height: Get.context!.height * .3,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: ListView.builder(
//                 itemCount: addEntry.length,
//                 itemBuilder: (context, index) => EntryItem(addEntry[index])),
//           ),
//         ),
//       ),
//     );
//   }
// }
