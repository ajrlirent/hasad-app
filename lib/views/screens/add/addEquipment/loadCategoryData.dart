// // category_data_service.dart

// import 'package:shared_preferences/shared_preferences.dart';

// /// Load selected category and subcategory data from SharedPreferences
// Future<Map<String, String?>> loadCategoryData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   String? label = prefs.getString('label');
//   String? imagePath = prefs.getString('imagePath');
//   String? categoryId = prefs.getString('category_id');
//   String? subCategoryId = prefs.getString('sub_category_id');
//   int? typeId = prefs.getInt('typeId') ??
//       1; // Fetch typeId from SharedPreferences (default to 1)

//   // Print retrieved data for debugging
//   print(
//       "Loaded from SharedPreferences: label=$label, imagePath=$imagePath, categoryId=$categoryId, subCategoryId=$subCategoryId, typeId=$typeId");

//   // Return the values in a map
//   return {
//     'label': label,
//     'imagePath': imagePath,
//     'category_id': categoryId,
//     'sub_category_id': subCategoryId,
//     'type_id': typeId.toString(), // Store typeId as a string
//   };
// }

// /// Clear selected category and subcategory data from SharedPreferences
// Future<void> clearCategoryData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove('category_id');
//   await prefs.remove('id');
//   await prefs.remove('label');
//   print("Category data cleared.");
// }
