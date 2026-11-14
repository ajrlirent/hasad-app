import 'package:flutter/material.dart';

class PlusDetails extends StatelessWidget {
  final String details;
  const PlusDetails({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 70,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Text(
          details,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ));
  }
}
