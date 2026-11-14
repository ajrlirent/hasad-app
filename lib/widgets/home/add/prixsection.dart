// import 'package:flutter/material.dart';
import 'package:hasad/widgets/home/add/descriptionsection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrixSection extends StatelessWidget {
  final TextEditingController prixPerDayController = TextEditingController();
  final TextEditingController prixPerMonthController = TextEditingController();
  final TextEditingController offerTypeController = TextEditingController();
  final TextEditingController transportPriceController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextfield(() {}, icon: "", hinttext: "Prix par jour",
            isvalid: (v) {
          return null;
        }, mycontroller: prixPerDayController),
        CustomTextfield(() {}, icon: "", hinttext: "Prix par mois",
            isvalid: (v) {
          return null;
        }, mycontroller: prixPerMonthController),
        CustomTextfield(() {}, icon: "", hinttext: "Type de offre",
            isvalid: (v) {
          return null;
        }, mycontroller: offerTypeController),
        CustomTextfield(() {}, icon: "", hinttext: "Prix de transport",
            isvalid: (v) {
          return null;
        }, mycontroller: transportPriceController),
      ],
    );
  }
}
