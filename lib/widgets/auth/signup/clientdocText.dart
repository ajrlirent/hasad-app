import 'package:hasad/controller/auth/signup_controller.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ClientDocumentText extends StatelessWidget {
  const ClientDocumentText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(AppImageAsset.addpicture),
          const SizedBox(
            width: 10,
          ),
          GetBuilder<SignupControllerImp>(
            builder: (controller) => Text(
          controller.role == "provider"
                      ? "Registre Commerce"
                      : "ID / Permis"
                  ,
              style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: "Sans-Serif",
                  fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
