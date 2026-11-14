import 'dart:io';

import 'package:hasad/controller/command/command_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/data/datasource/static/static.dart';
import 'package:hasad/widgets/home/command/buttonsrow.dart';
import 'package:hasad/widgets/home/command/imagepagedotscontroller.dart';
import 'package:hasad/widgets/home/command/commandinfos.dart';
import 'package:hasad/widgets/home/command/facturetotal.dart';
import 'package:hasad/widgets/home/command/imagepagesslider.dart';
import 'package:hasad/widgets/home/command/plusdetails.dart';
import 'package:hasad/widgets/home/command/selectedattachments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class CommandBody extends GetView<CommandControllerImp> {
//   const CommandBody({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: Get.height * .80,
//       margin: const EdgeInsets.only(top: 5),
//       width: Get.width,
//       child: ListView(
//         children: [
//           SizedBox(
//             height: 250,
//             width: 120,
//             child: Image.asset(
//               AppImageAsset.pleteuse,
//               fit: BoxFit.contain,
//             ),
//           ),
//           const Divider(
//             color: AppColor.backgroundColor,
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Text(
//               "Mini pelle",
//               style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
//             ),
//           ),
//           const CommandInfos(
//             field: "Capacité",
//             value: "60",
//           ),
//           const CommandInfos(
//             field: "Quantité",
//             value: "1",
//           ),
//           const CommandInfos(
//             field: "demandedureetext",
//             value: "14 Jours",
//           ),
//           const CommandInfos(
//             field: "demandedureetext3",
//             value: "26/06/2024 à 14/07/2024",
//           ),
//           const CommandInfos(
//             field: "Opérateur :",
//             value: "Avec",
//           ),
//           const CommandInfos(
//             field: "commandHeuretext",
//             value: "66:30",
//           ),
//           const CommandInfos(
//             field: "Transport :",
//             value: "Oui",
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           const Text(
//             "attachements",
//             style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//           ),
// SelectedAttachemtns(
//   data: attachments,
// ),
//           Text(
//             "Facture :",
//             style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//           ),
//           const PlusDetails(
//             details:
//                 '"Je souhaiterais louer une excavatrice pour le chantier, mais veuillez noter que la route d\'accès est un peu étroite, donc une machine compacte serait préférable."',
//           ),
//           SizedBox(
//             width: Get.width * .7,
//             height: 250,
//             child: const ImagePagesSlider(data: [
//               'assets/images/commandimage.png',
//               'assets/images/commandimage.png',
//               'assets/images/commandimage.png'
//             ]),
//           ),
//           const ImagepageDotsController(
//             data: [
//               'assets/images/commandimage.png',
//               'assets/images/commandimage.png',
//               'assets/images/commandimage.png'
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             "Facture :",
//             style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//           ),
//           const CommandInfos(
//             field: "Prix par jour ",
//             value: "12 000 DZD ",
//           ),
//           const CommandInfos(
//             field: "Durée",
//             value: "14 Jours",
//           ),
//           const CommandInfos(
//             field: "Opérateur :",
//             value: "0 DZD",
//           ),
//           const CommandInfos(
//             field: "Transport :",
//             value: "4 550 DZD",
//           ),
//           const CommandInfos(
//             field: "attachements",
//             value: "3500 DZD",
//           ),
//           const FactureTotal(),
//         ],
//       ),
//     );
//   }
// }
// old code
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hasad/widgets/home/command/commandinfos.dart';
// import 'package:hasad/widgets/home/command/selectedattachments.dart';
// import 'package:hasad/widgets/home/command/facturetotal.dart';
// import 'package:hasad/widgets/home/command/imagepagedotscontroller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/widgets/home/command/imagepagesslider.dart';

// class CommandBody extends StatelessWidget {
//   final Map<String, dynamic> orderData;

//   const CommandBody({super.key, required this.orderData});

//   @override
//   Widget build(BuildContext context) {
//     // Print full orderData for debugging purposes
//     print("Full orderData: $orderData");

//     final constructionVehicle = orderData['construction_vehicle'] ?? {};
//     final orderDetails = orderData['order'] ?? {};
//     final subCategory = orderDetails['sub_category'] ??
//         {}; // Fix: Access sub_category from orderDetails
//     final List<dynamic> attachments = orderDetails['attachments'] ?? [];

//     // Print the subCategory to check if it contains the 'photo' key
//     print("subCategory: $subCategory");

//     // Safely retrieve the photo path
//     final String? imageUrl = subCategory['photo'] != null
//         ? '${ApiLinkNames.server}/${subCategory['photo']}'
//         : null;

//     // If photo path is null, print a message
//     if (imageUrl == null) {
//       print("Photo path is null for this order");
//     } else {
//       print("Photo path: $imageUrl");
//     }

//     final String title = subCategory['label'] ?? 'Unknown Vehicle';
//     final String capacity = orderDetails['capacity']?.toString() ?? 'N/A';
//     final String quantity = orderDetails['quantity']?.toString() ?? 'N/A';
//     final String duration = orderDetails['duration']?.toString() ?? 'N/A';
//     final String startDate = orderDetails['start_date'] ?? 'N/A';
//     final String endDate = orderDetails['end_date'] ?? 'N/A';
//     final String operator = orderDetails['operator'] == 1 ? 'Avec' : 'Sans';
//     final String transport =
//         orderDetails['transport'] == 'by_us' ? 'Oui' : 'Non';
//     final String pricePerDay =
//         orderData['price_per_day']?.toString() ?? '0 DZD';
//     final String transportPrice =
//         orderData['transport_price']?.toString() ?? '0 DZD';
//     final String operatorPrice =
//         orderData['operator_price']?.toString() ?? '0 DZD';
//     final String totalPrice = orderData['total_price']?.toString() ?? '0 DZD';

//     // Safely retrieve the list of photos
//     final List<dynamic> photos = orderDetails['photos'] ?? [];

//     return Container(
//       height: Get.height * .80,
//       margin: const EdgeInsets.only(top: 5),
//       width: Get.width,
//       child: ListView(
//         children: [
//           // Display Image
//           SizedBox(
//             height: 250,
//             width: 120,
//             child: imageUrl != null && imageUrl.isNotEmpty
//                 ? AppNetworkImage(
//                     // Replace 'public/' with 'storage/' for the correct image path
//                     imageUrl.replaceFirst('public/', 'storage/'),
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) {
//                       print('Error loading image: $imageUrl');
//                       return Image.asset(
//                           'assets/images/no_image_available.png');
//                     },
//                   )
//                 : Image.asset(
//                     'assets/images/no_image_available.png',
//                     fit: BoxFit.contain,
//                   ),
//           ),

//           const Divider(color: AppColor.backgroundColor),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
//             ),
//           ),
//           CommandInfos(field: "Capacité", value: capacity),
//           CommandInfos(field: "Quantité", value: quantity),
//           CommandInfos(field: "Durée", value: '$duration Jours'),
//           CommandInfos(field: "Date", value: '$startDate à $endDate'),
//           CommandInfos(field: "Opérateur :", value: operator),
//           CommandInfos(field: "Transport :", value: transport),
//           const SizedBox(height: 10),
//           const Text(
//             "Attachements",
//             style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//           ),
//           // Display attachments if available
//           // SelectedAttachemtns(data: attachments),
//           const Divider(color: AppColor.backgroundColor),
//           const Text(
//             "Détails supplémentaires :",
//             style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(orderDetails['more_details'] ?? 'Aucun détail fourni'),
//           ),
//           // Image slider for additional images
//           if (photos.isNotEmpty)
//             SizedBox(
//               width: Get.width * .7,
//               height: 250,
//               child: ImagePagesSlider(
//                 data: [
//                   'public/hasad_machines/vehicles/machine_de_terrassement/micro_pelle.png',
//                   'public/construction_vehicle_orders/photos/oSairIaUZ4BAJ2hC6q5xO3f7XREPm1mewgyRqkXK.jpg'
//                 ],
//               ),
//             ),
//           if (photos.isNotEmpty) ImagepageDotsController(data: photos),
//           const Divider(color: AppColor.backgroundColor),
//           const Text(
//             "Facture :",
//             style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//           ),
//           CommandInfos(field: "Prix par jour ", value: "$pricePerDay DZD"),
//           CommandInfos(field: "Transport :", value: "$transportPrice DZD"),
//           CommandInfos(field: "Opérateur :", value: "$operatorPrice DZD"),
//           FactureTotal(totalPrice: totalPrice),
//         ],
//       ),
//     );
//   }
// }import 'package:flutter/material.dart';import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class CommandBody extends StatefulWidget {
  final Map<String, dynamic>? orderData;

  const CommandBody({Key? key, required this.orderData}) : super(key: key);

  @override
  _CommandBodyState createState() => _CommandBodyState();
}

class _CommandBodyState extends State<CommandBody> {
  late Map<String, TextEditingController> controllers; // Manage controllers
  late Map<String, dynamic> factureData; // Facture data
  int _currentPage = 0;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final PageController _pageController = PageController();
  late TextEditingController capacityController;
  late TextEditingController quantityController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController hourController;
  late TextEditingController pricePerDayController;
  late TextEditingController operatorPriceController;
  late TextEditingController transportPriceController;
  late TextEditingController moreDetailsController;
  late TextEditingController priceController;
  late TextEditingController durationController;

  late TextEditingController attachmentsMachineController;
  bool operatorStatus = false;
  bool isLoading = false;
  String transportMethod = 'by_yourself';
  String? model;
  String? brand;
  String? transport;
  String? year;

  @override
  void initState() {
    controllers = {
      'prixTotal': TextEditingController(),
      'duration': TextEditingController(),
      'operatorPrice': TextEditingController(),
      'pricePerDay': TextEditingController(),
      'transportPrice': TextEditingController(),
    };
    // Fetch facture data and populate controllers
    fetchFactureData();
    super.initState();
    fetchFactureData(); // Fetch data when the screen initializes
    _initializeFactureFields();
    _initializeControllers(widget.orderData);
    operatorStatus = widget.orderData?['order']?['operator'] == 1;
    transportMethod = widget.orderData?['order']?['transport'] ?? 'by_yourself';
    _fetchConstructionVehicleDetails();
  }

  Future<void> fetchFactureData() async {
    try {
      // Simulating an API response
      final response = {
        'total_price': '1743.50',
        'duration': '7',
        'operator_price': '200.00',
        'price_per_day': '220.50',
        'transport_price': '0.00',
      };

      setState(() {
        factureData = response;
        // Populate controllers with data
        controllers['prixTotal']?.text = response['total_price']!;
        controllers['duration']?.text = response['duration']!;
        controllers['operatorPrice']?.text = response['operator_price']!;
        controllers['pricePerDay']?.text = response['price_per_day']!;
        controllers['transportPrice']?.text = response['transport_price']!;
      });
    } catch (e) {
      print('Error fetching facture data: $e');
    }
  }

  void _fetchConstructionVehicleDetails() {
    if (widget.orderData != null) {
      print("Full orderData: ${widget.orderData}"); // Debugging

      // Try to extract vehicle or equipment data
      final String categoryType = widget.orderData?['categoryType'] ?? '';
      dynamic vehicleData;

      // Handling different categories to extract relevant data
      switch (categoryType) {
        case "Construction Vehicle":
          vehicleData = widget.orderData?['construction_vehicle'];
          break;
        case "Construction Equipment":
          vehicleData = widget.orderData?['construction_equipment'];
          break;
        case "Transportation Vehicle":
          vehicleData = widget.orderData?['transportation_vehicle'];
          break;
        case "Construction Attachment":
          vehicleData = widget.orderData?['construction_attachment'];
          break;
      }

      if (vehicleData != null) {
        setState(() {
          model = vehicleData['model']?.toString();
          brand = vehicleData['brand']?.toString();
          year = vehicleData['year']?.toString();
        });
        print("Fetched Model: $model, Brand: $brand, Year: $year"); // Debugging
      } else {
        print("No $categoryType data found"); // Debugging
      }

      // Safely accessing `order` data
      final orderData = widget.orderData?['order'];
      if (orderData != null) {
        setState(() {
          transport = orderData['transport']?.toString();
        });
        print("Fetched Transport: $transport"); // Debugging
      } else {
        print("No order data found"); // Debugging
      }
    }
  }

  void _initializeFactureFields() {
    priceController = TextEditingController(
      text: widget.orderData?['total_price']?.toString() ?? '',
    );
    durationController = TextEditingController(
      text: widget.orderData?['order']?['duration']?.toString() ?? '',
    );
    operatorPriceController = TextEditingController(
      text: widget.orderData?['operator_price']?.toString() ?? '',
    );
    transportPriceController = TextEditingController(
      text: widget.orderData?['transport_price']?.toString() ?? '',
    );
    attachmentsMachineController = TextEditingController(
      text: widget.orderData?['attachments'] != null
          ? (widget.orderData!['attachments'] as List).length.toString()
          : '0',
    );
  }

  void _initializeControllers(Map<String, dynamic>? orderData) {
    capacityController = TextEditingController(
        text: orderData?['order']?['capacity']?.toString() ?? '');
    quantityController = TextEditingController(
        text: orderData?['order']?['quantity']?.toString() ?? '');
    startDateController =
        TextEditingController(text: orderData?['order']?['start_date'] ?? '');
    endDateController =
        TextEditingController(text: orderData?['order']?['end_date'] ?? '');
    hourController = TextEditingController(
        text: orderData?['order']?['hour']?.toString() ?? '');
    pricePerDayController = TextEditingController(
        text: orderData?['price_per_day']?.toString() ?? '');
    operatorPriceController = TextEditingController(
        text: orderData?['operator_price']?.toString() ?? '');
    transportPriceController = TextEditingController(
        text: orderData?['transport_price']?.toString() ?? '');
    moreDetailsController =
        TextEditingController(text: orderData?['order']?['more_details'] ?? '');
  }

  @override
  void dispose() {
    capacityController.dispose();
    quantityController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    hourController.dispose();
    pricePerDayController.dispose();
    operatorPriceController.dispose();
    transportPriceController.dispose();
    moreDetailsController.dispose();
    _pageController.dispose();
    priceController.dispose();
    durationController.dispose();
    operatorPriceController.dispose();
    transportPriceController.dispose();
    attachmentsMachineController.dispose();
    // Dispose controllers
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _refreshOrderData() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String categoryType = widget.orderData?['categoryType'] ?? '';
      int? id = widget.orderData?['order']?['id'];

      if (id == null || token == null || categoryType.isEmpty) {
        return;
      }

      String endpoint = '';
      if (categoryType == "Construction Vehicle") {
        endpoint = '/construction-vehicle-order-matches/$id';
      } else if (categoryType == "Transportation Vehicle") {
        endpoint = '/transportation-vehicle-order-matches/$id';
      } else if (categoryType == "Construction Equipment") {
        endpoint = '/construction-equipment-order-matches/$id';
      } else if (categoryType == "Construction Attachment") {
        endpoint = '/construction-attachment-order-matches/$id';
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse('${ApiLinkNames.server}/api' + endpoint),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> updatedOrderData = json.decode(response.body);
        setState(() {
          widget.orderData?.addAll(updatedOrderData);
          _initializeControllers(updatedOrderData);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? categoryType = widget.orderData?['categoryType'];

    if (factureData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    if (widget.orderData == null) {
      return const Center(child: Text("No order data available"));
    }

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildHeader(
                    widget.orderData?['order']?['sub_category']?['label'] ??
                        'Unknown Vehicle',
                    widget.orderData?['order']?['sub_category'] ?? {},
                    widget.orderData?['order']?['photos'] ?? [],
                  ),
                  const Divider(),
                  _buildEDetails(),
                  const SizedBox(
                    height: 50,
                  ),
                  _buildProviderDetails(context),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildEFacture(),
                  const Divider(),
                  _buildActionButtons(),
                ],
              ),
              if (isLoading)
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String machineLabel, Map<String, dynamic> subCategory,
      List<dynamic>? photosList) {
    final photoUrl = subCategory['photo'] != null
        ? '${ApiLinkNames.server}/${subCategory['photo'].replaceFirst('public/', 'storage/')}'
        : null;

    List<String> photosUrls = photosList != null
        ? photosList.map<String>((photo) {
            final photoPath =
                '${ApiLinkNames.server}/${(photo as Map<String, dynamic>)['path'].replaceFirst('public/', 'storage/')}';
            return photoPath;
          }).toList()
        : [];

    final List<String> imageUrls = [
      if (photoUrl != null) photoUrl,
      ...photosUrls,
    ];

    return Column(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: imageUrls.isNotEmpty
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: imageUrls.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final imageUrl = imageUrls[index];
                    return AppNetworkImage(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                            'assets/images/no_image_available.png');
                      },
                    );
                  },
                )
              : Image.asset('assets/images/no_image_available.png'),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: imageUrls.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColor.backgroundColor,
            dotColor: Colors.grey,
            expansionFactor: 3, // Controls expansion of active dot
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            machineLabel,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildEDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8), // Space between title and container
          Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.backgroundColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Text("Model: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(model ?? "N/A",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text("Brand: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(brand ?? "N/A",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text("Transport: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(transport ?? "N/A",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text("Year: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(year ?? "N/A",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEFacture() {
    if (factureData == null) {
      return Center(child: CircularProgressIndicator());
    }

    String? categoryType = widget.orderData?['categoryType'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Facture",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8), // Space between title and container
          Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.backgroundColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Common fields for all categories
                _buildEditableRow(
                  "Prix Total",
                  TextEditingController(
                    text: factureData?['total_price']?.toString() ?? '',
                  ),
                ),
                _buildEditableRow(
                  "Durée",
                  TextEditingController(
                    text: widget.orderData?['order']?['duration']?.toString() ??
                        '',
                  ),
                ),
                _buildEditableRow(
                  "Opérateur",
                  TextEditingController(
                    text: factureData?['operator_price']?.toString() ?? '',
                  ),
                ),

                // Hour selector with time picker
                _buildHourSelector(),

                // Conditional fields for specific categories
                if (categoryType == "Construction Vehicle" ||
                    categoryType == "Transportation Vehicle" ||
                    categoryType == "Construction Equipment") ...[
                  _buildEditableRow(
                    "Prix par jour",
                    TextEditingController(
                      text: factureData?['price_per_day']?.toString() ?? '',
                    ),
                  ),
                  _buildEditableRow(
                    "Prix de l'opérateur",
                    TextEditingController(
                      text: factureData?['operator_price']?.toString() ?? '',
                    ),
                  ),
                ],

                // Specific fields for Construction Vehicle and Construction Equipment
                if (categoryType == "Construction Vehicle" ||
                    categoryType == "Construction Equipment")
                  _buildEditableRow(
                    "Prix de transport",
                    TextEditingController(
                      text: factureData?['transport_price']?.toString() ?? '',
                    ),
                  ),

                // Specific fields for Transportation Vehicle
                if (categoryType == "Transportation Vehicle") ...[
                  _buildEditableRow(
                    "Équipements",
                    TextEditingController(
                      text: widget.orderData?['order']?['attachments'] ?? '',
                    ),
                  ),
                  _buildEditableRow(
                    "Votre besoin",
                    TextEditingController(text: "Par jour"),
                  ),
                  _buildEditableRow(
                    "Lieu de départ",
                    TextEditingController(
                      text: widget.orderData?['order']?['departure_location'] ??
                          '',
                    ),
                  ),
                  _buildEditableRow(
                    "Lieu d'arrivée",
                    TextEditingController(
                      text:
                          widget.orderData?['order']?['arrival_location'] ?? '',
                    ),
                  ),
                  _buildEditableRow(
                    "Prix de la distance",
                    TextEditingController(
                      text:
                          widget.orderData?['price_of_distance']?.toString() ??
                              '',
                    ),
                  ),
                ],

                // Additional field for Construction Vehicle, Construction Equipment, and Construction Attachment
                if (categoryType == "Construction Vehicle" ||
                    categoryType == "Construction Equipment" ||
                    categoryType == "Construction Attachment")
                  _buildEditableRow(
                    "Transport",
                    TextEditingController(
                      text: widget.orderData?['order']?['transport'] ?? '',
                    ),
                  ),

                // Specific field for all categories if applicable
                _buildEditableRow(
                  "Attachments machine",
                  TextEditingController(
                    text: widget.orderData?['order']?['attachments'] ?? '',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: hourController,
              decoration: InputDecoration(
                labelText: "Hour",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              readOnly: true,
              onTap: () async {
                // Open time picker dialog
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                // Format the picked time
                if (picked != null) {
                  final now = DateTime.now();
                  final formattedTime = DateFormat('H:mm').format(
                    DateTime(now.year, now.month, now.day, picked.hour,
                        picked.minute),
                  );

                  // Set formatted time to the controller
                  setState(() {
                    hourController.text = formattedTime;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.access_time),
            onPressed: () async {
              // Open time picker dialog when clock icon is pressed
              TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              // Format the picked time
              if (picked != null) {
                final now = DateTime.now();
                final formattedTime = DateFormat('H:mm').format(
                  DateTime(
                      now.year, now.month, now.day, picked.hour, picked.minute),
                );

                // Set formatted time to the controller
                setState(() {
                  hourController.text = formattedTime;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  // Widget _buildEditableRow(String label, TextEditingController controller) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4.0),
  //     child: Row(
  //       children: [
  //         Text(
  //           "$label: ",
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(width: 10),
  //         Expanded(
  //           child: TextField(
  //             controller: controller,
  //             decoration: InputDecoration(
  //               border: OutlineInputBorder(),
  //               isDense: true,
  //             ),
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEditableRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          SizedBox(
            width: 150,
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(Map<String, dynamic>? order) {
    final String duration = order?['duration']?.toString() ?? 'N/A';
    final String startDate = order?['start_date'] ?? 'N/A';
    final String endDate = order?['end_date'] ?? 'N/A';
    final String operator = order?['operator'] == 1 ? 'Avec' : 'Sans';
    final String transport = order?['transport'] == 'by_us' ? 'Oui' : 'Non';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Détails de la commande:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildDetailRow('Durée', '$duration jours'),
        _buildDetailRow('Date de début', startDate),
        _buildDetailRow('Date de fin', endDate),
        _buildDetailRow('Opérateur', operator),
        _buildDetailRow('Transport', transport),
      ],
    );
  }

  Widget _buildOperatorField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Opérateur',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Switch(
          value: operatorStatus,
          onChanged: (value) {
            setState(() {
              operatorStatus = value;
            });
          },
        ),
        Text(operatorStatus ? "Avec" : "Sans",
            style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final formattedTime = DateFormat('H:m').format(
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute));

      setState(() {
        hourController.text = formattedTime;
      });
    }
  }

  Widget _buildInvoiceSection(bool canNegotiate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Facture',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildEditableField('Prix par jour', pricePerDayController),
        _buildEditableField('Prix opérateur', operatorPriceController),
        _buildEditableField('Prix transport', transportPriceController),
        _buildTransportMethod(),
      ],
    );
  }

  Widget _buildTransportMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transport',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          DropdownButton<String>(
            value: transportMethod,
            onChanged: (String? newValue) {
              setState(() {
                transportMethod = newValue!;
              });
            },
            items: <String>['by_yourself', 'by_us']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                    value == 'by_yourself' ? 'Par vous-même' : 'Par nos soins'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget _buildProviderDetails(Map<String, dynamic>? provider) {
  //   String providerName = provider?['first_name'] ?? 'Unknown';
  //   String providerCity = provider?['city'] ?? 'Unknown';

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text('Détails du fournisseur:',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //       const SizedBox(height: 10),
  //       _buildDetailRow('Nom', providerName),
  //       _buildDetailRow('Ville', providerCity),
  //     ],
  //   );
  // }
  Widget _buildProviderDetails(BuildContext context) {
    final provider = widget.orderData?['provider'] ?? {};
    return Padding(
      padding: const EdgeInsets.only(top: 25), // Extra top padding to make room
      child: Stack(
        clipBehavior: Clip.none, // Allows overflow outside the Stack
        alignment: Alignment.topCenter,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.orange, width: 2),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 100, // Space for Positioned container
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  // Provider name
                  Text(
                    '${provider['first_name'] ?? 'N/A'} ${provider['last_name'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // User type
                  Text(
                    provider['user_type'] == 'provider_individual'
                        ? 'Individu'
                        : 'Société',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Phone number
                  Text(
                    provider['phone'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Rating row (hardcoded as placeholder)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '4.7 (385 avis)',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -25, // Keeps the offset you want
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.backgroundColor,
                  width: 2,
                ),
              ),
              child: provider['profile_picture'] != null &&
                      provider['profile_picture'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppNetworkImage(
                        '${ApiLinkNames.server}/storage/${provider['profile_picture'].replaceFirst('public/', '')}',
                        height: 100,
                        width: 150, // Ensure width is also defined
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/images/attachement.png',
                      height: 50,
                      width: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _handleAccepter,
            child: const Text('Accepter', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _handleModifier,
            child: const Text('Modifier', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _handleAnnuler,
            child: const Text('Annuler', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _handleAccepter() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String categoryType = widget.orderData?['categoryType'] ?? '';
      int? id = widget.orderData?['order']?['id'];

      if (token == null || categoryType.isEmpty || id == null) {
        throw Exception('Token, CategoryType, or ID is missing');
      }

      String endpoint = '';

      if (categoryType == "Construction Vehicle") {
        endpoint = '/construction-vehicle-order-matches/accept/$id';
      } else if (categoryType == "Transportation Vehicle") {
        endpoint = '/transportation-vehicle-order-matches/accept/$id';
      } else if (categoryType == "Construction Equipment") {
        endpoint = '/construction-equipment-order-matches/accept/$id';
      } else if (categoryType == "Construction Attachment") {
        endpoint = '/construction-attachment-order-matches/accept/$id';
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.put(
        Uri.parse('${ApiLinkNames.server}/api' + endpoint),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Order accepted successfully!')),
        );
        _refreshOrderData(); // Refresh the order data after accepting
      } else {
        throw Exception(
            'Failed to accept the order. Status Code: ${response.statusCode}, Response: ${response.reasonPhrase}');
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Failed to accept the order: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _handleModifier() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      String? categoryType = widget.orderData?['categoryType'];
      int? id = widget.orderData?['order']?['id'];

      if (id == null || categoryType == null) return;

      String endpoint = '';
      if (categoryType == "Construction Vehicle") {
        endpoint = '/construction-vehicle-order-matches/negotiate/$id';
      } else if (categoryType == "Transportation Vehicle") {
        endpoint = '/transportation-vehicle-order-matches/negotiate/$id';
      } else if (categoryType == "Construction Equipment") {
        endpoint = '/construction-equipment-order-matches/negotiate/$id';
      } else if (categoryType == "Construction Attachment") {
        endpoint = '/construction-attachment-order-matches/negotiate/$id';
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token')?.trim();

      if (token == null) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content:
                Text('Authentication token not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      print("Using token: $token"); // Debug statement for the token

      String formattedHour;
      try {
        DateTime parsedHour = DateFormat("HH:mm").parse(hourController.text);
        formattedHour = DateFormat("H:mm").format(parsedHour);
      } catch (e) {
        print("Hour formatting error: $e");
        formattedHour = "Invalid Format";
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print("Headers: $headers $id"); // Debugging headers

      Map<String, String> formData = {
        'operator': operatorStatus ? '1' : '0',
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'more_details': moreDetailsController.text,
        'hour': formattedHour,
        'transport': transportMethod,
        'capacity': capacityController.text,
        'quantity': quantityController.text,
      };

      if (categoryType == "Construction Vehicle") {
        formData['price_per_day'] = pricePerDayController.text;
        formData['operator_price'] = operatorPriceController.text;
        formData['transport_price'] = transportPriceController.text;
      } else if (categoryType == "Transportation Vehicle") {
        formData['price_per_day'] = pricePerDayController.text;
        formData['operator_price'] = operatorPriceController.text;
        formData['price_of_distance'] =
            widget.orderData?['price_of_distance']?.toString() ?? '';
        formData['departure_location'] =
            widget.orderData?['order']?['departure_location'] ?? '';
        formData['arrival_location'] =
            widget.orderData?['order']?['arrival_location'] ?? '';
        formData['equipments'] = attachmentsMachineController.text;
      } else if (categoryType == "Construction Equipment") {
        formData['price_per_day'] = pricePerDayController.text;
        formData['operator_price'] = operatorPriceController.text;
        formData['transport_price'] = transportPriceController.text;
      } else if (categoryType == "Construction Attachment") {
        formData['price_per_day'] = pricePerDayController.text;
        formData['transport_price'] = transportPriceController.text;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiLinkNames.server}/api' + endpoint),
      );

      request.fields.addAll(formData);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('Order modified successfully!')),
        );
      } else if (response.statusCode == 401) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Unauthorized: Please check your login credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Failed to modify the order: $responseBody'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _handleAnnuler() {
    Navigator.pop(context);
  }
}
