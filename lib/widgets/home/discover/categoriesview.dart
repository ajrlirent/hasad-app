// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:hasad/data/datasource/static/static.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CategoriesView extends StatelessWidget {
//   const CategoriesView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: Get.width,
//       height: Get.height * .55,
//       child: ListView.separated(
//         physics: const BouncingScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: typelist.length,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               Get.toNamed(AppRoutesNames.categorieItems,
//                   arguments: {"typeId": typelist[index].id!});
//             },
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(14),
//                   child: Image.asset(
//                     typelist[index].image!,
//                     scale: .8,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   typelist[index].name!.tr,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 17),
//                 )
//               ],
//             ),
//           );
//         },
//         separatorBuilder: (context, index) => const SizedBox(
//           width: 20,
//         ),
//       ),
//     );
//   }
// }import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height * .7, // Increased height
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: typelist.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.toNamed(AppRoutesNames.categorieItems,
                  arguments: {"typeId": typelist[index].id!});
            },
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    typelist[index].image!,
                    scale: .8,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  typelist[index].name!.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 20,
        ),
      ),
    );
  }
}
