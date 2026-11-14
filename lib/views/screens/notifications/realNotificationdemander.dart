import 'dart:async';

import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/widgets/home/command/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class RealNotificaitonScreenDemander extends StatefulWidget {
  const RealNotificaitonScreenDemander({super.key});

  @override
  _RealNotificaitonScreenDemanderState createState() =>
      _RealNotificaitonScreenDemanderState();
}

class _RealNotificaitonScreenDemanderState
    extends State<RealNotificaitonScreenDemander> {
  List<dynamic> orders = [];
  bool isLoading = true;
  Timer? _timer; // Timer for automatic refresh

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      fetchNotifications();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  // Fetch notifications and filter based on notification type
  Future<void> fetchNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Error: Token is null. Please login again.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var request = http.Request(
        'GET',
        Uri.parse('${ApiLinkNames.server}/api/notifications/'),
      );

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        List<dynamic> rawNotifications = json.decode(responseBody);

        // Expanded list of notification types for filtering
        rawNotifications = rawNotifications.where((notification) {
          return notification['type'] ==
                  "construction-vehicle-renting-request-accepted-by-provider" ||
              notification['type'] ==
                  "construction-attachment-renting-request-accepted-by-provider" ||
              notification['type'] ==
                  "construction-equipment-renting-request-accepted-by-provider" ||
              notification['type'] ==
                  "transportation-vehicle-renting-request-accepted-by-provider" ||
              notification['type'] ==
                  "construction-vehicle-renting-request-negotiated-by-provider" ||
              notification['type'] ==
                  "construction-attachment-renting-request-negotiated-by-provider" ||
              notification['type'] ==
                  "construction-equipment-renting-request-negotiated-by-provider" ||
              notification['type'] ==
                  "transportation-vehicle-renting-request-negotiated-by-provider" || // Correct type added
              // notification['type'] ==
              //     "transportation-vehicle-renting-request-accepted-by-renter" || // Correct type added
              // Offers submitted by providers for the renter's demands
              notification['type'] ==
                  "construction-vehicle-renting-request-provider-found" ||
              notification['type'] ==
                  "construction-attachment-renting-request-provider-found" ||
              notification['type'] ==
                  "construction-equipment-renting-request-provider-found" ||
              notification['type'] ==
                  "transportation-vehicle-renting-request-provider-found" ||
              notification['type'] ==
                  "construction-vehicle-order-match-settled" ||
              notification['type'] ==
                  "construction-attachment-order-match-settled" ||
              notification['type'] ==
                  "construction-equipment-order-match-settled" ||
              notification['type'] ==
                  "transportation-vehicle-order-match-settled";
        }).toList();

        // Fetch additional data for each notification based on type
        for (var notification in rawNotifications) {
          int? matchId = notification['data']['match_id'];
          int? successfulMatchId = notification['data']['successful_match_id'];

          if (matchId != null) {
            await fetchAdditionalData(matchId, notification, false);
          } else if (successfulMatchId != null) {
            await fetchAdditionalData(successfulMatchId, notification, true);
          }
        }

        setState(() {
          orders = rawNotifications;
          isLoading = false;
        });
      } else {
        print('Error: ${response.reasonPhrase}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error while making the request: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Determine which API endpoint to call based on the notification type
  Future<void> fetchAdditionalData(
      int id, dynamic notification, bool isSettled) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Error: Token is null. Please login again.');
        return;
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

// Determine the correct endpoint based on notification type
      String endpoint = '';
      String type = notification['type'];

      if (isSettled) {
        // Endpoints for settled orders
        if (type == "construction-vehicle-order-match-settled") {
          endpoint =
              '${ApiLinkNames.server}/api/successfully-rented-construction-vehicles/$id';
        } else if (type == "construction-attachment-order-match-settled") {
          endpoint =
              '${ApiLinkNames.server}/api/successfully-rented-construction-attachments/$id';
        } else if (type == "construction-equipment-order-match-settled") {
          endpoint =
              '${ApiLinkNames.server}/api/successfully-rented-construction-equipments/$id';
        } else if (type == "transportation-vehicle-order-match-settled") {
          endpoint =
              '${ApiLinkNames.server}/api/successfully-rented-transportation-vehicles/$id';
        }
      } else {
        // Endpoints for accepted and negotiated requests
        if (type ==
                "construction-vehicle-renting-request-accepted-by-provider" ||
            type ==
                "construction-vehicle-renting-request-negotiated-by-provider" ||
            type ==
                "construction-vehicle-renting-request-provider-found") {
          endpoint =
              '${ApiLinkNames.server}/api/construction-vehicle-order-matches/$id';
        } else if (type ==
                "construction-attachment-renting-request-accepted-by-provider" ||
            type ==
                "construction-attachment-renting-request-negotiated-by-provider" ||
            type ==
                "construction-attachment-renting-request-provider-found") {
          endpoint =
              '${ApiLinkNames.server}/api/construction-attachment-order-matches/$id';
        } else if (type ==
                "construction-equipment-renting-request-accepted-by-provider" ||
            type ==
                "construction-equipment-renting-request-negotiated-by-provider" ||
            type ==
                "construction-equipment-renting-request-provider-found") {
          endpoint =
              '${ApiLinkNames.server}/api/construction-equipment-order-matches/$id';
        } else if (type ==
                "transportation-vehicle-renting-request-accepted-by-provider" ||
            type ==
                "transportation-vehicle-renting-request-negotiated-by-provider" ||
            type ==
                "transportation-vehicle-renting-request-accepted-by-renter" ||
            type ==
                "transportation-vehicle-renting-request-provider-found") {
          // Correct type added here
          endpoint =
              '${ApiLinkNames.server}/api/transportation-vehicle-order-matches/$id';
        }
      }

      // Fetch data from the correct endpoint
      var response = await http.get(Uri.parse(endpoint), headers: headers);

      if (response.statusCode == 200) {
        var additionalData = json.decode(response.body);
        var orderData = additionalData['match']?['order'] ??
            additionalData['order']; // Handle both settled and accepted

        var vehicleData = additionalData['match']?['construction_vehicle'] ??
            additionalData['construction_vehicle'];

        // Handle specific fields for different types
        if (orderData != null && orderData.containsKey('sub_category')) {
          notification['data']['sub_category_label'] =
              orderData['sub_category']['label'] ?? 'Unknown Sub Category';
          notification['data']['sub_category_photo'] =
              orderData['sub_category']['photo'] ?? '';
        }

        if (vehicleData != null) {
          notification['data']['brand'] =
              vehicleData['brand'] ?? 'Unknown Brand';
          notification['data']['model'] =
              vehicleData['model'] ?? 'Unknown Model';
          notification['data']['city'] = vehicleData['city'] ?? 'Unknown City';
        }

        notification['data']['order_total_price'] = additionalData['match']
                ?['total_price'] ??
            additionalData['total_price'] ??
            '0';
      } else {
        print(
            'Error fetching additional data: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to fetch additional data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: orders.isEmpty
            ? Center(
                child: Text(
                  'You have no notifications.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : Container(
                width: Get.width,
                height: Get.height,
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    dynamic notificationData = orders[index]['data'];

                    String photoUrl = constructImageUrl(
                            notificationData['sub_category_photo']) ??
                        '';

                    final String title =
                        notificationData['sub_category_label'] ??
                            'Unknown Sub Category';

                    final String subtitle =
                        "${notificationData['brand']} ${notificationData['model']}" ??
                            'Unknown Brand Model';

                    final String providerUserType =
                        notificationData['provider_type'] ?? 'Unknown';
                    final String city = notificationData['city'] ?? 'Unknown';
                    final String totalPrice =
                        notificationData['order_total_price'].toString();

                    Widget displayImage =
                        notificationData['order_match_type'] == 'settled'
                            ? SvgPicture.asset(
                                AppImageAsset.done,
                                height: 150,
                                width: 150,
                              )
                            : (photoUrl.isNotEmpty
                                ? AppNetworkImage(
                                    photoUrl,
                                    fit: BoxFit.contain,
                                    height: 150,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/images/no_image_available.png');
                                    },
                                  )
                                : Image.asset(
                                    'assets/images/no_image_available.png',
                                    height: 150));

                    return FoundCard(
                      title: title,
                      subtitle: subtitle,
                      type: providerUserType,
                      location: city,
                      price: totalPrice,
                      displayImage: displayImage,
                      notificationType: orders[index]['type'],
                      matchId: notificationData['match_id'],
                    );
                  },
                ),
              ),
      ),
    );
  }

  static String? constructImageUrl(String? url) {
    if (url == null) {
      return null;
    }
    if (url.startsWith('public/')) {
      url = url.replaceFirst('public/', '/storage/');
    }
    String baseUrl = '${ApiLinkNames.server}'; // Your actual base URL
    return '$baseUrl$url'; // Construct full image URL
  }
}

