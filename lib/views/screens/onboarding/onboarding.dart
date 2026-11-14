import 'package:hasad/controller/onboarding/onboarding_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the OnboardingController
    final OnboardingControllerImp controller =
        Get.put(OnboardingControllerImp(), permanent: false);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Background design (if needed)
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(AppImageAsset.yellowspot),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 12, right: 10),
              child: Column(
                children: [
                  Expanded(
                      flex: 5, child: OnboardingSlider(controller: controller)),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        DotsController(controller: controller),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OnboardingSkipBtn(controller: controller),
                              OnboardingNextBtn(controller: controller),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingSlider extends StatelessWidget {
  final OnboardingControllerImp controller;
  const OnboardingSlider({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: onboardingList.length,
      controller: controller.pagecontrol,
      onPageChanged: controller.onpagechanged,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Headline1(title: onboardingList[index].title!),
            const SizedBox(height: 20),
            OnboardingImage(image: onboardingList[index].image!),
            const SizedBox(height: 20),
            OnboardingDetails(details: onboardingList[index].body!),
          ],
        );
      },
    );
  }
}

class OnboardingSkipBtn extends StatelessWidget {
  final OnboardingControllerImp controller;
  const OnboardingSkipBtn({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        await controller.completeOnboarding();
      },
      child: Text(
        controller.currentpage == onboardingList.length - 1 ? "" : "Skip",
        style: const TextStyle(
          fontFamily: "Moderna",
          color: AppColor.primaryColor,
          fontSize: 16,
        ),
      ),
    );
  }
}

class OnboardingNextBtn extends StatelessWidget {
  final OnboardingControllerImp controller;
  const OnboardingNextBtn({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        if (controller.currentpage == onboardingList.length - 1) {
          // Complete onboarding on the last page
          await controller.completeOnboarding();
        } else {
          // Navigate to the next page
          controller.pagecontrol.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            controller.currentpage == onboardingList.length - 1
                ? "Get Started"
                : "Next",
            style: const TextStyle(
              fontFamily: "Moderna",
              color: AppColor.primaryColor,
              fontSize: 16,
            ),
          ),
          const Icon(
            Icons.arrow_right_alt,
            color: AppColor.primaryColor,
            size: 30,
          ),
        ],
      ),
    );
  }
}

class OnboardingImage extends StatelessWidget {
  final String image;
  const OnboardingImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.28,
      width: Get.width,
      child: Image.asset(
        image,
        fit: BoxFit.contain,
      ),
    );
  }
}

class OnboardingDetails extends StatelessWidget {
  final Map<int, String> details;
  const OnboardingDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, right: 10, left: 12),
      height: Get.height * 0.28,
      child: ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, index) {
          final key = details.keys.elementAt(index);
          final value = details[key]!;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Icon(
                  Icons.circle,
                  size: 5,
                  color: AppColor.primaryColor,
                ),
              ),
              Expanded(
                child: Text(
                  value.tr,
                  style: const TextStyle(
                    fontFamily: "Mochiy Pop One",
                    color: AppColor.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DotsController extends StatelessWidget {
  final OnboardingControllerImp controller;
  const DotsController({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingList.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            width: controller.currentpage == index ? 30 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: controller.currentpage == index
                  ? AppColor.primaryColor
                  : AppColor.secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class Headline1 extends StatelessWidget {
  final String title;
  const Headline1({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.tr,
      style: const TextStyle(
        fontFamily: "Moderna",
        color: AppColor.primaryColor,
        fontSize: 30,
      ),
    );
  }
}

// class DotsController extends StatelessWidget {
//   const DotsController({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<OnboardingControllerImp>(
//         builder: (controller) => Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ...List.generate(
//                     onboardingList.length,
//                     (index) => Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 5),
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 500),
//                             curve: Curves.fastOutSlowIn,
//                             width: controller.currentpage == index ? 30 : 10,
//                             height: 10,
//                             decoration: BoxDecoration(
//                                 color: controller.currentpage == index
//                                     ? AppColor.primaryColor
//                                     : AppColor.secondaryColor,
//                                 borderRadius: BorderRadius.circular(10)),
//                           ),
//                         ))
//               ],
//             ));
//   }
// }
class OnboardingControllerImp extends GetxController {
  final PageController pagecontrol = PageController();
  int currentpage = 0;

  void onpagechanged(int pageNo) {
    currentpage = pageNo;
    update();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("skip", "1"); // Mark onboarding as complete
    Get.offAllNamed(AppRoutesNames.login); // Navigate to login or homepage
  }

  @override
  void onClose() {
    pagecontrol.dispose();
    super.onClose();
  }
}
