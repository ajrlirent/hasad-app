import 'dart:io';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClientDocumentSection extends StatelessWidget {
  final Function(List<File>) onFilesSelected;

  const ClientDocumentSection({
    required this.onFilesSelected,
    super.key,
  });

  Future<void> _pickFiles() async {
    // Use file picker to select multiple files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'], // Adjust extensions as needed
    );

    // Check if files were picked
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      onFilesSelected(files); // Pass selected files to callback
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 40,
      splashColor: const Color.fromARGB(118, 250, 136, 23),
      onTap: _pickFiles, // Call _pickFiles on tap
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 60),
        height: 130,
        width: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: AppColor.backgroundColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: SvgPicture.asset(
            AppImageAsset.addpicture,
          ),
        ),
      ),
    );
  }
}