class FoundCard extends StatelessWidget {
  final String? title, subtitle, type, price, location;
  final Widget displayImage;
  final String notificationType;
  final int? matchId;

  const FoundCard({
    super.key,
    required this.displayImage,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.price,
    required this.location,
    required this.notificationType,
    required this.matchId,
  });
  // Map notification types to icons
  Icon _getNotificationIcon(String notificationType) {
    switch (notificationType) {
      case "construction-vehicle-renting-request-accepted-by-provider":
        return Icon(Icons.construction, color: Colors.orange, size: 30);
      case "construction-attachment-renting-request-accepted-by-provider":
        return Icon(Icons.build, color: Colors.blue, size: 30);
      case "construction-equipment-renting-request-accepted-by-provider":
        return Icon(Icons.engineering, color: Colors.purple, size: 30);
      case "transportation-vehicle-renting-request-accepted-by-provider":
        return Icon(Icons.directions_car, color: Colors.green, size: 30);
      case "construction-vehicle-order-match-settled":
      case "construction-equipment-order-match-settled":
      case "construction-attachment-order-match-settled":
      case "transportation-vehicle-order-match-settled":
        return Icon(Icons.check_circle, color: Colors.green, size: 30);
      default:
        return Icon(Icons.notifications, color: Colors.grey, size: 30);
    }
  }

