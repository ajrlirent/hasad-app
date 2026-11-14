// import 'package:hasad/data/datasource/static/static.dart';
// import 'package:hasad/data/models/categoriesmodel.dart';
// import 'package:get/get.dart';

// abstract class ItemsController extends GetxController {
//   displayItems(int catid);
//   displayCats(int typeid);
// }

// class ItemsControllerImp extends ItemsController {
//   late int selectedcat;
//   late int selectedType;
//   List<ItemsModel> selectedCatItems = [];
//   List<CategoriesModel> selectedCats = [];

//   @override
//   displayItems(int catid) {
//     if (selectedCatItems.isNotEmpty) {
//       selectedCatItems.clear();
//     }
//     for (var item in items) {
//       if (item.catId == catid) {
//         selectedCatItems.add(item);
//       }
//     }
//     update();
//   }

//   @override
//   void onInit() async {
//     selectedcat = 1;
//     selectedType = Get.arguments["typeId"];
//     await displayCats(selectedType);
//     displayItems(selectedcat);
//     super.onInit();
//   }

//   @override
//   displayCats(int typeid) {
//     if (selectedCats.isNotEmpty) {
//       selectedCats.clear();
//     }
//     for (var cat in catlist) {
//       if (cat.typeId == typeid) {
//         selectedCats.add(cat);
//       }
//     }
//     update();
//   }
// }
import 'package:hasad/data/datasource/static/static.dart';
import 'package:hasad/data/models/categoriesmodel.dart';
import 'package:hasad/data/models/itemsmodel.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hasad/constant/ApiLinkNames.dart';

abstract class ItemsController extends GetxController {
  displayItems(int catid);
  displayCats(int typeid);
}

class ItemsControllerImp extends ItemsController {
  late int selectedcat;
  late int selectedType;
  List<ItemsModel> selectedCatItems = [];
  List<CategoriesModel> selectedCats = [];

  @override
  void onInit() async {
    selectedcat = 1; // Default selected category ID
    selectedType = Get.arguments["typeId"];
    await displayCats(selectedType);
    // displayItems(selectedcat);
    await displayItems(selectedcat); // Fetch items after displaying categories
    super.onInit();
  }

  // @override
  // displayItems(int catid) {
  //   // Clear previous items
  //   if (selectedCatItems.isNotEmpty) {
  //     selectedCatItems.clear();
  //   }

  //   // Check selected category and filter items accordingly
  //   for (var item in items) {
  //     if (item.catId == catid) {
  //       selectedCatItems.add(item);
  //     }
  //   }

  //   update();
  // }

  @override
  Future<void> displayCats(int typeid) async {
    try {
      selectedCats.clear(); // Clear previous categories
      if (typeid == 1) {
        var vehicleCategories =
            await fetchCategories('${ApiLinkNames.server}/api/vehicle-categories');
        selectedCats.addAll(vehicleCategories);
      } else if (typeid == 2) {
        var equipmentCategories = await fetchCategories(
            '${ApiLinkNames.server}/api/equipment-categories');
        selectedCats.addAll(equipmentCategories);
      }
      update(); // Call update after changing categories
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Future<void> displayItems(int catid) async {
    try {
      selectedCatItems.clear(); // Clear previous items

      String apiUrl;
      // Determine the correct API URL based on the selected type
      if (selectedType == 1) {
        // Vehicle categories
        apiUrl = '${ApiLinkNames.server}/api/vehicle-categories/$catid';
      } else if (selectedType == 2) {
        // Equipment categories
        apiUrl = '${ApiLinkNames.server}/api/equipment-categories/$catid';
      } else {
        throw Exception('Invalid category type');
      }

      var items = await fetchItems(apiUrl);
      selectedCatItems.addAll(items);

      update(); // Notify the UI to update
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<List<ItemsModel>> fetchItems(String url) async {
    var dio = Dio();
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      List<ItemsModel> items = [];
      for (var item in response.data) {
        items.add(
            ItemsModel.fromJson(item)); // Ensure you have a fromJson method
      }
      return items;
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<List<CategoriesModel>> fetchCategories(String url) async {
    var dio = Dio();
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      List<CategoriesModel> categories = [];
      for (var item in response.data) {
        categories.add(CategoriesModel.fromJson(item));
      }
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
