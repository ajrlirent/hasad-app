import 'package:hasad/data/models/attachmentmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Attachmentcard extends StatelessWidget {
  final List<AttachmentModel> data;
  final int index;
  const Attachmentcard({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor:
          Get.isDarkMode ? const Color.fromARGB(255, 127, 127, 127) : null,
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Column(
          children: [
            Image.asset(
              data[index].attachmentimage!,
              scale: 1,
            ),
            const Spacer(),
            Text(
              data[index].attachmentname!,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.fade),
            ),
          ],
        ),
      ),
    );
  }
}
