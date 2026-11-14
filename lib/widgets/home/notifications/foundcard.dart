import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoundCard extends StatelessWidget {
  final String? image, title, subtitle, type, price, location;
  const FoundCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 400,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: SizedBox(
                      height: 120,
                      child: Image.asset(
                        image!,
                        fit: BoxFit.contain,
                      ))),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                            fontSize: 14, color: AppColor.secondaryColor),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: AppColor.secondaryColor,
                          ),
                          Text(
                            type!,
                            style: const TextStyle(
                                fontSize: 12, color: AppColor.secondaryColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColor.secondaryColor,
                          ),
                          Text(
                            location!,
                            style: const TextStyle(
                                fontSize: 12, color: AppColor.secondaryColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            color: AppColor.backgroundColor,
                          ),
                          Text(
                            "$price DZD",
                            style: const TextStyle(
                                fontSize: 18, color: AppColor.backgroundColor),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutesNames.commandDetails),
                        child: const Text(
                          "Voir plus",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 25),
                      backgroundColor: AppColor.backgroundColor),
                  onPressed: () {
                    Get.offNamed(
                      AppRoutesNames.providerhome2,
                    );
                  },
                  child: const Text(
                    "Accept",
                    style: TextStyle(
                        fontSize: 22,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 25),
                      backgroundColor: AppColor.secondaryColor),
                  onPressed: () {},
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 22,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
