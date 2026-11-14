import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String number, title;
  const CustomTitle({
    super.key,
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: AppColor.backgroundColor,
              child: Text(
                number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColor.primaryColor,
                    fontSize: 22),
              ),
            ),
          ),
          Expanded(
              flex: 7,
              child: Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              )),
        ],
      ),
    );
  }
}
