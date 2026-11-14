import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/widgets/home/backbtnlogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:timeline_tile/timeline_tile.dart';

abstract class SearchingController extends GetxController {
  updateTimeline();
}

class SearchingControllerImp extends SearchingController
    with GetSingleTickerProviderStateMixin {
  @override
  void onReady() {
    super.onReady();
    // Simulating a delay and then navigating to the NotificationScreenDemander with the passed arguments.
    Future.delayed(const Duration(seconds: 5), () {
      var responseData = Get.arguments; // Use the passed response data
      Get.offNamed(AppRoutesNames.notificationsScreenDemander,
          arguments: responseData); // Pass the response data
    });
  }

  @override
  updateTimeline() {}
}

class SearchingDemande extends StatelessWidget {
  const SearchingDemande({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SearchingControllerImp(), permanent: false);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Backbtnlogo(), // Positioned on the left
                        const SizedBox(
                            width: 5), // Space between logo and next widget
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    Text(
                      "searchingHeadline1".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "Patience nous recherchons une cible",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Container(
                        height: screenHeight * 0.35,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TimelineTile(
                              alignment: TimelineAlign.start,
                              isFirst: true,
                              indicatorStyle: const IndicatorStyle(
                                indicator: Icon(
                                  Icons.check_circle,
                                  color: AppColor.backgroundColor,
                                ),
                                width: 20,
                              ),
                              endChild: Container(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.05),
                                constraints: BoxConstraints(
                                  minHeight: screenHeight * 0.1,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("searchingtimeline1".tr),
                                    Text(
                                      "searchingfinished".tr,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              afterLineStyle: const LineStyle(
                                  color: AppColor.backgroundColor,
                                  thickness: 2),
                            ),
                            TimelineTile(
                              alignment: TimelineAlign.start,
                              beforeLineStyle: const LineStyle(
                                color: AppColor.backgroundColor,
                                thickness: 2,
                              ),
                              afterLineStyle: const LineStyle(
                                  color: AppColor.secondaryColor, thickness: 2),
                              indicatorStyle: const IndicatorStyle(
                                indicator: Icon(
                                  Icons.access_time_filled,
                                  color: AppColor.backgroundColor,
                                ),
                                width: 20,
                              ),
                              endChild: Container(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.05),
                                constraints: BoxConstraints(
                                  minHeight: screenHeight * 0.1,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "searchingtimeline2".tr,
                                      style: const TextStyle(
                                          color: AppColor.backgroundColor),
                                    ),
                                    Text(
                                      "searchingpending".tr,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TimelineTile(
                              alignment: TimelineAlign.start,
                              isLast: true,
                              beforeLineStyle: const LineStyle(
                                color: AppColor.secondaryColor,
                                thickness: 2,
                              ),
                              indicatorStyle: const IndicatorStyle(
                                width: 20,
                                color: Colors.red,
                              ),
                              endChild: Container(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.05),
                                constraints: BoxConstraints(
                                  minHeight: screenHeight * 0.1,
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("......."),
                                    Text("......."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.6,
                      child: Image.asset(AppImageAsset.searchingimage),
                    ),
                    SizedBox(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.25,
                      child: Lottie.asset(
                        AppImageAsset.loading2,
                        repeat: true,
                        frameRate: FrameRate.max,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
