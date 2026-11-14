import 'package:hasad/controller/command/command_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagepageDotsController extends StatelessWidget {
  final List data;
  const ImagepageDotsController({
    super.key, required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommandControllerImp>(
        builder: (controller) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    data.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                            width: controller.currentpage == index ? 30 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: controller.currentpage == index
                                    ? AppColor.backgroundColor
                                    : AppColor.secondaryColor,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ))
              ],
            ));
  }
}
