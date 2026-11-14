import 'dart:async';
import 'dart:convert';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/views/screens/notifications/ProviderNegotiateScreen.dart';
import 'package:hasad/views/screens/notifications/ProviderOfferScreen.dart';
import 'package:hasad/widgets/home/items/notificationsicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class NotificaitonScreenProvider extends StatefulWidget {
  const NotificaitonScreenProvider({super.key});

  @override
  _NotificaitonScreenProviderState createState() =>
      _NotificaitonScreenProviderState();
}

class _NotificaitonScreenProviderState
    extends State<NotificaitonScreenProvider> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    // Set up periodic refresh every 30 seconds
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      fetchNotifications();
    });
  }

  static String? constructImageUrl(String? url) {
    if (url == null) return null;
    if (url.startsWith('public/')) {
      url = url.replaceFirst('public/', 'storage/');
    }
    String fullUrl = '${ApiLinkNames.server}/$url';
    return fullUrl.replaceAll('//', '/').replaceFirst('http:/', 'http://');
  }
  // static String? constructImageUrl(String? url) {
  //   if (url == null) {
  //     return null;
  //   }

  //   if (url.startsWith('public/')) {
  //     url = url.replaceFirst('public/', 'storage/');
  //   }

  //   String fullUrl = '${ApiLinkNames.server}/$url';
  //   fullUrl = fullUrl.replaceAll('//', '/').replaceFirst('http:/', 'http://');
  //   return fullUrl;
  // }
  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>?> fetchOrderData(
      int orderId, String notificationType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Error: Token is null. User may not be logged in.");
      return null;
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    String endpoint = '';

    // Determine the correct endpoint based on notification type
    if (notificationType.contains("construction-vehicle")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-vehicle-order-matches/$orderId';
    } else if (notificationType.contains("transportation-vehicle")) {
      endpoint =
          '${ApiLinkNames.server}/api/transportation-vehicle-order-matches/$orderId';
    } else if (notificationType.contains("construction-equipment")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-equipment-order-matches/$orderId';
    } else if (notificationType.contains("construction-attachment")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-attachment-order-matches/$orderId';
    }

    try {
      var response = await http.get(Uri.parse(endpoint), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            'Failed to fetch order data: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error fetching order data: $e');
      return null;
    }
  }

  Future<void> acceptOrder(int matchId, String notificationType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Error: Token is null. User may not be logged in.");
      return;
    }

    String endpoint = _getAcceptEndpoint(notificationType, matchId);
    if (endpoint.isEmpty) return;

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.put(
        Uri.parse(endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("Order accepted successfully.");
        fetchNotifications(); // Refresh the list after accepting
      } else {
        print('Failed to accept order: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// Método para aceptar el pedido
  // Future<void> acceptOrder(int matchId, String notificationType) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   if (token == null) {
  //     print("Error: Token is null. User may not be logged in.");
  //     return;
  //   }

  //   String endpoint = _getAcceptEndpoint(notificationType, matchId);
  //   if (endpoint.isEmpty) return;

  //   var headers = {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };

  //   try {
  //     var response = await http.put(
  //       Uri.parse(endpoint),
  //       headers: headers,
  //     );

  //     if (response.statusCode == 200) {
  //       print("Order accepted successfully.");
  //       fetchNotifications(); // Refresh the list after accepting
  //     } else {
  //       print('Failed to accept order: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  // Método para cancelar el pedido
  Future<void> cancelOrder(int matchId, String notificationType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Error: Token is null. User may not be logged in.");
      return;
    }

    String endpoint = _getCancelEndpoint(notificationType, matchId);
    if (endpoint.isEmpty) return;

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.put(
        Uri.parse(endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("Order canceled successfully.");
        fetchNotifications(); // Refresh the list after cancelling
      } else {
        print('Failed to cancel order: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String _getAcceptEndpoint(String notificationType, int matchId) {
    String endpoint = '';

    if (notificationType.contains("construction-vehicle")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-vehicle-order-matches/accept/$matchId';
    } else if (notificationType.contains("transportation-vehicle")) {
      endpoint =
          '${ApiLinkNames.server}/api/transportation-vehicle-order-matches/accept/$matchId';
    } else if (notificationType.contains("construction-equipment")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-equipment-order-matches/accept/$matchId';
    } else if (notificationType.contains("construction-attachment")) {
      endpoint =
          '${ApiLinkNames.server}/api/construction-attachment-order-matches/accept/$matchId';
    }

    if (endpoint.isEmpty) {
      print("Invalid notification type: $notificationType");
    } else {
      print("Accept endpoint: $endpoint"); // Log the endpoint for debugging
    }

    return endpoint;
  }

  String _getCancelEndpoint(String notificationType, int matchId) {
    if (notificationType.contains("vehicle")) {
      return '${ApiLinkNames.server}/api/construction-vehicle-order-matches/cancel/$matchId';
    } else if (notificationType.contains("transportation")) {
      return '${ApiLinkNames.server}/api/transportation-vehicle-order-matches/cancel/$matchId';
    } else if (notificationType.contains("equipment")) {
      return '${ApiLinkNames.server}/api/construction-equipment-order-matches/cancel/$matchId';
    } else if (notificationType.contains("attachment")) {
      return '${ApiLinkNames.server}/api/construction-attachment-order-matches/cancel/$matchId';
    }
    return '';
  }

  Future<void> fetchNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Error: Token is null. User may not be logged in.");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.get(
        Uri.parse('${ApiLinkNames.server}/api/notifications/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> rawNotifications = jsonDecode(response.body);

        // Get the filtered notifications
        List<dynamic> alwaysVisibleNotifications =
            _getAlwaysVisibleNotifications(rawNotifications);
        List<dynamic> recentNotifications =
            _getRecentNotifications(rawNotifications);

        // Combine recent and always visible notifications
        List<dynamic> combinedNotifications = [
          ...recentNotifications,
          ...alwaysVisibleNotifications,
        ];

        // Fetch additional data if needed
        await _fetchAdditionalDataForNotifications(combinedNotifications);

        // Update the UI only if mounted
        if (mounted) {
          setState(() {
            notifications = combinedNotifications;
            isLoading = false;
          });
        }
      } else {
        print(
            'Error fetching notifications: ${response.statusCode} - ${response.reasonPhrase}');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Failed to fetch notifications: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<dynamic> _getAlwaysVisibleNotifications(List<dynamic> rawNotifications) {
    return rawNotifications.where((notification) {
      return notification['type'] == "construction-vehicle-renting-request-negotiated-by-renter" ||
          notification['type'] ==
              "construction-attachment-renting-request-negotiated-by-renter" ||
          notification['type'] ==
              "construction-equipment-renting-request-negotiated-by-renter" ||
          notification['type'] ==
              "transportation-vehicle-renting-request-negotiated-by-renter" ||
          notification['type'] == "construction-vehicle-order-match-settled" ||
          notification['type'] ==
              "construction-attachment-order-match-settled" ||
          notification['type'] ==
              "construction-equipment-order-match-settled" ||
          notification['type'] ==
              "transportation-vehicle-order-match-settled" ||
          notification['type'] ==
              "construction-vehicle-renting-request-accepted-by-renter" ||
          notification['type'] ==
              "construction-attachment-renting-request-accepted-by-renter" ||
          notification['type'] ==
              "construction-equipment-renting-request-accepted-by-renter" ||
          notification['type'] ==
              "transportation-vehicle-renting-request-accepted-by-renter";
    }).toList();
  }

  List<dynamic> _getRecentNotifications(List<dynamic> rawNotifications) {
    // New demands stay visible until the provider acts on them. There is no
    // time window anymore — previously a demand disappeared from this screen
    // 10 minutes after it was placed, which made demands look "lost".
    return rawNotifications.where((notification) {
      return notification['type'] == "construction-vehicle-renting-request-placed" ||
          notification['type'] ==
              "construction-attachment-renting-request-placed" ||
          notification['type'] ==
              "construction-equipment-renting-request-placed" ||
          notification['type'] ==
              "transportation-vehicle-renting-request-placed";
    }).toList();
  }

  Future<void> _fetchAdditionalDataForNotifications(
      List<dynamic> notifications) async {
    for (var notification in notifications) {
      String type = notification['type'];
      int? matchId = notification['data']['match_id'];
      int? successfulMatchId = notification['data']['successful_match_id'];

      if (matchId != null) {
        await fetchAdditionalData(
            matchId, notification, false); // Ongoing match
      } else if (successfulMatchId != null) {
        await fetchAdditionalData(
            successfulMatchId, notification, true); // Settled match
      }
    }
  }

  Future<void> fetchAdditionalData(
      int id, dynamic notification, bool isSettled) async {
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

    // Fetching based on the type of notification
    if (isSettled) {
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
      // Handling 'request-placed', 'accepted-by-renter', and 'negotiated-by-renter' cases
      if (type == "construction-vehicle-renting-request-placed" ||
          type == "construction-vehicle-renting-request-accepted-by-renter" ||
          type == "construction-vehicle-renting-request-negotiated-by-renter") {
        endpoint =
            '${ApiLinkNames.server}/api/construction-vehicle-order-matches/$id';
      } else if (type == "construction-attachment-renting-request-placed" ||
          type ==
              "construction-attachment-renting-request-accepted-by-renter" ||
          type ==
              "construction-attachment-renting-request-negotiated-by-renter") {
        endpoint =
            '${ApiLinkNames.server}/api/construction-attachment-order-matches/$id';
      } else if (type == "construction-equipment-renting-request-placed" ||
          type == "construction-equipment-renting-request-accepted-by-renter" ||
          type ==
              "construction-equipment-renting-request-negotiated-by-renter") {
        endpoint =
            '${ApiLinkNames.server}/api/construction-equipment-order-matches/$id';
      } else if (type == "transportation-vehicle-renting-request-placed" ||
          type == "transportation-vehicle-renting-request-accepted-by-renter" ||
          type ==
              "transportation-vehicle-renting-request-negotiated-by-renter") {
        endpoint =
            '${ApiLinkNames.server}/api/transportation-vehicle-order-matches/$id';
      }
    }

    // Ensure endpoint is valid
    if (endpoint.isEmpty) {
      print('Invalid endpoint for type: $type');
      return;
    }

    // Fetch data from the correct endpoint
    try {
      var response = await http.get(Uri.parse(endpoint), headers: headers);

      if (response.statusCode == 200) {
        var additionalData = jsonDecode(response.body);
        var orderData =
            additionalData['match']?['order'] ?? additionalData['order'];

        var vehicleData = additionalData['match']?['construction_vehicle'] ??
            additionalData['construction_vehicle'];

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

  // Machine info of a new demand, read directly from the notification
  // payload (keys are prefixed by category).
  Map<String, String?> _machineInfo(String type, dynamic data) {
    String prefix;
    if (type.startsWith('construction-vehicle')) {
      prefix = 'construction_vehicle';
    } else if (type.startsWith('construction-equipment')) {
      prefix = 'construction_equipment';
    } else if (type.startsWith('construction-attachment')) {
      prefix = 'construction_attachment';
    } else {
      prefix = 'transportation_vehicle';
    }

    return {
      'subCategory': data['${prefix}_sub_category']?.toString(),
      'photo': data['${prefix}_sub_category_photo']?.toString(),
      'brand': data['${prefix}_brand']?.toString(),
      'model': data['${prefix}_model']?.toString(),
      'region': data['${prefix}_region']?.toString(),
      'city': data['${prefix}_city']?.toString(),
      'pricePerDay': data['machine_price_per_day']?.toString() ?? '0',
    };
  }

  // Card for a new renting demand. Unlike the legacy flow, no offer exists
  // yet: the provider opens ProviderOfferScreen to submit one manually.
  Widget _buildNewDemandCard(
      dynamic notification, dynamic data, String type) {
    final machine = _machineInfo(type, data);
    final imageUrl = constructImageUrl(machine['photo']);

    return Column(
      children: [
        FoundCard(
          title: machine['subCategory'] ?? 'Unknown Sub Category',
          subtitle: "${machine['brand'] ?? 'Unknown'} ${machine['model'] ?? ''}",
          type: data['renter_type'] ?? 'Unknown',
          location:
              "${machine['city'] ?? 'Unknown'}, ${machine['region'] ?? 'Unknown'}",
          price: machine['pricePerDay'],
          image: imageUrl,
          message:
              "New renting demand - price per day. Send your offer.",
          notificationIcon: Icons.notifications_active,
          cardColor: Colors.yellow.shade50,
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.to(() => ProviderOfferScreen(
                        orderData: Map<String, dynamic>.from(data),
                        notificationType: type,
                      ));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                child: const Text('Send Offer'),
              ),
            ],
          ),
        ),
        // Divider to separate each card visually
        const Divider(
          thickness: 1.0,
          height: 32.0,
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Image.asset(AppImageAsset.logowithbackbtn),
                //     const NotificationIcon(),
                //   ],
                // ),
                const SizedBox(height: 15),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : notifications.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppImageAsset.notificationsEmpty,
                                    width: Get.width * 0.9,
                                    fit: BoxFit.contain,
                                  ),
                                  Text(
                                    "No Notifications Found",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.backgroundColor),
                                  )
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final notification = notifications[index];
                                final data = notification['data'];
                                final imageUrl = constructImageUrl(
                                    data['sub_category_photo']);
                                final type = notification['type'];

                                String message;
                                IconData notificationIcon;
                                Color cardColor;

                                // New demand flow: the notification carries the
                                // demand itself (order_id); no offer exists
                                // yet. The provider decides whether to send
                                // an offer. (Legacy notifications carry a
                                // match_id instead and keep the old path.)
                                if (data['order_id'] != null &&
                                    (type ==
                                            "construction-vehicle-renting-request-placed" ||
                                        type ==
                                            "construction-attachment-renting-request-placed" ||
                                        type ==
                                            "construction-equipment-renting-request-placed" ||
                                        type ==
                                            "transportation-vehicle-renting-request-placed")) {
                                  return _buildNewDemandCard(
                                      notification, data, type);
                                }

                                if (type == "construction-vehicle-renting-request-placed" ||
                                    type ==
                                        "construction-attachment-renting-request-placed" ||
                                    type ==
                                        "construction-equipment-renting-request-placed" ||
                                    type ==
                                        "transportation-vehicle-renting-request-placed" ||
                                    type ==
                                        "construction-vehicle-renting-request-accepted-by-renter" ||
                                    type ==
                                        "construction-attachment-renting-request-accepted-by-renter" ||
                                    type ==
                                        "construction-equipment-renting-request-accepted-by-renter" ||
                                    type ==
                                        "transportation-vehicle-renting-request-accepted-by-renter") {
                                  notificationIcon = Icons.notifications;
                                  cardColor = Colors.yellow.shade50;
                                  message =
                                      "New Request: ${data['brand']} ${data['model']}";

                                  // Fetch the status of the order to determine whether to show "Accept" and "Cancel" buttons
                                  return FutureBuilder<Map<String, dynamic>?>(
                                    future: fetchOrderData(
                                        notification['data']['match_id'], type),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError ||
                                          snapshot.data == null) {
                                        return const Center(
                                            child: Text("Failed to load data"));
                                      }

                                      // Extract the order status from the fetched data
                                      final orderData = snapshot.data!;
                                      final String status =
                                          orderData['status'] ?? 'unknown';

                                      return Column(
                                        children: [
                                          FoundCard(
                                            title: data['sub_category_label'] ??
                                                'Unknown Sub Category',
                                            subtitle:
                                                "${data['brand']} ${data['model']}" ??
                                                    'Unknown Brand Model',
                                            type: data['renter_type'] ??
                                                'Unknown',
                                            location:
                                                "${data['city']}, ${data['region']}" ??
                                                    'Unknown City, Unknown Region',
                                            price: data['order_total_price']
                                                    ?.toString() ??
                                                '0',
                                            image: imageUrl,
                                            message: message,
                                            notificationIcon: notificationIcon,
                                            cardColor: cardColor,
                                          ),
                                          // Show "Accept" and "Cancel" buttons if status is "pending" or "accepted_by_renter"
                                          if (status == 'pending' ||
                                              status == 'accepted_by_renter')
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await acceptOrder(
                                                          notification['data']
                                                              ['match_id'],
                                                          type);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.green),
                                                    child: const Text('Accept'),
                                                  ),
                                                  const SizedBox(width: 16.0),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await cancelOrder(
                                                          notification['data']
                                                              ['match_id'],
                                                          type);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.red),
                                                    child: const Text('Cancel'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          // Divider to separate each card visually
                                          const Divider(
                                            thickness: 1.0,
                                            height: 32.0,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (type ==
                                        "construction-vehicle-renting-request-negotiated-by-renter" ||
                                    type ==
                                        "construction-attachment-renting-request-negotiated-by-renter" ||
                                    type ==
                                        "transportation-vehicle-renting-request-negotiated-by-renter" ||
                                    type ==
                                        "construction-equipment-renting-request-negotiated-by-renter") {
                                  notificationIcon = Icons.handshake;
                                  cardColor = Colors.orange.shade50;
                                  message =
                                      "Negotiation in progress for ${data['brand']} ${data['model']}";

                                  // Handle click to navigate to the negotiation screen
                                  return GestureDetector(
                                    onTap: () async {
                                      // Fetch additional data before navigating to ProviderNegotiateScreen
                                      final updatedOrderData =
                                          await fetchOrderData(
                                              notification['data']['match_id'],
                                              type);

                                      if (updatedOrderData != null) {
                                        // Add categoryType to the updatedOrderData if not present
                                        if (!updatedOrderData
                                            .containsKey('categoryType')) {
                                          if (type.contains(
                                              'construction-vehicle')) {
                                            updatedOrderData['categoryType'] =
                                                'Construction Vehicle';
                                          } else if (type.contains(
                                              'transportation-vehicle')) {
                                            updatedOrderData['categoryType'] =
                                                'Transportation Vehicle';
                                          } else if (type.contains(
                                              'construction-equipment')) {
                                            updatedOrderData['categoryType'] =
                                                'Construction Equipment';
                                          } else if (type.contains(
                                              'construction-attachment')) {
                                            updatedOrderData['categoryType'] =
                                                'Construction Attachment';
                                          }
                                        }
                                        print(
                                            "Navigating with updatedOrderData: $updatedOrderData");
                                        final String notificationType =
                                            notification['type'];
                                        final int? matchId =
                                            notification['data']['match_id'];

                                        if (matchId != null) {
                                          Get.to(() => ProviderNegotiateScreen(
                                                orderData: updatedOrderData,
                                                matchId: matchId,
                                                notificationType:
                                                    notificationType,
                                              ));
                                        } else {
                                          print("Error: matchId is null.");
                                        }
                                      } else {
                                        print(
                                            "Error: Failed to fetch order data or match ID is missing.");
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        FoundCard(
                                          title: data['sub_category_label'] ??
                                              'Unknown Sub Category',
                                          subtitle:
                                              "${data['brand']} ${data['model']}" ??
                                                  'Unknown Brand Model',
                                          type:
                                              data['renter_type'] ?? 'Unknown',
                                          location:
                                              "${data['city']}, ${data['region']}" ??
                                                  'Unknown City, Unknown Region',
                                          price: data['order_total_price']
                                                  ?.toString() ??
                                              '0',
                                          image: imageUrl,
                                          message: message,
                                          notificationIcon: notificationIcon,
                                          cardColor: cardColor,
                                        ),
                                        // Divider to separate each card visually
                                        const Divider(
                                          thickness: 1.0,
                                          height: 32.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (type
                                    .contains('order-match-settled')) {
                                  notificationIcon = Icons.done_all;
                                  cardColor = Colors.blue.shade50;
                                  message =
                                      "Order settled: ${data['brand']} ${data['model']}";
                                } else {
                                  notificationIcon =
                                      Icons.notification_important;
                                  cardColor = Colors.grey.shade50;
                                  message = "Unknown notification type.";
                                }

                                return Column(
                                  children: [
                                    FoundCard(
                                      title: data['sub_category_label'] ??
                                          'Unknown Sub Category',
                                      subtitle:
                                          "${data['brand']} ${data['model']}" ??
                                              'Unknown Brand Model',
                                      type: data['renter_type'] ?? 'Unknown',
                                      location:
                                          "${data['city']}, ${data['region']}" ??
                                              'Unknown City, Unknown Region',
                                      price: data['order_total_price']
                                              ?.toString() ??
                                          '0',
                                      image: imageUrl,
                                      message: message,
                                      notificationIcon: notificationIcon,
                                      cardColor: cardColor,
                                    ),
                                    // Divider to separate each card visually
                                    const Divider(
                                      thickness: 1.0,
                                      height: 32.0,
                                      color: Colors.grey,
                                    ),
                                  ],
                                );
                              },
                            ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FoundCard extends StatelessWidget {
  final String? image, title, subtitle, type, price, location, message;
  final IconData notificationIcon;
  final Color cardColor;

  const FoundCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.price,
    required this.location,
    required this.message,
    required this.notificationIcon,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Card(
      color: cardColor,
      elevation: 20,
      margin: EdgeInsets.symmetric(
        horizontal: Get.context!.width * .03,
        vertical: Get.context!.height * .02,
      ),
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
                                  'assets/images/notify_icon.png');
                            },
                          )
                        : Image.asset('assets/images/notify_icon.png'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(notificationIcon, color: textColor),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              title ?? 'Unknown Sub Category',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        subtitle ?? 'Unknown Brand Model',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: textColor,
                          ),
                          Expanded(
                            child: Text(
                              type ?? 'N/A',
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: textColor),
                          Expanded(
                            child: Text(
                              location ?? 'Unknown City, Unknown Region',
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on,
                              color: Colors.green),
                          Expanded(
                            child: Text(
                              "${price ?? '0'} DZD",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          message ?? 'No Message Available',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
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

// import 'dart:convert';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/widgets/home/backbtnlogo.dart';
// import 'package:hasad/widgets/home/homepagelogo.dart';
// import 'package:hasad/widgets/home/items/notificationsicon.dart';
// import 'package:hasad/widgets/home/providerhome/provider_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificaitonScreenProvider extends StatefulWidget {
//   const NotificaitonScreenProvider({super.key});

//   @override
//   _NotificaitonScreenProviderState createState() =>
//       _NotificaitonScreenProviderState();
// }

// class _NotificaitonScreenProviderState
//     extends State<NotificaitonScreenProvider> {
//   List<dynamic> notifications = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//   }

//   // Construct the image URL and print it for debugging
//   static String? constructImageUrl(String? url) {
//     if (url == null) {
//       print("Image URL is null");
//       return null;
//     }

//     // Ensure correct URL construction for storage images
//     if (url.startsWith('public/')) {
//       url = url.replaceFirst('public/', 'storage/');
//     }

//     // Construct the full URL with proper protocol handling
//     String fullUrl = '${ApiLinkNames.server}/$url';

//     // Ensure that there are no accidental double slashes (e.g., "${ApiLinkNames.server}//")
//     fullUrl = fullUrl.replaceAll('//', '/').replaceFirst('http:/', 'http://');

//     print("Constructed Image URL: $fullUrl"); // Print the image URL path

//     return fullUrl;
//   }

//   Future<void> fetchNotifications() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       print("Error: Token is null. User may not be logged in.");
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     var headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     try {
//       var response = await http.get(
//         Uri.parse('${ApiLinkNames.server}/api/notifications/'),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> rawNotifications = jsonDecode(response.body);

//         for (var notification in rawNotifications) {
//           // Si no hay imagen, intenta obtenerla usando match_id
//           if (notification['data']['construction_vehicle_sub_category_photo'] ==
//               null) {
//             int? matchId = notification['data']['match_id'];
//             if (matchId != null) {
//               await fetchMatchDetails(matchId, notification);
//             }
//           }
//         }

//         setState(() {
//           notifications = rawNotifications;
//           isLoading = false;
//         });
//       } else {
//         print(
//             'Error fetching notifications: ${response.statusCode} - ${response.reasonPhrase}');
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Failed to fetch notifications: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> fetchMatchDetails(
//       int matchId, Map<String, dynamic> notification) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       print("Error: Token is null. User may not be logged in.");
//       return;
//     }

//     var headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     try {
//       var response = await http.get(
//         Uri.parse(
//             '${ApiLinkNames.server}/api/construction-vehicle-order-matches/$matchId'),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         var matchDetails = jsonDecode(response.body);
//         print("Match Details Response for match_id $matchId: $matchDetails");

//         // Actualizar la notificación original con la información obtenida
//         if (matchDetails['order'] != null) {
//           notification['data']['construction_vehicle_sub_category'] =
//               matchDetails['order']['sub_category']['label'] ?? 'No Title';
//           notification['data']['construction_vehicle_brand'] =
//               matchDetails['construction_vehicle']['brand'] ?? 'Unknown';
//           notification['data']['construction_vehicle_model'] =
//               matchDetails['construction_vehicle']['model'] ?? 'Unknown';
//           notification['data']['construction_vehicle_region'] =
//               matchDetails['construction_vehicle']['region'] ?? 'Unknown';
//           notification['data']['construction_vehicle_city'] =
//               matchDetails['construction_vehicle']['city'] ?? 'Unknown';
//           notification['data']['order_total_price'] =
//               matchDetails['total_price'] ?? '0';

//           // Obtener la URL de la imagen desde `sub_category.photo`
//           String? imagePath = matchDetails['order']['sub_category']['photo'];
//           if (imagePath != null) {
//             notification['data']['construction_vehicle_sub_category_photo'] =
//                 imagePath;
//           } else {
//             notification['data']['construction_vehicle_sub_category_photo'] =
//                 null;
//           }

//           // Determinar el `renter_type`
//           // En este caso, simplemente vamos a diferenciar si el `user_id` está presente
//           if (matchDetails['order']['user_id'] != null) {
//             // Si el `user_id` está presente, asumimos que es un arrendatario individual
//             notification['data']['renter_type'] = "renter_individual";
//           } else {
//             // Si no hay `user_id`, asumimos que puede ser otro tipo o "desconocido"
//             notification['data']['renter_type'] = "unknown";
//           }
//         }
//       } else {
//         print(
//             'Error fetching match details: ${response.statusCode} - ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       print('Failed to fetch match details: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: Get.width,
//           height: Get.height,
//           margin: const EdgeInsets.symmetric(vertical: 15),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Image.asset(AppImageAsset.logowithbackbtn),
//                     const NotificationIcon(),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 Expanded(
//                   child: isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : ListView.builder(
//                           itemCount: notifications.length,
//                           itemBuilder: (context, index) {
//                             final notification = notifications[index];
//                             final data = notification['data'];
//                             final imageUrl = constructImageUrl(data[
//                                 'construction_vehicle_sub_category_photo']);
//                             final type = notification['type'];

//                             String message;
//                             if (type ==
//                                 "construction-vehicle-renting-request-negotiated-by-renter") {
//                               message = data['message'] ?? 'No Message';
//                             } else if (type ==
//                                 "construction-vehicle-renting-request-placed") {
//                               message = "New renting request placed by renter.";
//                             } else {
//                               message = "Unknown notification type.";
//                             }

//                             // Determinar si se deben mostrar los botones
//                             bool showButtons = (type ==
//                                     "construction-vehicle-renting-request-placed" ||
//                                 type ==
//                                     "construction-attachment-renting-request-placed" ||
//                                 type ==
//                                     "construction-equipment-renting-request-placed");

//                             // Obtener `matchId` de los datos de la notificación
//                             int matchId = data['match_id'] ??
//                                 -1; // Asegúrate de que `match_id` sea un valor válido

//                             return FoundCard(
//                               title:
//                                   data['construction_vehicle_sub_category'] ??
//                                       'No Title',
//                               subtitle:
//                                   "${data['construction_vehicle_brand']} ${data['construction_vehicle_model']}" ??
//                                       'No Subtitle',
//                               type: data['renter_type'] ?? 'Unknown',
//                               location:
//                                   "${data['construction_vehicle_city']}, ${data['construction_vehicle_region']}" ??
//                                       'Unknown',
//                               price:
//                                   data['order_total_price']?.toString() ?? '0',
//                               image: imageUrl,
//                               message: message,
//                               showButtons:
//                                   showButtons, // Pasar la información para mostrar botones
//                               matchId:
//                                   matchId, // Ahora se pasa el `matchId` al FoundCard
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FoundCard extends StatelessWidget {
//   final String? image, title, subtitle, type, price, location, message;
//   final bool showButtons;
//   final int matchId;

//   const FoundCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.subtitle,
//     required this.type,
//     required this.price,
//     required this.location,
//     required this.message,
//     required this.showButtons,
//     required this.matchId,
//   });

//   // Función para aceptar el pedido
//   Future<void> acceptOrder(int matchId, BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');

//     if (token == null) {
//       print("Error: Token is null. User may not be logged in.");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Error: No token available. Please log in again.')),
//       );
//       return;
//     }

//     var headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     try {
//       var response = await http.put(
//         Uri.parse(
//             '${ApiLinkNames.server}/api/construction-vehicle-order-matches/accept/$matchId'),
//         headers: headers,
//       );

//       // Imprimir la respuesta de la API
//       print('API Response (${response.statusCode}): ${response.body}');

//       if (response.statusCode == 200) {
//         // Mostrar Snackbar de éxito
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Order accepted successfully!')),
//         );
//       } else {
//         // Mostrar Snackbar de error
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content:
//                   Text('Failed to accept order: ${response.reasonPhrase}')),
//         );
//       }
//     } catch (e) {
//       print('Failed to accept order: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to accept order: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 20,
//       margin: EdgeInsets.symmetric(
//           horizontal: Get.context!.width * .03,
//           vertical: Get.context!.height * .02),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: Get.context!.height * .02),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: SizedBox(
//                     height: 150,
//                     child: image != null && image!.isNotEmpty
//                         ? AppNetworkImage(
//                             image!,
//                             fit: BoxFit.contain,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Image.asset(
//                                   'assets/images/notify_icon.png');
//                             },
//                           )
//                         : Image.asset('assets/images/notify_icon.png'),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title ?? 'No Title Available',
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.w700),
//                       ),
//                       Text(
//                         subtitle ?? 'No Subtitle Available',
//                         style:
//                             const TextStyle(fontSize: 14, color: Colors.grey),
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.person, color: Colors.grey),
//                           Text(type ?? 'N/A',
//                               style: const TextStyle(fontSize: 12)),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on, color: Colors.grey),
//                           Text(location ?? 'N/A',
//                               style: const TextStyle(fontSize: 12)),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.monetization_on,
//                               color: Colors.green),
//                           Text("${price ?? '0'} DZD",
//                               style: const TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.w700)),
//                         ],
//                       ),
//                       // Mostrar el mensaje de la notificación
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           message ?? 'No Message Available',
//                           style: const TextStyle(
//                               fontSize: 14, color: Colors.blueGrey),
//                         ),
//                       ),
//                       // Mostrar botones si `showButtons` es verdadero
//                       if (showButtons)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 15.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               // Botón de "Accepter" a la izquierda
//                               ElevatedButton(
//                                 onPressed: () {
//                                   acceptOrder(matchId, context);
//                                 },
//                                 child: const Text('Accepter'),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10),
//                                 ),
//                               ),
//                               const SizedBox(
//                                   width: 10), // Espacio entre los botones
//                               // Botón de "Cancel" a la derecha
//                               ElevatedButton(
//                                 onPressed: () {
//                                   // Lógica para cancelar el pedido (podés definir esto después)
//                                   print("Cancelar pedido");
//                                 },
//                                 child: const Text('Cancel'),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// Dart imports
