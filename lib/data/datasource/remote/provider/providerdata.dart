import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/controller/auth/login_controller.dart';

import 'package:hasad/data/models/providermachines.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class Providerdata {
  final Dio _dio = Dio();
  final MyServices myServices = Get.find();

  Future<ProviderMachineModel> fetchData() async {
    try {
      final response = await _dio.get(
        ApiLinkNames.providerMachines,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${myServices.getToken()}',
          },
        ),
      );
      if (response.statusCode == 200) {
        return ProviderMachineModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
