import 'package:hasad/constant/ApiLinkNames.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class UserService {
//   // Fetch image URL from SharedPreferences
//   Future<String?> loadImageUrl() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('image_url');
//   }

//   // Fetch phone number from API
//   Future<String> fetchPhoneNumber() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     if (token == null) {
//       throw Exception("User is not authenticated.");
//     }

//     final response = await http.get(
//       Uri.parse('${ApiLinkNames.server}/api/user-info'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['user']?['phone'] ?? 'No phone number available';
//     } else {
//       throw Exception("Failed to load user information.");
//     }
//   }
// }
