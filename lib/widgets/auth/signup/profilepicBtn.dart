import 'dart:io';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureBtn extends StatelessWidget {
  final Function(File) onFileSelected;

  const ProfilePictureBtn({
    required this.onFileSelected,
    super.key,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Pick an image from gallery or camera
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      onFileSelected(imageFile); // Pass the selected file to the callback
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 35,
      splashColor: const Color.fromARGB(69, 250, 136, 23),
      onTap: _pickImage, // Trigger image picker on tap
      child: ClipRRect(
        child: CircleAvatar(
          radius: 45,
          backgroundColor: AppColor.backgroundColor,
          child: SvgPicture.asset(AppImageAsset.addIcon),
        ),
      ),
    );
  }
}
