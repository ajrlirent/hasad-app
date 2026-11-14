import 'package:hasad/core/constants/color.dart';
import 'package:hasad/data/datasource/static/static.dart';
import 'package:hasad/widgets/home/add/attachmentbottomsheetcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentBottomsheet extends StatelessWidget {
  const AttachmentBottomsheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .8,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Get.isDarkMode
            ? AppColor.backgroundColorDark
            : AppColor.primaryColor,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 10),
            height: 1,
            width: 60,
            decoration: BoxDecoration(
              color: AppColor.secondaryColor,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColor.primaryColor, width: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  child: Text(
                    "Ajoute attachments",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "Annuler",
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true, // Shrink the GridView to its content size
                physics:
                    const NeverScrollableScrollPhysics(), // Disable inner scroll
                itemCount: attachmentsBottomsheet.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Three cards in a row
                  crossAxisSpacing: 10, // Spacing between columns
                  mainAxisSpacing: 10, // Spacing between rows
                  childAspectRatio: 1, // Aspect ratio for width and height
                ),
                itemBuilder: (context, index) => AttachmentBottomsheetCard(
                  index: index,
                  data: attachmentsBottomsheet,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
