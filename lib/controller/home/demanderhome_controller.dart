// import 'package:get/get.dart';

// abstract class DemanderhomeController extends GetxController {
//   updateService(bool isactive);
// }

// class DemanderhomeControllerImp extends DemanderhomeController {
//   late bool inservice;
//   @override
//   void onInit() {
//     super.onInit();
//     inservice = false;
//     update();
//   }

//   @override
//   updateService(bool isactive) {
//     inservice = isactive;
//     update();
//   }
// }
import 'package:hasad/data/datasource/remote/demander/demanderdata.dart';
import 'package:hasad/data/models/demendermachines.dart';
import 'package:get/get.dart';

abstract class DemanderhomeController extends GetxController {
  updateService(bool isactive);
}

class DemanderhomeControllerImp extends DemanderhomeController {
  bool inservice = false;

  @override
  updateService(bool isactive) {
    inservice = isactive;
    update();
  }

  var demanderMachine = DemanderMachineModel(
    equipments: [],
    vehicles: [],
    attachments: [],
    transportationVehicles: [],
  ).obs;

  var isLoading = true.obs;
  final Demanderdata _apiService = Demanderdata();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    try {
      isLoading(true);
      var data = await _apiService.fetchData();
      print('Server Response: ${data.toJson()}'); // Log full response
      print('Equipments count: ${data.equipments?.length}');
      print('Vehicles count: ${data.vehicles?.length}');
      print('Attachments count: ${data.attachments?.length}');
      print(
          'Transportation Vehicles count: ${data.transportationVehicles?.length}');
      demanderMachine.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
