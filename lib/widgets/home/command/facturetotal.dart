import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class FactureTotal extends StatelessWidget {
//   const FactureTotal({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Expanded(child: Spacer()),
//         Expanded(
//             flex: 4,
//             child: Text(
//               "${"commandTotaltext".tr} : 180451,25 DZD",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//               textAlign: TextAlign.right,
//             )),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FactureTotal extends StatelessWidget {
  final String totalPrice;

  const FactureTotal({
    Key? key,
    required this.totalPrice, // Accept total price as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Spacer()),
        Expanded(
          flex: 4,
          child: Text(
            "${"commandTotaltext".tr} : $totalPrice DZD", // Display dynamic total price
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
