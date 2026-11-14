// import 'dart:io';

// import 'package:hasad/constant/ApiLinkNames.dart';
// import 'package:hasad/data/models/equipmentorderpayload.dart';
// import 'package:dio/dio.dart';

// class EquipmentorderData {
//   final Dio _dio = Dio();

//   Future<void> submitEquipmentOrder(
//       EquipmentOrderPayload payload, String token) async {
//     try {
//       final response = await _dio.post(
//         ApiLinkNames.submitEquipmentOrder,
//         data: payload.toJson(),
//         options: Options(
//           validateStatus: (status) {
//             // Accept all status codes, including 302
//             return status != null && status < 500;
//           },
//           followRedirects: false,
//           contentType: "json",
//           responseType: ResponseType.plain,
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       if (response.statusCode == 302) {
//         // Handle the redirection manually if necessary
//         final redirectUrl =
//             response.headers.value(ApiLinkNames.submitEquipmentOrder);
//         if (redirectUrl != null) {
//           await _dio.get(redirectUrl); // Follow the redirect
//         }
//       }
//       if (response.statusCode != 200 || response.statusCode != 201) {
//         print(response.statusCode);
//         print(response.headers);

//         throw Exception('Failed to submit equipment order');
//       }
//     } catch (e) {
//       print(e);
//       throw Exception('Server error: $e');
//     }
//   }
// }
