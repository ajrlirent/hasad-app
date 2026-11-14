import 'package:hasad/controller/demande/demande_controller.dart';
import 'package:hasad/controller/home/demanderhome_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/widgets/home/add/ajouteattachmenttext.dart';
import 'package:hasad/widgets/home/add/attachmentbottomsheet.dart';
import 'package:hasad/widgets/home/command/actionbtn.dart';
import 'package:hasad/widgets/home/homepagelogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riff_switch/riff_switch.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class ActionRow extends StatelessWidget {
  const ActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Actionbtn(
            bgcolor: AppColor.backgroundColor,
            action: "Commandez",
            onpressed: () => Get.offNamed(AppRoutesNames.demandeSearching),
          ),
          Actionbtn(
            bgcolor: AppColor.secondaryColor,
            action: "Annuler",
            onpressed: () {},
          ),
        ],
      ),
    );
  }
}

class AddPhotoDetails extends StatelessWidget {
  const AddPhotoDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(
              color: AppColor.backgroundColor, style: BorderStyle.solid)),
          shape: BoxShape.rectangle),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "demandedetailshint2".tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.secondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.backgroundColor,
                  foregroundColor: AppColor.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16)),
              onPressed: () {},
              child: Text(
                "providerhomeActionBtn".tr,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ))
        ],
      ),
    );
  }
}

class BesoinDemande extends StatelessWidget {
  const BesoinDemande({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: GetBuilder<DemandeControllerImp>(
        builder: (controller) => DropdownButton(
          iconEnabledColor: AppColor.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          borderRadius: BorderRadius.circular(20),
          value: controller.besoin,
          items: [
            DropdownMenuItem(
              value: "Par distance",
              child: Text("demandebesoinvalue1".tr),
            ),
            DropdownMenuItem(
              value: "Par jour",
              child: Text("demandebesoinvalue2".tr),
            ),
          ],
          onChanged: (val) => controller.setBesoin(val),
          hint: Text("demandebesoinhinttext".tr),
          isExpanded: true,
        ),
      ),
    );
  }
}

class Capacite extends StatelessWidget {
  const Capacite({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Text(
              "demandecapacitetext".tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11)),
                child: const Text(
                  "8",
                  style: TextStyle(
                      color: AppColor.secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ))
      ],
    );
  }
}

class DemanderItemStatusCard extends StatelessWidget {
  final String? imageUrl;
  final String brand;
  final String model;
  final String userType;
  final String region;
  final String totalPrice;
  final Color statusColor;
  final String statusText;

  const DemanderItemStatusCard({
    Key? key,
    required this.imageUrl,
    required this.brand,
    required this.model,
    required this.userType,
    required this.region,
    required this.totalPrice,
    required this.statusColor,
    required this.statusText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the constructImageUrl function to get the final image URL
    String? finalImageUrl = constructImageUrl(imageUrl);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            finalImageUrl != null
                ? AppNetworkImage(
                    finalImageUrl, // Use the constructed URL
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/demande/searching.png');
                    },
                  )
                : Image.asset(
                    'assets/images/demande/searching.png', // Fallback in case of a null URL
                    width: 100,
                    height: 100,
                  ),
            const SizedBox(width: 15),
            Expanded(
              // Use Expanded to prevent overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$brand $model",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                  const SizedBox(height: 5),
                  Text("User Type: $userType"),
                  Text("Region: $region"),
                  Text("Price: $totalPrice DZD"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String constructImageUrl(String? imagePath) {
  const String baseUrl = "${ApiLinkNames.server}/";
  if (imagePath == null || imagePath.isEmpty) {
    return 'assets/images/demande/searching.png'; // Fallback image
  }
  // Replace 'public' with 'storage' if present
  final modifiedPath = imagePath.replaceFirst("public", "storage");
  // Return full URL if it's a relative path
  return modifiedPath.startsWith('http')
      ? modifiedPath
      : '$baseUrl$modifiedPath';
}

class CustomCounter extends GetView<DemandeControllerImp> {
  const CustomCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColor.secondaryColor),
                    borderRadius: BorderRadius.circular(11)),
                elevation: 4,
                backgroundColor: Get.isDarkMode
                    ? AppColor.backgroundColorDark
                    : AppColor.primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 4)),
            onPressed: () => controller.substractQte(),
            icon: const Icon(
              Icons.remove,
              size: 12,
            )),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: GetBuilder<DemandeControllerImp>(
              builder: (controller) => Text(
                controller.qte.toString(),
                style: const TextStyle(
                    color: AppColor.secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        IconButton(
            style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColor.backgroundColor),
                    borderRadius: BorderRadius.circular(11)),
                elevation: 4,
                backgroundColor: Get.isDarkMode
                    ? AppColor.backgroundColorDark
                    : AppColor.primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 4)),
            onPressed: () => controller.addQte(),
            icon: const Icon(
              Icons.add,
              size: 12,
              color: AppColor.backgroundColor,
            )),
      ],
    );
  }
}

