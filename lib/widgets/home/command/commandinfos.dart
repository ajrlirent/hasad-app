import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommandInfos extends StatelessWidget {
  final String field, value;
  const CommandInfos({
    super.key,
    required this.field,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              field.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 7,
              child: Text(
                textAlign: TextAlign.right,
                value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ))
        ],
      ),
    );
  }
}