  Future<void> navigateToCommandBody(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Error: Token is null. Please login again.');
        return;
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      String endpoint = '';
      if (notificationType.contains('construction-vehicle')) {
        endpoint =
            '${ApiLinkNames.server}/api/construction-vehicle-order-matches/$matchId';
      } else if (notificationType.contains('construction-equipment')) {
        endpoint =
            '${ApiLinkNames.server}/api/construction-equipment-order-matches/$matchId';
      } else if (notificationType.contains('construction-attachment')) {
        endpoint =
            '${ApiLinkNames.server}/api/construction-attachment-order-matches/$matchId';
      } else if (notificationType.contains('transportation-vehicle')) {
        endpoint =
            '${ApiLinkNames.server}/api/transportation-vehicle-order-matches/$matchId';
      }

      var response = await http.get(Uri.parse(endpoint), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> orderData = json.decode(response.body);
        print('API Response: $orderData'); // Debug print to log the response

        if (orderData.isNotEmpty && orderData.containsKey('order')) {
          String categoryType = '';
          dynamic vehicleData;

          if (notificationType.contains('construction-vehicle')) {
            categoryType = 'Construction Vehicle';
            vehicleData = orderData['construction_vehicle'];
          } else if (notificationType.contains('construction-equipment')) {
            categoryType = 'Construction Equipment';
            vehicleData = orderData['construction_equipment'];
          } else if (notificationType.contains('construction-attachment')) {
            categoryType = 'Construction Attachment';
            vehicleData = orderData['construction_attachment'];
          } else if (notificationType.contains('transportation-vehicle')) {
            categoryType = 'Transportation Vehicle';
            vehicleData = orderData['transportation_vehicle'];
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommandBody(
                orderData: {
                  'order_id': orderData['order']
                      ['id'], // Pass the correct order ID
                  'categoryType': categoryType,
                  'order': orderData['order'], // Pass the full order object
                  '${categoryType.toLowerCase().replaceAll(" ", "_")}':
                      vehicleData, // Add vehicle/equipment data
                },
              ),
            ),
          );
        } else {
          print('Error: Order data is null or does not contain expected keys.');
        }
      } else {
        print('Failed to fetch order data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while navigating: $e');
    }
  }

  Future<void> acceptOrder(BuildContext context) async {
    // Implement API call to accept order
    if (matchId == null) {
      print("Error: matchId is null.");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Error: Token is null. Please login again.');
      return;
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String endpoint = '';

    if (notificationType.contains("construction-vehicle")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-vehicle-order-matches/accept/$matchId';
    } else if (notificationType.contains("construction-equipment")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-equipment-order-matches/accept/$matchId';
    } else if (notificationType.contains("construction-attachment")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-attachment-order-matches/accept/$matchId';
    } else if (notificationType.contains("transportation-vehicle")) {
      endpoint =
          '${ApiLinkNames.server}/api/transportation-vehicle-order-matches/accept/$matchId';
    }

    try {
      var response = await http.put(Uri.parse(endpoint), headers: headers);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Order accepted successfully!'),
              backgroundColor: Colors.green),
        );
      } else {
        print('Failed to accept order: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while accepting the order: $e');
    }
  }

  Future<void> cancelOrder(BuildContext context) async {
    // Implement API call to cancel order
    if (matchId == null) {
      print("Error: matchId is null.");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Error: Token is null. Please login again.');
      return;
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String endpoint = '';

    if (notificationType.contains("construction-vehicle")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-vehicle-order-matches/cancel/$matchId';
    } else if (notificationType.contains("construction-equipment")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-equipment-order-matches/cancel/$matchId';
    } else if (notificationType.contains("construction-attachment")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-attachment-order-matches/cancel/$matchId';
    } else if (notificationType.contains("transportation-vehicle")) {
      endpoint =
          '${ApiLinkNames.server}/api/transportation-vehicle-order-matches/cancel/$matchId';
    }

    try {
      var response = await http.put(Uri.parse(endpoint), headers: headers);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Order canceled successfully!'),
              backgroundColor: Colors.red),
        );
      } else {
        print('Failed to cancel order: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while canceling the order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 150,
                    child: displayImage,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _getNotificationIcon(notificationType),
                          // Icon(Icons.handshake, color: Colors.grey, size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              title ?? 'No Title Available',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
                          Text(
                            "${price ?? '0'} DZD",
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton(
                          onPressed: () => navigateToCommandBody(context),
                          child: const Text('View Details'),
                        ),
                      ),
                      if (notificationType
                          .contains("renting-request-negotiated-by-provider"))
                        Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    minimumSize:
                                        Size(80, 40), // Adjust the button size
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    textStyle: TextStyle(
                                        fontSize: 12), // Adjust the text size
                                  ),
                                  onPressed: () => acceptOrder(context),
                                  child: const Text('Accept'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    minimumSize:
                                        Size(80, 40), // Adjust the button size
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    textStyle: TextStyle(
                                        fontSize: 12), // Adjust the text size
                                  ),
                                  onPressed: () => cancelOrder(context),
                                  child: const Text('Cancel'),
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
