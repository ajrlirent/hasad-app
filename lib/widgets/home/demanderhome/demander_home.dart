// class DemanderHomeEmpty extends StatelessWidget {
//   const DemanderHomeEmpty({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: HomepageLogo(),
//         ),
//         SizedBox(
//           height: Get.height * .2,
//         ),
//         const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text(
//             "Vous n'avez pas commandez d'équipements, ajoutez le vôtre maintenant",
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
//           ),
//         ),
//         Image.asset(AppImageAsset.providerhomeEmpty),
//       ],
//     );
//   }
// }

// class DemanderHomeNotEmpty extends StatelessWidget {
//   const DemanderHomeNotEmpty({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: const [
//         HomepageLogo(),
//         SizedBox(
//           height: 50,
//         ),
//         DemanderItemStatusCard(
//           image: AppImageAsset.pleteuse,
//           title: "JCB EXCVATOR SE 550",
//           type: "Individuel",
//           location: "Alger, Khraicia",
//           price: "261200,00 DZD",
//           status: "En travaille",
//           bgcolor: AppColor.activeservicecolor,
//           remainingdays: "7 Jours de travail",
//         ),
//         DemanderItemStatusCard(
//           image: AppImageAsset.pleteuse,
//           title: "JCB EXCVATOR SE 550",
//           type: "Individuel",
//           location: "Alger, Khraicia",
//           price: "261200,00 DZD",
//           status: "Hors Service",
//           bgcolor: AppColor.horsservicecolor,
//           remainingdays: "",
//         ),
//         DemanderItemStatusCard(
//           image: AppImageAsset.pleteuse,
//           title: "JCB EXCVATOR SE 550",
//           type: "Individuel",
//           location: "Alger, Khraicia",
//           price: "261200,00 DZD",
//           status: "Complète",
//           bgcolor: AppColor.backgroundColor,
//           remainingdays: "7 Jours de travail",
//         ),
//       ],
//     );
//   }
// }

// class DemanderItemStatusCard extends StatelessWidget {
//   final String image, title, type, price, location, status, remainingdays;
//   final Color bgcolor;

//   const DemanderItemStatusCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.type,
//     required this.price,
//     required this.status,
//     required this.bgcolor,
//     required this.remainingdays,
//     required this.location,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: Get.context!.width * .02),
//       height: Get.height * .3,
//       width: Get.width,
//       child: Card(
//         elevation: 10,
//         margin: EdgeInsets.symmetric(vertical: Get.context!.height * .02),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                     flex: 1,
//                     child: SizedBox(
//                         height: 150,
//                         child: Image.asset(
//                           image,
//                           fit: BoxFit.contain,
//                         ))),
//                 Expanded(
//                     flex: 1,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: const TextStyle(
//                               fontSize: 17, fontWeight: FontWeight.w700),
//                         ),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.person,
//                               color: AppColor.secondaryColor,
//                             ),
//                             Text(
//                               type,
//                               style: const TextStyle(
//                                   fontSize: 12, color: AppColor.secondaryColor),
//                             )
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.location_on,
//                               color: AppColor.secondaryColor,
//                             ),
//                             Text(
//                               location,
//                               style: const TextStyle(
//                                   fontSize: 12, color: AppColor.secondaryColor),
//                             )
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.monetization_on,
//                               color: AppColor.backgroundColor,
//                             ),
//                             Text(
//                               "$price DZD",
//                               style: const TextStyle(
//                                   fontSize: 12, color: AppColor.secondaryColor),
//                             )
//                           ],
//                         ),
//                         InkWell(
//                           onTap: () =>
//                               Get.toNamed(AppRoutesNames.commandDetails),
//                           child: const Text(
//                             "Voir plus",
//                             style: TextStyle(fontSize: 12),
//                           ),
//                         ),
//                       ],
//                     ))
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     remainingdays,
//                     style: const TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.w400),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         elevation: 8,
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 6, horizontal: 25),
//                         backgroundColor: bgcolor),
//                     onPressed: () {
//                       reviewRenter(context);
//                     },
//                     child: Text(
//                       status,
//                       style: const TextStyle(
//                           fontSize: 18,
//                           color: AppColor.primaryColor,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// Future<dynamic> reviewRenter(BuildContext context) {
//   return showModalBottomSheet(
//       isScrollControlled: true,
//       isDismissible: true,
//       backgroundColor: Colors.transparent,
//       barrierColor: const Color.fromARGB(150, 0, 0, 0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       context: context,
//       builder: (context) => const FractionallySizedBox(
//             heightFactor: .75,
//             child: Stack(
//               children: [ReviewBody(), ReviewAvatar()],
//             ),
//           ));
// }
