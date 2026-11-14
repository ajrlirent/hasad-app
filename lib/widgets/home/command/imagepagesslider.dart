// import 'package:hasad/controller/command/command_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ImagePagesSlider extends GetView<CommandControllerImp> {
//   final List data;
//   const ImagePagesSlider({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//         controller: controller.pagecontrol,
//         onPageChanged: (index) => controller.changepage(index),
//         itemCount: data.length,
//         itemBuilder: (context, index) => Image.asset(data[index]));
//   }
// }
import 'package:hasad/controller/command/command_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class ImagePagesSlider extends GetView<CommandControllerImp> {
  final List data;
  const ImagePagesSlider({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pagecontrol,
      onPageChanged: (index) => controller.changepage(index),
      itemCount: data.length,
      itemBuilder: (context, index) {
        // Get the image path from the API response
        String imageUrl = data[index].startsWith('http')
            ? data[index]
            : '${ApiLinkNames.server}/${data[index]}';

        // Replace 'public/' with 'storage/' in the URL
        imageUrl = imageUrl.replaceFirst('public/', 'storage/');

        // Log the constructed image URL
        print('Image URL: $imageUrl');

        return AppNetworkImage(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $imageUrl');
            return Image.asset('assets/images/no_image_available.png');
          },
        );
      },
    );
  }
}
