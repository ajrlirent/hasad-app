// import 'package:hasad/controller/command/command_controller.dart';
// import 'package:hasad/widgets/home/backbtnlogo.dart';
// import 'package:hasad/widgets/home/command/body.dart';
// import 'package:hasad/widgets/home/command/buttonsrow.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CommandDetails extends GetView<CommandControllerImp> {
//   const CommandDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => CommandControllerImp());

//     // Retrieve the order data passed from NotificaitonScreenDemander
//     final dynamic order = Get.arguments['order'];

//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           height: Get.height,
//           width: Get.width,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: ListView(
//             physics: const BouncingScrollPhysics(),
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(top: 15.0),
//                 child: Backbtnlogo(),
//               ),
//               CommandBody(order: order), // Pass the order data to CommandBody
//               const ButtonsRow()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:hasad/widgets/home/command/body.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

class CommandDetails extends StatefulWidget {
  const CommandDetails({Key? key}) : super(key: key);

  @override
  _CommandDetailsState createState() => _CommandDetailsState();
}

class _CommandDetailsState extends State<CommandDetails> {
  late Future<Map<String, dynamic>> _orderDataFuture;

  @override
  void initState() {
    super.initState();
    final String categoryType = Get.arguments['categoryType'];
    final int orderId = Get.arguments['order']['id'];
    _orderDataFuture = fetchOrderData(categoryType, orderId);
  }

  Future<Map<String, dynamic>> fetchOrderData(
      String categoryType, int id) async {
    String baseUrl = '${ApiLinkNames.server}/api';
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token is null. Please login again.');
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response =
        await http.get(Uri.parse(baseUrl + endpoint), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['construction_vehicle']?['offer_type'] == 'negotiable') {
        data['can_negotiate'] = true;
      } else {
        data['can_negotiate'] = false;
      }

      data['categoryType'] = categoryType;
      return data;
    } else {
      throw Exception(
          'Failed to load order data. Status Code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.offAllNamed(AppRoutesNames.homepage),
              child: Container(
                // padding: const EdgeInsets.only(left: 16),
                child: Image.asset(AppImageAsset.logowithbackbtn,
                  width: 80, // Moderate width
                  // height: 60, // Moderate height
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _orderDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return CommandBody(orderData: snapshot.data!);
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
