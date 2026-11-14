import 'package:hasad/core/constants/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            border: InputBorder.none,
            prefixIcon: Container(
              height: 10,
              width: 10,
              margin: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                AppImageAsset.searchIcon,
              ),
            ),
            hintText: 'searchtext'.tr),
        onEditingComplete: () {},
      ),
    );
  }
}
