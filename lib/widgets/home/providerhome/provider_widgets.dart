import 'package:http/http.dart' as http;
import 'package:hasad/controller/home/providerhome_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/widgets/home/homepagelogo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:riff_switch/riff_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class AddEquipmentBtn extends StatelessWidget {
  final String prompt;
  final void Function()? onpressed;
  const AddEquipmentBtn({
    super.key,
    required this.prompt,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.black : Colors.white;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 3,
            backgroundColor: AppColor.backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12)),
        onPressed: onpressed,
        child: Text(
          prompt,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 23,
              color: AppColor.primaryColor),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            flex: 5,
            child: HomepageLogo(
              margin: 92,
            )),
        Expanded(flex: 4, child: ServiceSwitcher())
      ],
    );
  }
}

// class ItemStatusCard extends StatelessWidget {
//   final String image, title, subtitle, year, price, icon, status;
//   final Color bgcolor;
//   final bool
//       isNetworkImage; // Add parameter to indicate if it's a network image

//   const ItemStatusCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.year,
//     required this.price,
//     required this.icon,
//     required this.status,
//     required this.bgcolor,
//     this.isNetworkImage = false, // Default to false for asset images
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: Get.width * .05, vertical: Get.height * .01),
//       child: SizedBox(
//         height: Get.height * .26,
//         width: Get.width,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: SizedBox(
//                     height: 120,
//                     child: isNetworkImage
//                         ? AppNetworkImage(image,
//                             fit: BoxFit.contain) // Load from network
//                         : Image.asset(image,
//                             fit: BoxFit.contain), // Load from assets
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.w700),
//                       ),
//                       Text(
//                         "Markque: $subtitle",
//                         style: const TextStyle(
//                             fontSize: 12, color: AppColor.highlightColor),
//                       ),
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.date_range,
//                             color: AppColor.highlightColor,
//                             size: 16,
//                           ),
//                           Text(
//                             year,
//                             style: const TextStyle(
//                                 fontSize: 12, color: AppColor.highlightColor),
//                           )
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             Icons.monetization_on,
//                             color: AppColor.backgroundColor,
//                           ),
//                           Text(
//                             price,
//                             style: const TextStyle(
//                                 overflow: TextOverflow.ellipsis,
//                                 fontSize: 12,
//                                 color: AppColor.highlightColor),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: Get.width * .35, right: 9),
//               child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       alignment: Alignment.center,
//                       elevation: 5,
//                       backgroundColor: bgcolor),
//                   onPressed: () {
//                     statusChange(context);
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         status,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             color: AppColor.primaryColor,
//                             fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       SvgPicture.asset(icon)
//                     ],
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Future<dynamic> statusChange(BuildContext context) {
//     return showModalBottomSheet(
//         isScrollControlled: true,
//         isDismissible: true,
//         backgroundColor: Colors.transparent,
//         barrierColor: const Color.fromARGB(150, 0, 0, 0),
//         context: context,
//         builder: (context) => const FractionallySizedBox(
//               heightFactor: .75,
//               child: Stack(
//                 children: [
//                   // ReviewBody(),
//                   // ReviewAvatar(),
//                 ],
//               ),
//             ));
//   }
// }
class ItemStatusCard extends StatelessWidget {
  final String image, title, subtitle, year, price, icon, status, type;
  final int id; // Unique ID for each item
  final Color bgcolor;
  final bool isNetworkImage;
  final String? statusText; // Human-readable label for the button

  const ItemStatusCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.year,
    required this.price,
    required this.icon,
    required this.status,
    required this.type,
    required this.id,
    required this.bgcolor,
    this.isNetworkImage = false,
    this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    // Theme brightness, NOT platformBrightness: the app can run in light
    // mode while the phone system is in dark mode (which made the text
    // white-on-white). Theme.of() always matches what is actually rendered.
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.width * .05, vertical: Get.height * .01),
      child: SizedBox(
        height: Get.height * .26,
        width: Get.width,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 120,
                    child: isNetworkImage
                        ? AppNetworkImage(image, fit: BoxFit.contain)
                        : Image.asset(image, fit: BoxFit.contain),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "Marque: $subtitle",
                        style: TextStyle(fontSize: 12, color: textColor),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: textColor,
                            size: 16,
                          ),
                          Text(
                            year,
                            style: TextStyle(fontSize: 12, color: textColor),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: AppColor.backgroundColor,
                          ),
                          Text(
                            price,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12,
                                color: textColor),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: Get.width * .35, right: 9),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      backgroundColor: bgcolor,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () {
                    statusChange(context, id, type, status);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          statusText ?? status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      SvgPicture.asset(icon)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> statusChange(
      BuildContext context, int id, String type, String currentStatus) async {
    String nextStatus = currentStatus == "active"
        ? "out_of_service"
        : "active"; // Determine the next status
    String apiUrl;

    // Determine the API endpoint based on type
    if (type == "equipment") {
      apiUrl =
          "${ApiLinkNames.server}/api/edit-equipment-activity-status/$id?activity_status=$nextStatus";
    } else if (type == "vehicle") {
      apiUrl =
          "${ApiLinkNames.server}/api/edit-vehicle-activity-status/$id?activity_status=$nextStatus";
    } else if (type == "attachment") {
      apiUrl =
          "${ApiLinkNames.server}/api/edit-attachment-activity-status/$id?activity_status=$nextStatus";
    } else {
      print("Unknown type: $type");
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      print('Error: Token not found in SharedPreferences');
      return;
    }

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.MultipartRequest('PUT', Uri.parse(apiUrl));
      request.headers.addAll(headers);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Status updated successfully: $responseBody');

        // Update the local model and refresh the UI
        final controller = Get.find<ProviderhomeControllerImp>();
        controller.updateActivityStatus(id, type, nextStatus);
      } else {
        print('Failed to update status. Status Code: ${response.statusCode}');
        print('Response Body: $responseBody');
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }
}

