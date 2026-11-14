import 'dart:async';
import 'dart:convert';
import 'package:hasad/widgets/home/demande/demande_widgets.dart';
import 'package:hasad/widgets/home/homepagelogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class Demanderhome extends StatefulWidget {
  const Demanderhome({super.key});

  @override
  _DemanderhomeState createState() => _DemanderhomeState();
}

class _DemanderhomeState extends State<Demanderhome> {
  final DemanderhomeControllerImp controller =
      Get.put(DemanderhomeControllerImp());
  final ScrollController _scrollController = ScrollController();
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Set up auto refresh timer
    controller.fetchData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        controller.fetchData();
      }
    });
  }

  @override
  void dispose() {
    // Cancel timer when the widget is disposed to prevent memory leaks
    _refreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchData();
          },
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if ((controller.demanderMachine.value.equipments?.isEmpty ??
                    true) &&
                (controller.demanderMachine.value.vehicles?.isEmpty ?? true) &&
                (controller.demanderMachine.value.attachments?.isEmpty ??
                    true) &&
                (controller.demanderMachine.value.transportationVehicles
                        ?.isEmpty ??
                    true)) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.warning, size: 100, color: Colors.grey),
                    SizedBox(height: 20),
                    Text("You have no orders yet.",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                  ],
                ),
              );
            } else {
              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: HomepageLogo(
                      margin: 92,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Text("Vehicles:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  if (controller.demanderMachine.value.vehicles?.isNotEmpty ??
                      false)
                    ...controller.demanderMachine.value.vehicles!
                        .map((vehicle) {
                      return DemanderItemStatusCard(
                        imageUrl: vehicle.photoUrl,
                        brand: vehicle.brand ?? 'Unknown Brand',
                        model: vehicle.model ?? 'Unknown Model',
                        region: vehicle.region ?? 'Unknown Region',
                        city: vehicle.city ?? 'Unknown City',
                        totalPrice: vehicle.totalPrice ?? 'Unknown Price',
                        status:
                            vehicle.renterActivityStatus ?? 'Unknown Status',
                      );
                    }).toList(),
                  const SizedBox(height: 20),
                  const Text("Equipments:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  if (controller.demanderMachine.value.equipments?.isNotEmpty ??
                      false)
                    ...controller.demanderMachine.value.equipments!
                        .map((equipment) {
                      return DemanderItemStatusCard(
                        imageUrl: equipment.photoUrl,
                        brand: equipment.brand ?? 'Unknown Brand',
                        model: equipment.model ?? 'Unknown Model',
                        region: equipment.region ?? 'Unknown Region',
                        city: equipment.city ?? 'Unknown City',
                        totalPrice: equipment.totalPrice ?? 'Unknown Price',
                        status:
                            equipment.renterActivityStatus ?? 'Unknown Status',
                      );
                    }).toList(),
                  const SizedBox(height: 20),
                  const Text("Attachments:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  if (controller
                          .demanderMachine.value.attachments?.isNotEmpty ??
                      false)
                    ...controller.demanderMachine.value.attachments!
                        .map((attachment) {
                      return DemanderItemStatusCard(
                        imageUrl: attachment.photoUrl,
                        brand: attachment.brand ?? 'Unknown Brand',
                        model: attachment.model ?? 'Unknown Model',
                        region: attachment.region ?? 'Unknown Region',
                        city: attachment.city ?? 'Unknown City',
                        totalPrice: attachment.totalPrice ?? 'Unknown Price',
                        status:
                            attachment.renterActivityStatus ?? 'Unknown Status',
                      );
                    }).toList(),
                  const SizedBox(height: 20),
                  const Text("Transportation Vehicles:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  if (controller.demanderMachine.value.transportationVehicles
                          ?.isNotEmpty ??
                      false)
                    ...controller.demanderMachine.value.transportationVehicles!
                        .map((transportVehicle) {
                      return DemanderItemStatusCard(
                        imageUrl: transportVehicle.photoUrl,
                        brand: transportVehicle.brand ?? 'Unknown Brand',
                        model: transportVehicle.model ?? 'Unknown Model',
                        region: transportVehicle.region ?? 'Unknown Region',
                        city: transportVehicle.city ?? 'Unknown City',
                        totalPrice:
                            transportVehicle.totalPrice ?? 'Unknown Price',
                        status: transportVehicle.renterActivityStatus ??
                            'Unknown Status',
                      );
                    }).toList(),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}

class DemanderhomeControllerImp extends GetxController {
  var demanderMachine = DemanderMachine().obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) throw Exception('Token is null. Please login again.');

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var response = await http.get(
        Uri.parse('${ApiLinkNames.server}/api/renter-machines'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        debugPrint("API Response: $data");

        if (data != null) {
          demanderMachine.value = DemanderMachine.fromJson(data);
          await _fetchDetailedInfoForItems(token);
        } else {
          throw Exception('Response data is null');
        }
      } else {
        print('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchDetailedInfoForItems(String token) async {
    for (var vehicle in demanderMachine.value.vehicles ?? []) {
      await _fetchItemDetails(
              vehicle.matchId, 'construction-vehicle-order-matches', token)
          .then((data) {
        vehicle.updateFromDetailedData(data);
      });
    }

    for (var equipment in demanderMachine.value.equipments ?? []) {
      await _fetchItemDetails(
              equipment.matchId, 'construction-equipment-order-matches', token)
          .then((data) {
        equipment.updateFromDetailedData(data);
      });
    }

    for (var attachment in demanderMachine.value.attachments ?? []) {
      await _fetchItemDetails(attachment.matchId,
              'construction-attachment-order-matches', token)
          .then((data) {
        attachment.updateFromDetailedData(data);
      });
    }

    for (var transportVehicle
        in demanderMachine.value.transportationVehicles ?? []) {
      await _fetchItemDetails(transportVehicle.matchId,
              'transportation-vehicle-order-matches', token)
          .then((data) {
        transportVehicle.updateFromDetailedData(data);
      });
    }

    demanderMachine.refresh();
  }

  Future<Map<String, dynamic>?> _fetchItemDetails(
      int? matchId, String endpoint, String token) async {
    if (matchId == null) return null;
    final url = Uri.parse('${ApiLinkNames.server}/api/$endpoint/$matchId');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      debugPrint(
          "Error fetching details for $endpoint/$matchId: ${response.statusCode}");
      return null;
    }
  }
}

class DemanderMachine {
  List<Vehicle>? vehicles;
  List<Equipment>? equipments;
  List<Attachment>? attachments;
  List<TransportVehicle>? transportationVehicles;

  DemanderMachine({
    this.vehicles,
    this.equipments,
    this.attachments,
    this.transportationVehicles,
  });

  factory DemanderMachine.fromJson(Map<String, dynamic> json) {
    return DemanderMachine(
      vehicles: (json['vehicles'] as List<dynamic>?)
          ?.map((item) => Vehicle.fromJson(item))
          .toList(),
      equipments: (json['equipments'] as List<dynamic>?)
          ?.map((item) => Equipment.fromJson(item))
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((item) => Attachment.fromJson(item))
          .toList(),
      transportationVehicles:
          (json['transportation_vehicles'] as List<dynamic>?)
              ?.map((item) => TransportVehicle.fromJson(item))
              .toList(),
    );
  }
}

class Vehicle {
  String? brand;
  String? model;
  String? region;
  String? city;
  String? photoUrl;
  String? totalPrice;
  int? matchId;
  String? renterActivityStatus;

  Vehicle({
    this.brand,
    this.model,
    this.region,
    this.city,
    this.photoUrl,
    this.totalPrice,
    this.matchId,
    this.renterActivityStatus,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      matchId: json['match_id'],
      renterActivityStatus: json['renter_activity_status'],
    );
  }

  void updateFromDetailedData(Map<String, dynamic>? data) {
    if (data == null) return;
    region = data['construction_vehicle']?['region'] ?? 'Unknown Region';
    city = data['construction_vehicle']?['city'] ?? 'Unknown City';
    totalPrice = data['total_price'] ?? 'Unknown Price';
    photoUrl = constructImageUrl(data['order']?['sub_category']?['photo']);
    brand = data['construction_vehicle']?['brand'] ?? 'Unknown Brand';
    model = data['construction_vehicle']?['model'] ?? 'Unknown Model';
  }
}

// Similar classes for Equipment, Attachment, and TransportVehicle with appropriate data retrieval and update methods
class Equipment {
  String? brand;
  String? model;
  String? region;
  String? city;
  String? photoUrl;
  String? totalPrice;
  int? matchId;
  String? renterActivityStatus;

  Equipment({
    this.brand,
    this.model,
    this.region,
    this.city,
    this.photoUrl,
    this.totalPrice,
    this.matchId,
    this.renterActivityStatus,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      matchId: json['match_id'],
      renterActivityStatus: json['renter_activity_status'],
    );
  }

  void updateFromDetailedData(Map<String, dynamic>? data) {
    if (data == null) return;
    region = data['construction_equipment']?['region'] ?? 'Unknown Region';
    city = data['construction_equipment']?['city'] ?? 'Unknown City';
    totalPrice = data['total_price'] ?? 'Unknown Price';
    photoUrl = constructImageUrl(data['order']?['sub_category']?['photo']);
    brand = data['construction_equipment']?['brand'] ?? 'Unknown Brand';
    model = data['construction_equipment']?['model'] ?? 'Unknown Model';
  }
}

class Attachment {
  String? brand;
  String? model;
  String? region;
  String? city;
  String? photoUrl;
  String? totalPrice;
  int? matchId;
  String? renterActivityStatus;

  Attachment({
    this.brand,
    this.model,
    this.region,
    this.city,
    this.photoUrl,
    this.totalPrice,
    this.matchId,
    this.renterActivityStatus,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      matchId: json['match_id'],
      renterActivityStatus: json['renter_activity_status'],
    );
  }

  void updateFromDetailedData(Map<String, dynamic>? data) {
    if (data == null) return;
    region = data['construction_attachment']?['region'] ?? 'Unknown Region';
    city = data['construction_attachment']?['city'] ?? 'Unknown City';
    totalPrice = data['total_price'] ?? 'Unknown Price';
    photoUrl = constructImageUrl(data['order']?['sub_category']?['photo']);
    brand = data['construction_attachment']?['brand'] ?? 'Unknown Brand';
    model = data['construction_attachment']?['model'] ?? 'Unknown Model';
  }
}

class TransportVehicle {
  String? brand;
  String? model;
  String? region;
  String? city;
  String? photoUrl;
  String? totalPrice;
  int? matchId;
  String? renterActivityStatus;

  TransportVehicle({
    this.brand,
    this.model,
    this.region,
    this.city,
    this.photoUrl,
    this.totalPrice,
    this.matchId,
    this.renterActivityStatus,
  });

  factory TransportVehicle.fromJson(Map<String, dynamic> json) {
    return TransportVehicle(
      matchId: json['match_id'],
      renterActivityStatus: json['renter_activity_status'],
    );
  }

  void updateFromDetailedData(Map<String, dynamic>? data) {
    if (data == null) return;
    region = data['transportation_vehicle']?['region'] ?? 'Unknown Region';
    city = data['transportation_vehicle']?['city'] ?? 'Unknown City';
    totalPrice = data['total_price'] ?? 'Unknown Price';
    photoUrl = constructImageUrl(data['order']?['sub_category']?['photo']);
    brand = data['transportation_vehicle']?['brand'] ?? 'Unknown Brand';
    model = data['transportation_vehicle']?['model'] ?? 'Unknown Model';
  }
}

class DemanderItemStatusCard extends StatelessWidget {
  final String? imageUrl;
  final String brand;
  final String model;
  final String region;
  final String city;
  final String totalPrice;
  final String status;

  const DemanderItemStatusCard({
    Key? key,
    required this.imageUrl,
    required this.brand,
    required this.model,
    required this.region,
    required this.city,
    required this.totalPrice,
    required this.status,
  }) : super(key: key);

  Color getStatusColor(String status) {
    switch (status) {
      case 'in_work':
        return Colors.green;
      case 'in_service':
        return Colors.orange;
      case 'out_of_service':
        return Colors.red;
      case 'completed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            imageUrl != null && imageUrl!.startsWith("http")
                ? AppNetworkImage(imageUrl!,
                    width: 100, height: 100, fit: BoxFit.cover)
                : Image.asset('assets/images/demande/searching.png',
                    width: 100, height: 100, fit: BoxFit.cover),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$brand $model",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Region: $region"),
                  Text("City: $city"),
                  Text("Price: $totalPrice DZD"),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
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

// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/widgets/home/homepagelogo.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Demanderhome extends StatelessWidget {
//   const Demanderhome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(DemanderhomeControllerImp());
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: Get.width,
//           height: Get.height,
//           margin: const EdgeInsets.symmetric(vertical: 15),
//           child: Stack(
//             children: [
//               // NotificationIcon(),
//               ListView(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: HomepageLogo(),
//                   ),
//                   SizedBox(
//                     height: Get.height * .2,
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       "Vous n'avez pas commandez d'équipements, ajoutez le vôtre maintenant",
//                       textAlign: TextAlign.center,
//                       style:
//                           TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
//                     ),
//                   ),
//                   Image.asset(AppImageAsset.providerhomeEmpty),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//   }
//     );
// }