class CustomDuration extends GetView<DemandeControllerImp> {
  const CustomDuration({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColor.secondaryColor),
                    borderRadius: BorderRadius.circular(11)),
                elevation: 4,
                backgroundColor: Get.isDarkMode
                    ? AppColor.backgroundColorDark
                    : AppColor.primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 4)),
            onPressed: () => controller.substractDuration(),
            icon: const Icon(
              Icons.remove,
              size: 12,
            )),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: GetBuilder<DemandeControllerImp>(
              builder: (controller) => Text(
                controller.duree.toString(),
                style: const TextStyle(
                    color: AppColor.secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        IconButton(
            style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColor.backgroundColor),
                    borderRadius: BorderRadius.circular(11)),
                elevation: 4,
                backgroundColor: Get.isDarkMode
                    ? AppColor.backgroundColorDark
                    : AppColor.primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 4)),
            onPressed: () => controller.addDuration(),
            icon: const Icon(
              Icons.add,
              size: 12,
              color: AppColor.backgroundColor,
            )),
      ],
    );
  }
}

class DetailsBesoinSuplluments extends StatelessWidget {
  const DetailsBesoinSuplluments({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColor.backgroundColor),
              borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Get.isDarkMode
              ? AppColor.backgroundColorDark
              : AppColor.primaryColor,
          hintText: "demandedetailshint".tr,
          hintStyle: const TextStyle(fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
      maxLines: 5,
    );
  }
}

class Duree extends StatelessWidget {
  const Duree({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "demandedureetext".tr,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                    )),
                const Expanded(flex: 1, child: CustomDuration()),
              ],
            ),
            Text(
              "demandedureetext2".tr,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textColor),
            ),
            GetBuilder<DemandeControllerImp>(
              builder: (controller) => TextFormField(
                controller: controller.datepickercontroller,
                onTap: () {
                  controller.selectdate(context);
                },
                readOnly: true,
                decoration: InputDecoration(
                    fillColor: Get.isDarkMode
                        ? AppColor.backgroundColorDark
                        : AppColor.primaryColor,
                    hintText: "demandedureetext3".tr,
                    filled: true,
                    prefixIcon: const Icon(Icons.calendar_today),
                    enabledBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColor.backgroundColor),
                        borderRadius: BorderRadius.circular(11))),
              ),
            ),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("heure :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 7,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            iconEnabledColor: AppColor.backgroundColor,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            borderRadius: BorderRadius.circular(20),
                            items: [
                              ...List.generate(
                                12,
                                (index) => DropdownMenuItem(
                                  value: "${index + 1}",
                                  child: Text("${index + 1}"),
                                ),
                              )
                            ],
                            onChanged: (val) {},
                            hint: const Text(
                              "6",
                              style: TextStyle(fontSize: 16),
                            ),
                            isExpanded: true,
                          ),
                        ),
                      ),
                      const Flexible(
                          child: Text(
                        ":",
                        style: TextStyle(fontSize: 14),
                      )),
                      Flexible(
                        flex: 9,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            iconEnabledColor: AppColor.backgroundColor,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            borderRadius: BorderRadius.circular(20),
                            items: [
                              ...List.generate(
                                60,
                                (index) => DropdownMenuItem(
                                  value: "${index + 1}",
                                  child: Text("${index + 1}"),
                                ),
                              )
                            ],
                            onChanged: (val) {},
                            hint: const Text(
                              "30",
                              style: TextStyle(fontSize: 16),
                            ),
                            isExpanded: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              color: AppColor.backgroundColor,
            ),
            const AjouteAttachmentText(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      backgroundColor: AppColor.backgroundColor,
                      foregroundColor: AppColor.primaryColor),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const AttachmentBottomsheet();
                        });
                  },
                  child: const Text(
                    "Selectionner des attachements",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ),
            const Divider(
              color: AppColor.backgroundColor,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "demandetransporttext".tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        iconEnabledColor: AppColor.backgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        borderRadius: BorderRadius.circular(20),
                        items: [
                          DropdownMenuItem(
                            value: "Par vous",
                            child: Text("demandetransportvalue1".tr),
                          ),
                          DropdownMenuItem(
                            value: "Par nous",
                            child: Text("demandetransportvalue2".tr),
                          ),
                        ],
                        onChanged: (val) {},
                        hint: const Text("Par vous"),
                        isExpanded: true,
                      ),
                    ))
              ],
            )
          ],
        ));
  }
}

class Quantite extends StatelessWidget {
  const Quantite({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Text(
              "demandeqtetext".tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const Expanded(flex: 1, child: CustomCounter())
      ],
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

class ServiceSwitcher extends StatefulWidget {
  const ServiceSwitcher({super.key});

  @override
  _ServiceSwitcherState createState() => _ServiceSwitcherState();
}

class _ServiceSwitcherState extends State<ServiceSwitcher> {
  bool inservice = false; // Local state to track service status

  @override
  Widget build(BuildContext context) {
    return RiffSwitch(
      inactiveTrackColor:
          Get.isDarkMode ? AppColor.backgroundColorDark : AppColor.primaryColor,
      activeTrackColor:
          Get.isDarkMode ? AppColor.backgroundColorDark : AppColor.primaryColor,
      height: 40,
      width: 260,
      value: inservice,
      onChanged: (val) {
        setState(() {
          inservice = val; // Update local state
        });
      },
      type: RiffSwitchType.simple,
      borderColor:
          inservice ? AppColor.backgroundColor : const Color(0xff930000),
      activeColor: AppColor.backgroundColor,
      inactiveThumbColor: const Color(0xff930000),
      activeText: Text(
        "serviceswitcherOn".tr,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: AppColor.primaryColor,
        ),
      ),
      inactiveText: Text(
        "serviceswitcherOff".tr,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: AppColor.primaryColor,
        ),
      ),
    );
  }
}
