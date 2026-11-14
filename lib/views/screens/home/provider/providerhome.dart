import 'package:hasad/controller/home/providerhome_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/views/screens/home/provider/addequipmentbtn.dart';
import 'package:hasad/widgets/home/providerhome/provider_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

class Providerhome extends GetView<ProviderhomeControllerImp> {
  const Providerhome({super.key});

  // Define the base URL for relative paths
  static const String baseUrl = "${ApiLinkNames.server}/";

  @override
  Widget build(BuildContext context) {
    Get.put(ProviderhomeControllerImp()); // Ensure controller is initialized

    return RefreshIndicator(
      onRefresh: () => Future.delayed(const Duration(milliseconds: 200),
          () => controller.fetchData()), // Fetch new data on refresh
      child: Directionality(
        textDirection: TextDirection.ltr, // Force LTR layout
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutesNames.addequipment),
            backgroundColor: AppColor.backgroundColor,
            child: const Icon(
              Icons.add,
              size: 28,
              color: AppColor.primaryColor,
            ),
          ),
          body: SafeArea(
            child: Container(
                width: Get.width,
                height: Get.height,
                margin: EdgeInsets.symmetric(
                    vertical: 15, horizontal: Get.width * .02),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const CircularProgressIndicator(
                      color: AppColor.backgroundColor,
                    );
                  } else if (controller
                          .providerMachine.value.equipments!.isEmpty &&
                      controller.providerMachine.value.vehicles!.isEmpty &&
                      controller.providerMachine.value.attachments!.isEmpty) {
                    return const EmptyMachines();
                  } else {
                    return ListView(
                      children: [
                        const Header(),
                        const SizedBox(height: 50),
                        Text("equipments".tr,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        ...controller.providerMachine.value.equipments!
                            .map((equipment) {
                          final statusInfo =
                              mapStatus(equipment.activityStatus!);
                          final imagePath = _getFullImagePath(equipment.photo);
                          print(
                              "Equipment Image Path: $imagePath"); // Print image path

                          return ItemStatusCard(
                            image: imagePath,
                            title: equipment.model.toString(),
                            subtitle: equipment.brand.toString(),
                            year: equipment.year.toString(),
                            price: equipment.pricePerDay.toString(),
                            icon: statusInfo["icon"],
                            status: equipment.activityStatus!,
                            statusText: statusInfo["statusText"],
                            bgcolor: statusInfo["bgColor"],
                            isNetworkImage: imagePath
                                .startsWith('http'), // Check if network image
                            id: equipment.id!, // Pass the equipment ID
                            type: "equipment", // Specify the type
                          );
                        }),
                        Text("Vehicles".tr,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        ...controller.providerMachine.value.vehicles!
                            .map((vehicle) {
                          final statusInfo = mapStatus(vehicle.activityStatus!);
                          final imagePath = _getFullImagePath(vehicle.photo);
                          print(
                              "Vehicle Image Path: $imagePath"); // Print image path

                          return ItemStatusCard(
                            image: imagePath,
                            title: vehicle.model.toString(),
                            subtitle: vehicle.brand.toString(),
                            year: vehicle.year.toString(),
                            price: vehicle.pricePerDay.toString(),
                            icon: statusInfo["icon"],
                            status: vehicle.activityStatus!,
                            statusText: statusInfo["statusText"],
                            bgcolor: statusInfo["bgColor"],
                            isNetworkImage: imagePath
                                .startsWith('http'), // Check if network image
                            id: vehicle.id!, // Pass the vehicle ID
                            type: "vehicle", // Specify the type
                          );
                        }),
                        Text("Attachments".tr,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        ...controller.providerMachine.value.attachments!
                            .map((attachment) {
                          final statusInfo =
                              mapStatus(attachment.activityStatus ?? "Unknown");
                          final imagePath = _getFullImagePath(attachment.photo);
                          print(
                              "Attachment Image Path: $imagePath"); // Print image path

                          return ItemStatusCard(
                            image: imagePath,
                            title: attachment.model?.toString() ??
                                "Unknown", // Replace null with "Unknown"
                            subtitle: attachment.brand?.toString() ??
                                "Unknown", // Replace null with "Unknown"
                            year: attachment.year?.toString() ??
                                "Unknown", // Replace null with "Unknown"
                            price: attachment.pricePerDay?.toString() ??
                                "Unknown", // Replace null with "Unknown"
                            icon: statusInfo["icon"],
                            status: attachment.activityStatus!,
                            statusText: statusInfo["statusText"],
                            bgcolor: statusInfo["bgColor"],
                            isNetworkImage: imagePath
                                .startsWith('http'), // Check if network image
                            id: attachment.id!, // Pass the attachment ID
                            type: "attachment", // Specify the type
                          );
                        }),
                      ],
                    );
                  }
                })),
          ),
        ),
      ),
    );
  }

  // Helper function to ensure full image path and replace 'public' with 'storage'
  String _getFullImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return AppImageAsset.cat1; // Default image if none provided
    }
    // Replace 'public' with 'storage' if necessary and ensure full path
    final modifiedPath = imagePath.replaceFirst("public", "storage");
    return modifiedPath.startsWith('http')
        ? modifiedPath
        : '$baseUrl$modifiedPath';
  }
}

// Utility function to map activity status to appropriate attributes
Map<String, dynamic> mapStatus(String activityStatus) {
  if (activityStatus == "active") {
    return {
      "statusText": "statusActive".tr,
      "icon": AppImageAsset.activeIcon,
      "bgColor": AppColor.activeservicecolor
    };
  } else if (activityStatus == "in_service") {
    return {
      "statusText": "statusInService".tr,
      "icon": AppImageAsset.inServiceIcon,
      "bgColor": AppColor.backgroundColor
    };
  } else if (activityStatus == "out_of_service") {
    return {
      "statusText": "statusOutOfService".tr,
      "icon": AppImageAsset.horsserviceIcon,
      "bgColor": AppColor.horsservicecolor
    };
  } else {
    return {
      "statusText": "statusUnknown".tr,
      "icon": AppImageAsset.unknownIcon,
      "bgColor": Colors.grey
    };
  }
}

class EmptyMachines extends StatelessWidget {
  const EmptyMachines({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Header(),
        const SizedBox(height: 50),
        Text(
          "providerhomeHeadline1".tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        Image.asset(AppImageAsset.providerMachinesShowcase),
        Text(
          "providerhomeSmalltext1".tr,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ),
        AddEquipmentbtn(
          prompt: "providerhomeActionBtn".tr,
          onpressed: () => Get.toNamed(AppRoutesNames.addequipment),
        ),
      ],
    );
  }
}

// import 'package:hasad/controller/home/providerhome_controller.dart';
// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:hasad/widgets/home/providerhome/provider_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Providerhome extends StatelessWidget {
//   const Providerhome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(ProviderhomeControllerImp());
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: Get.width,
//           height: Get.height,
//           margin:
//               EdgeInsets.symmetric(vertical: 15, horizontal: Get.width * .02),
//           child: ListView(
//             children: [
//               const Header(),
//               const SizedBox(
//                 height: 50,
//               ),
//               Text(
//                 "providerhomeHeadline1".tr,
//                 textAlign: TextAlign.center,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
//               ),
//               Image.asset(AppImageAsset.providerhomeEmpty),
//               Text(
//                 "providerhomeSmalltext1".tr,
//                 textAlign: TextAlign.center,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
//               ),
//               AddEquipmentBtn(
//                 prompt: "providerhomeActionBtn".tr,
//                 onpressed: () => Get.toNamed(AppRoutesNames.addequipment),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
