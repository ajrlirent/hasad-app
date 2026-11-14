import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SmallHeadline extends StatelessWidget {
  final String subtitle, icon;
  const SmallHeadline({
    super.key,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: SvgPicture.asset(icon),
          ),
          Expanded(
            flex: 9,
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: AppColor.secondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
  }
}