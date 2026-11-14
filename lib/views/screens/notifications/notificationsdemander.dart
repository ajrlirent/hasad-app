import 'dart:async';
import 'dart:convert';

import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Renter screen shown right after a demand is submitted.
//
// The demand itself created no offers: every eligible provider was notified
// and may submit an offer manually. This screen polls the offers of the
// submitted demand so they appear as providers answer.
class NotificaitonScreenDemander extends StatefulWidget {
  const NotificaitonScreenDemander({super.key});

  @override
  State<NotificaitonScreenDemander> createState() =>
      _NotificaitonScreenDemanderState();
}

class _NotificaitonScreenDemanderState extends State<NotificaitonScreenDemander> {
  List<dynamic> offers = [];
  bool isLoading = true;
  bool _fetching = false;
  Timer? _timer;

  int? orderId;
  String categoryType = 'Unknown';

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments;
    final legacyOrders = arguments?['orders'];

    if (legacyOrders is List && legacyOrders.isNotEmpty) {
      // Legacy response shape (auto-generated offers): render them directly.
      offers = legacyOrders;
      isLoading = false;
    } else {
      orderId = arguments?['order_id'];
      categoryType = arguments?['categoryType'] ?? 'Unknown';

      if (orderId != null) {
        fetchOffers();
        // Offers arrive as providers submit them — keep the list fresh.
        _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
          fetchOffers();
        });
      } else {
        isLoading = false;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _matchesEndpoint {
    switch (categoryType) {
      case 'Construction Vehicle':
        return '${ApiLinkNames.server}/api/construction-vehicle-orders/$orderId/matches';
      case 'Transportation Vehicle':
        return '${ApiLinkNames.server}/api/transportation-vehicle-orders/$orderId/matches';
      case 'Construction Equipment':
        return '${ApiLinkNames.server}/api/construction-equipment-orders/$orderId/matches';
      case 'Construction Attachment':
        return '${ApiLinkNames.server}/api/construction-attachment-orders/$orderId/matches';
      default:
        return '';
    }
  }

  Future<void> fetchOffers() async {
    if (_fetching) return;
    _fetching = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Error: Token is null. User may not be logged in.');
        if (mounted) setState(() => isLoading = false);
        return;
      }

      var response = await http.get(
        Uri.parse(_matchesEndpoint),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedOffers = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            offers = fetchedOffers;
            isLoading = false;
          });
        }
      } else {
        print('Error fetching offers: ${response.statusCode}');
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      print('Failed to fetch offers: $e');
      if (mounted) setState(() => isLoading = false);
    } finally {
      _fetching = false;
    }
  }

  static String? constructImageUrl(String? url) {
    if (url == null) return null;
    if (url.startsWith('public/'))
      url = url.replaceFirst('public/', '/storage/');
    String baseUrl = '${ApiLinkNames.server}';
    return '$baseUrl$url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: ListView(
            children: [
              // Logo as Header
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () => Get.offAllNamed(AppRoutesNames.homepage),
                  child: Image.asset(AppImageAsset.logowithbackbtn,
                    width: 70, // Adjust size as desired
                    // height: 80,
                  ),
                ),
              ),
              // Divider
              // const Divider(thickness: 1, color: Colors.grey),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (offers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppImageAsset.notificationsEmpty,
                        width: Get.width * 0.9,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "No offers yet",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.backgroundColor),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Providers matching your demand have been notified.\nYour offers will appear here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    dynamic vehicleOrEquipment = {};
                    dynamic subCategory = {};
                    String photoUrl = '';

                    final order = offers[index];
                    if (order.containsKey('construction_vehicle')) {
                      vehicleOrEquipment = order['construction_vehicle'];
                      subCategory = vehicleOrEquipment['sub_category'];
                      photoUrl = constructImageUrl(subCategory['photo']) ?? '';
                    } else if (order.containsKey('transportation_vehicle')) {
                      vehicleOrEquipment = order['transportation_vehicle'];
                      subCategory = vehicleOrEquipment['sub_category'];
                      photoUrl = constructImageUrl(subCategory['photo']) ?? '';
                    } else if (order.containsKey('construction_attachment')) {
                      vehicleOrEquipment = order['construction_attachment'];
                      subCategory = vehicleOrEquipment['sub_category'];
                      photoUrl = constructImageUrl(subCategory['photo']) ?? '';
                    } else if (order.containsKey('construction_equipment')) {
                      vehicleOrEquipment = order['construction_equipment'];
                      subCategory = vehicleOrEquipment['sub_category'];
                      photoUrl = constructImageUrl(subCategory['photo']) ?? '';
                    }

                    final provider = order['provider'];
                    final String providerFirstName =
                        provider['first_name'] ?? 'Unknown';
                    final String providerUserType =
                        provider['user_type'] ?? 'Unknown';
                    final String city = vehicleOrEquipment['city'] ?? 'Unknown';
                    final String totalPrice = order['total_price'].toString();

                    return InkWell(
                      onTap: () {
                        String categoryType = getCategoryType(order);
                        Get.toNamed(
                          AppRoutesNames.commandDetails,
                          arguments: {
                            'order_id': order['id'],
                            'categoryType': categoryType,
                            'order': order,
                          },
                        );
                      },
                      child: FoundCard(
                        title: subCategory['label'] ?? 'No Label',
                        subtitle: providerFirstName,
                        type: providerUserType,
                        location: city,
                        price: totalPrice,
                        image: photoUrl,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String getCategoryType(dynamic order) {
    if (order.containsKey('construction_vehicle'))
      return 'Construction Vehicle';
    if (order.containsKey('transportation_vehicle'))
      return 'Transportation Vehicle';
    if (order.containsKey('construction_attachment'))
      return 'Construction Attachment';
    if (order.containsKey('construction_equipment'))
      return 'Construction Equipment';
    return 'Unknown';
  }
}

class FoundCard extends StatelessWidget {
  final String? image, title, subtitle, type, price, location;

  const FoundCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.price,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: EdgeInsets.symmetric(
          horizontal: Get.context!.width * .03,
          vertical: Get.context!.height * .02),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.context!.height * .02),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 150,
                    child: image != null && image!.isNotEmpty
                        ? AppNetworkImage(
                            image!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                  'assets/images/no_image_available.png');
                            },
                          )
                        : Image.asset('assets/images/no_image_available.png'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? 'No Title Available',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        subtitle ?? 'No Subtitle Available',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.grey),
                          Text(type ?? 'N/A',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          Text(location ?? 'N/A',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on,
                              color: Colors.green),
                          Text("${price ?? '0'} DZD",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 10), // Add space between image/details and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Accept action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.backgroundColor, // Button color
                  ),
                  child: const Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Cancel action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.backgroundColor, // Button color
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
