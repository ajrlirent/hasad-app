// // import 'package:hasad/controller/add/AttachmentSelectionScreen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:hasad/controller/add/addequipment_controller.dart';

// // // Helper function to create a dropdown select field
// // Widget buildSelectField(TextEditingController controller, String label) {
// //   return Padding(
// //     padding: const EdgeInsets.symmetric(horizontal: 20),
// //     child: DropdownButtonFormField<String>(
// //       value: controller.text.isEmpty ? null : controller.text,
// //       items: const [
// //         DropdownMenuItem(value: "Negotiable", child: Text("Negotiable")),
// //         DropdownMenuItem(value: "Fixed", child: Text("Fixed")),
// //       ],
// //       onChanged: (value) {
// //         controller.text = value!; // Update the controller with selected value
// //       },
// //       decoration: InputDecoration(
// //         labelText: label,
// //         border: const OutlineInputBorder(),
// //       ),
// //     ),
// //   );
// // }

// // // Validation for all fields
// // bool validateForm(AddequipmentControllerImp controller) {
// //   if (controller.marque.text.isEmpty ||
// //       controller.model.text.isEmpty ||
// //       controller.annee.text.isEmpty ||
// //       controller.prixperjour.text.isEmpty ||
// //       controller.prixpermois.text.isEmpty ||
// //       controller.offerType.text.isEmpty ||
// //       controller.transportPrice.text.isEmpty ||
// //       controller.operatorPrice.text.isEmpty ||
// //       controller.region.text.isEmpty ||
// //       controller.city.text.isEmpty ||
// //       controller.selectedAttachments.isEmpty || // Validate attachments
// //       controller.selectedPhotos.isEmpty || // Validate at least one photo
// //       controller.selectedDocuments.isEmpty) {
// //     // Validate at least one document
// //     return false;
// //   }
// //   return true;
// // }

