import 'package:hasad/controller/auth/verifyotp_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/widgets/home/backbtnlogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Verifyotp extends GetView<VerifyotpControllerImp> {
  const Verifyotp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => VerifyotpControllerImp());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Backbtnlogo(),
                ],
              ),
              const Customtitle(titre: "Vérification OTP"),
              SmallDescSection(
                desc:
                    "Entrez le code de vérification que nous vous avons envoyez: ${controller.phoneNo}",
              ),
              const SizedBox(
                height: 60,
              ),
              const OtpInput(),
              const SizedBox(height: 60),
              const ResendSection(),
              const SizedBox(
                height: 30,
              ),
              const CustomTimer(),
              const SizedBox(
                height: 60,
              ),
              const continueBtn()
            ],
          ),
        ),
      ),
    );
  }
}

class continueBtn extends StatelessWidget {
  const continueBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.offAllNamed(AppRoutesNames.signup);
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 95),
          backgroundColor: AppColor.backgroundColor),
      child: const Text(
        "Continuer",
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColor.primaryColor),
      ),
    );
  }
}

class CustomTimer extends GetView<VerifyotpControllerImp> {
  const CustomTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppImageAsset.clockIcon),
        Obx(() => Text(controller.time.value))
      ],
    );
  }
}

class Customtitle extends StatelessWidget {
  final double space;
  final String titre;
  const Customtitle({
    super.key,
    this.space = 0,
    required this.titre,
  });

  @override
  Widget build(BuildContext context) {
    return Text(titre,
        style: TextStyle(
          letterSpacing: space,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ));
  }
}

class OtpInput extends GetView<VerifyotpControllerImp> {
  const OtpInput({super.key});

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      autoFocus: true,
      focusedBorderColor: AppColor.backgroundColor,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
      numberOfFields: 4,
      borderRadius: BorderRadius.circular(360),
      fieldWidth: 60,
      showFieldAsBox: true,
      onSubmit: (String verificationCode) {
        controller.verifyotp(verificationCode);
      },
    );
  }
}

class ResendSection extends GetView<VerifyotpControllerImp> {
  const ResendSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SmallDescSection(desc: "Vous n'avez pas recu le code ?"),
        InkWell(
          onTap: () {
            controller.resendotp();
          },
          child: const Text(
            "Renvoyer",
            style: TextStyle(color: AppColor.backgroundColor, fontSize: 15),
          ),
        )
      ],
    );
  }
}

class SmallDescSection extends StatelessWidget {
  final String desc;
  const SmallDescSection({super.key, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Text(
      desc,
      style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColor.secondaryColor,
          fontSize: 15),
    );
  }
}
