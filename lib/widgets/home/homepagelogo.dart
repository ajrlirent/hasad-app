import 'package:hasad/core/constants/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomepageLogo extends StatelessWidget {
  final double margin;
  const HomepageLogo({
    this.margin = 280,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: margin),
        child: Image.asset(AppImageAsset.discoverlogo));
  }
}
