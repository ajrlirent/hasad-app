import 'package:hasad/controller/add/addequipment_controller.dart';
import 'package:hasad/data/models/addentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class EntryItem extends GetView<AddequipmentControllerImp> {
  const EntryItem(this.entry, {super.key});
  final AddEntry entry;

  Widget buildTiles(AddEntry root) {
    if (root.children.isEmpty) {
      return ListTile(
        onTap: () => controller.chooseCat(root.title.tr), // Call chooseCat
        title: Text(root.title.tr),
      );
    }
    return InkWell(
      onTap: () {},
      child: ExpansionTile(
          key: PageStorageKey<AddEntry>(root),
          childrenPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          title: Text(root.title.tr),
          leading: SvgPicture.asset(root.image),
          children: root.children.map(buildTiles).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTiles(entry);
  }
}
