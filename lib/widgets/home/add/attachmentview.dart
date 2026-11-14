import 'package:hasad/data/datasource/static/static.dart';
import 'package:hasad/widgets/home/add/attachmentcard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachementView extends StatelessWidget {
  const AttachementView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .22,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: attachments.length,
          itemBuilder: (context, index) => Attachmentcard(
                data: attachments,
                index: index,
              )),
    );
  }
}
