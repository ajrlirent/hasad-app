import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/data/models/demendermachines.dart';

import 'package:hasad/data/models/providermachines.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class Demanderdata {
  final Dio _dio = Dio();
  final MyServices myServices = Get.find();

  Future<DemanderMachineModel> fetchData() async {
    try {
      final response = await _dio.get(
        ApiLinkNames.demanderMachines,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${myServices.getToken()}',
          },
        ),
      );
      if (response.statusCode == 200) {
        return DemanderMachineModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
