import 'package:hasad/core/constants/color.dart';
import 'package:hasad/data/models/attachmentmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentBottomsheetCard extends StatelessWidget {
  final List<AttachmentModel> data;
  final int index;
  const AttachmentBottomsheetCard({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          Get.isDarkMode ? AppColor.backgroundColorDark : AppColor.primaryColor,
      elevation: 4,
      surfaceTintColor:
          Get.isDarkMode ? const Color.fromARGB(255, 127, 127, 127) : null,
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        child: Column(
          children: [
            Image.asset(
              data[index].attachmentimage!,
              scale: 1,
            ),
            const Spacer(),
            Text(
              data[index].attachmentname!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.fade),
            ),
          ],
        ),
      ),
    );
  }
}