// // // In your method that shows the attachment popup
// // Future<void> _showAttachmentPopup(BuildContext context) async {
// //   Map<String, Map<String, String>>? selectedAttachments =
// //       await showModalBottomSheet<Map<String, Map<String, String>>>(
// //     context: context,
// //     isScrollControlled: true,
// //     builder: (context) => Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           const SizedBox(height: 10),
// //           const Text(
// //             'Select Attachments',
// //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 10),
// //           Flexible(
// //             child: AttachmentSelectionPopup(
// //               selectedAttachments:
// //                   Get.find<AddequipmentControllerImp>().selectedAttachments,
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (Get.find<AddequipmentControllerImp>()
// //                   .selectedAttachments
// //                   .isNotEmpty) {
// //                 Navigator.pop(context,
// //                     Get.find<AddequipmentControllerImp>().selectedAttachments);
// //               } else {
// //                 Get.snackbar(
// //                   'No Selection',
// //                   'No attachments selected',
// //                   snackPosition: SnackPosition.BOTTOM,
// //                   backgroundColor: Colors.yellow,
// //                   colorText: Colors.black,
// //                 );
// //               }
// //             },
// //             child: const Text("Confirm Selection"),
// //           ),
// //         ],
// //       ),
// //     ),
// //   );

// //   // This part runs after the bottom sheet closes
// //   if (selectedAttachments != null && selectedAttachments.isNotEmpty) {
// //     Get.find<AddequipmentControllerImp>()
// //         .selectedAttachments
// //         .assignAll(selectedAttachments);
// //     Get.find<AddequipmentControllerImp>().update();
// //   } else {
// //     // Optional: handle the case where no attachments were selected
// //     print("No attachments were selected.");
// //   }
// // }
// import 'package:hasad/controller/add/AttachmentSelectionScreen.dart';
// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hasad/controller/add/addequipment_controller.dart';

// // Helper function to create a dropdown select field
// Widget buildSelectField(TextEditingController controller, String label) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20),
//     child: DropdownButtonFormField<String>(
//       value: controller.text.isEmpty ? null : controller.text,
//       items: const [
//         DropdownMenuItem(value: "Negotiable", child: Text("Negotiable")),
//         DropdownMenuItem(value: "Fixed", child: Text("Fixed")),
//       ],
//       onChanged: (value) {
//         controller.text = value!; // Update the controller with selected value
//       },
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//     ),
//   );
// }

// // Validation for missing fields
// String validateForm(AddequipmentControllerImp controller, String orderType) {
//   List<String> missingFields = [];

//   // Common fields validation
//   if (controller.marque.text.isEmpty) missingFields.add("Marque (Brand)");
//   if (controller.model.text.isEmpty) missingFields.add("Model");
//   if (controller.annee.text.isEmpty) missingFields.add("Année (Year)");
//   if (controller.prixperjour.text.isEmpty)
//     missingFields.add("Prix par jour (Price per Day)");
//   if (controller.prixpermois.text.isEmpty)
//     missingFields.add("Prix par mois (Price per Month)");
//   if (controller.offerType.text.isEmpty)
//     missingFields.add("Type d'offre (Offer Type)");
//   if (controller.transportPrice.text.isEmpty)
//     missingFields.add("Prix de transport (Transport Price)");
//   if (controller.region.text.isEmpty) missingFields.add("Région (Region)");
//   if (controller.city.text.isEmpty) missingFields.add("Ville (City)");
//   if (controller.phone.text.isEmpty)
//     missingFields.add("Numéro téléphone (Phone Number)");

//   // Specific validation for Vehicle
//   if (orderType == 'Vehicle') {
//     if (controller.operatorPrice.text.isEmpty) {
//       missingFields.add("Prix de l'opérateur (Operator Price)");
//     }

//     // Check attachments
//     if (controller.selectedAttachments.isEmpty) {
//       missingFields.add("Attachments");
//     }
//   }

//   // Specific validation for Attachment
//   if (orderType == 'Attachment') {
//     if (controller.subCategoryId?.isEmpty ?? true) {
//       missingFields.add("Sub Category ID");
//     }
//   }

//   // Validate at least one photo and document
//   if (controller.selectedPhotos.isEmpty) missingFields.add("Photos");
//   if (controller.selectedDocuments.isEmpty) missingFields.add("Documents");

//   // Return error message or empty string
//   if (missingFields.isNotEmpty) {
//     return "Please fill out the following fields:\n${missingFields.join('\n')}";
//   }
//   return ""; // No errors
// }

// // Show the attachment popup
// Future<void> _showAttachmentPopup(BuildContext context) async {
//   Map<String, Map<String, String>>? selectedAttachments =
//       await showModalBottomSheet<Map<String, Map<String, String>>>(
//     context: context,
//     isScrollControlled: true,
//     builder: (context) => Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const SizedBox(height: 10),
//           const Text(
//             'Select Attachments',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Flexible(
//             child: AttachmentSelectionPopup(
//               selectedAttachments:
//                   Get.find<AddequipmentControllerImp>().selectedAttachments,
//             ),
//           ),
//           const SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: () {
//               if (Get.find<AddequipmentControllerImp>()
//                   .selectedAttachments
//                   .isNotEmpty) {
//                 Navigator.pop(context,
//                     Get.find<AddequipmentControllerImp>().selectedAttachments);
//               } else {
//                 Get.snackbar(
//                   'No Selection',
//                   'No attachments selected',
//                   snackPosition: SnackPosition.BOTTOM,
//                   backgroundColor: Colors.yellow,
//                   colorText: Colors.black,
//                 );
//               }
//             },
//             child: const Text("Confirm Selection"),
//           ),
//         ],
//       ),
//     ),
//   );

//   // This part runs after the bottom sheet closes
//   if (selectedAttachments != null && selectedAttachments.isNotEmpty) {
//     Get.find<AddequipmentControllerImp>()
//         .selectedAttachments
//         .assignAll(selectedAttachments);
//     Get.find<AddequipmentControllerImp>().update();
//   } else {
//     // Optional: handle the case where no attachments were selected
//     print("No attachments were selected.");
//   }
// }

// // Submit button handler
// void handleSubmit(BuildContext context, String orderType) {
//   AddequipmentControllerImp controller = Get.find<AddequipmentControllerImp>();

//   String errorMessage = validateForm(controller, orderType);

//   if (errorMessage.isNotEmpty) {
//     Get.snackbar(
//       'Error',
//       errorMessage,
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   } else {
//     // If form is valid, proceed with submission
//     controller.add();
//     Get.offAllNamed(AppRoutesNames.homepage);
//   }
// }
