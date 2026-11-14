import 'package:hasad/data/datasource/remote/provider/providerdata.dart';
import 'package:hasad/data/models/providermachines.dart';
import 'package:get/get.dart';

abstract class ProviderhomeController extends GetxController {
  updateService(bool isactive);
}

class ProviderhomeControllerImp extends ProviderhomeController {
  bool inservice = false;

  @override
  updateService(bool isactive) {
    inservice = isactive;
    update();
  }

  var providerMachine = ProviderMachineModel(
    equipments: [],
    vehicles: [],
    attachments: [],
  ).obs;

  var isLoading = true.obs;
  final Providerdata _apiService = Providerdata();

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void updateActivityStatus(int id, String type, String newStatus) {
    if (type == "equipment") {
      final index = providerMachine.value.equipments!
          .indexWhere((equipment) => equipment.id == id);
      if (index != -1) {
        providerMachine.value.equipments![index].activityStatus = newStatus;
      }
    } else if (type == "vehicle") {
      final index = providerMachine.value.vehicles!
          .indexWhere((vehicle) => vehicle.id == id);
      if (index != -1) {
        providerMachine.value.vehicles![index].activityStatus = newStatus;
      }
    } else if (type == "attachment") {
      final index = providerMachine.value.attachments!
          .indexWhere((attachment) => attachment.id == id);
      if (index != -1) {
        providerMachine.value.attachments![index].activityStatus = newStatus;
      }
    }

    // Notify listeners to update the UI
    providerMachine.refresh();
  }

  void fetchData() async {
    try {
      isLoading(true);
      var data = await _apiService.fetchData();
      print('Server Response: $data'); // Debugging the response
      providerMachine.value = data;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