class RatingScore extends StatelessWidget {
  const RatingScore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 10,
        ),
        Text("4.6",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColor.secondaryColor,
            )),
        Text("(100 avis)",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColor.secondaryColor,
            )),
      ],
    );
  }
}

// class ReviewAvatar extends StatelessWidget {
//   const ReviewAvatar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//         top: 20,
//         left: Get.width * .3,
//         child: const CircleAvatar(
//             radius: 80,
//             backgroundColor: AppColor.backgroundColor,
//             child: CircleAvatar(
//               radius: 77,
//               backgroundImage: AssetImage(AppImageAsset.entrepriseprofile),
//             )));
//   }
// }

//feadback
class ReviewBody extends StatelessWidget {
  const ReviewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.isDarkMode
              ? AppColor.backgroundColorDark
              : AppColor.primaryColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(34), topRight: Radius.circular(34))),
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.only(top: 100),
      width: Get.width,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Enterprise travaux public ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Text(
                "Société",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.secondaryColor),
              ),
              const Text(
                "ALGER,Boumerdes",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.secondaryColor,
                    decoration: TextDecoration.underline),
              ),
              const RatingScore(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                child: Text(
                  "Comment s'est passée votre expérience avec Enterprise travaux public ?",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Votre note globale",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.secondaryColor,
                    ),
                  )),
              RatingStars(
                value: 4,
                onValueChanged: (value) => null,
                starBuilder: (index, color) => Icon(
                  Icons.star,
                  color: color,
                ),
                starCount: 5,
                starSize: 20,
                starColor: Colors.yellow,
                starSpacing: 4,
                starOffColor: AppColor.secondaryColor,
                valueLabelVisibility: false,
                animationDuration: const Duration(milliseconds: 800),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: Get.width,
                  child: const Text(
                    "Ajouter un avis détaillé",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    textAlign: TextAlign.left,
                  )),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Get.isDarkMode
                        ? AppColor.backgroundColorDark
                        : AppColor.primaryColor,
                    hintText: "Écrivez votre avis",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20)),
                maxLines: 4,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.primaryColor,
                      backgroundColor: AppColor.backgroundColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16)),
                  onPressed: () {},
                  child: const Text("Soumettre",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }
}

// class ServiceSwitcher extends StatelessWidget {
//   const ServiceSwitcher({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProviderhomeControllerImp>(
//         builder: (controller) => RiffSwitch(
//               inactiveTrackColor: Get.isDarkMode
//                   ? AppColor.backgroundColorDark
//                   : AppColor.primaryColor,
//               activeTrackColor: Get.isDarkMode
//                   ? AppColor.backgroundColorDark
//                   : AppColor.primaryColor,
//               height: 40,
//               width: 260,
//               value: controller.inservice,
//               onChanged: (val) {
//                 controller.updateService(val);
//               },
//               type: RiffSwitchType.simple,
//               borderColor: controller.inservice
//                   ? AppColor.backgroundColor
//                   : const Color(0xff930000),
//               activeColor: AppColor.backgroundColor,
//               inactiveThumbColor: const Color(0xff930000),
//               activeText: Text(
//                 "serviceswitcherOn".tr,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 14,
//                     color: AppColor.primaryColor),
//               ),
//               inactiveText: Text(
//                 "serviceswitcherOff".tr,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 12,
//                     color: AppColor.primaryColor),
//               ),
//             ));
//   }
// }

class ServiceSwitcher extends StatelessWidget {
  const ServiceSwitcher({
    super.key,
  });

  Future<void> _changeActivityStatus(bool isActive) async {
    final String apiUrl = '${ApiLinkNames.server}/api/change-activity-status';
    final String activityStatus = isActive ? 'active' : 'out_of_service';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        print('Error: Token not found in SharedPreferences');
        return;
      }

      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$apiUrl?activity_status=$activityStatus'),
      );

      request.headers.addAll(headers);
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Success: $responseBody');

        // Trigger UI refresh
        final controller = Get.find<ProviderhomeControllerImp>();
        controller.fetchData();
      } else {
        print('Failed. Status Code: ${response.statusCode}');
        print('Response Body: $responseBody');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderhomeControllerImp>(
      builder: (controller) => RiffSwitch(
        inactiveTrackColor: Get.isDarkMode
            ? AppColor.backgroundColorDark
            : AppColor.primaryColor,
        activeTrackColor: Get.isDarkMode
            ? AppColor.backgroundColorDark
            : AppColor.primaryColor,
        height: 40,
        width: 260,
        value: controller.inservice,
        onChanged: (val) async {
          // Update local state
          controller.updateService(val);

          // Call the API to update the status and refresh the UI
          await _changeActivityStatus(val);
        },
        type: RiffSwitchType.simple,
        borderColor: controller.inservice
            ? AppColor.backgroundColor
            : const Color(0xff930000),
        activeColor: AppColor.backgroundColor,
        inactiveThumbColor: const Color(0xff930000),
        activeText: Text(
          "serviceswitcherOn".tr,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
              color: AppColor.primaryColor),
        ),
        inactiveText: Text(
          "serviceswitcherOff".tr,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: AppColor.primaryColor),
        ),
      ),
    );
  }
}
