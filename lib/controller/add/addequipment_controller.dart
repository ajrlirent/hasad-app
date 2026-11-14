import 'dart:async';
import 'dart:io';
import 'package:hasad/controller/add/AttachmentSelectionScreen.dart';
import 'package:hasad/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hasad/constant/ApiLinkNames.dart';

abstract class AddequipmentController extends GetxController {
  add(); // Abstract method for adding equipment, vehicle, or attachment
  Future<void> pickImage();
  Future<void> pickDocument();
  Future<void> requestPermissions();
}

class AddequipmentControllerImp extends AddequipmentController {
  // Controllers for input fields
  late TextEditingController marque;
  late TextEditingController model;
  late TextEditingController annee;
  late TextEditingController prixperjour;
  late TextEditingController prixpermois;
  late TextEditingController region;
  late TextEditingController city;
  late TextEditingController phone;
  late TextEditingController transportPrice;
  late TextEditingController operatorPrice;
  late TextEditingController offerType;
  String? selectedcat;
  RxMap<String, Map<String, String>> selectedAttachments =
      RxMap<String, Map<String, String>>();

  chooseCat(String chosencat) {
    selectedcat = chosencat;
    update();
  }

  // String? selectedcat;
  String? categoryId;
  String? subCategoryId;
  String? selectedCategoryLabel;

  bool ischecked1 = false;
  bool ischecked2 = false;

  List<File> selectedPhotos = [];
  List<File> selectedDocuments = [];
  // Map<String, String> selectedAttachments = {};

  @override
  void onInit() {
    super.onInit();
    marque = TextEditingController();
    model = TextEditingController();
    annee = TextEditingController();
    prixperjour = TextEditingController();
    prixpermois = TextEditingController();
    region = TextEditingController();
    city = TextEditingController();
    phone = TextEditingController();
    transportPrice = TextEditingController();
    operatorPrice = TextEditingController();
    offerType = TextEditingController();

    // Load the saved category and subcategory from SharedPreferences
    loadCategoryData();
  }

  @override
  void dispose() {
    marque.dispose();
    model.dispose();
    annee.dispose();
    prixperjour.dispose();
    prixpermois.dispose();
    region.dispose();
    city.dispose();
    phone.dispose();
    transportPrice.dispose();
    operatorPrice.dispose();
    offerType.dispose();
    super.dispose();
  }

  Future<Map<String, String?>> loadCategoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve values from SharedPreferences
    String? label = prefs.getString('label');
    String? imagePath = prefs.getString('image_url');
    String? categoryId = prefs.getString('category_id');
    String? subCategoryId = prefs.getString('sub_category_id');
    int? typeId = prefs.getInt('typeId');
    int? typelistId = prefs.getInt('typelistId'); // Load typelistId

    // Use typeId if typelistId is null
    if (typelistId == null && typeId != null) {
      typelistId = typeId;
      print("Debug: typelistId is null, defaulting to typeId = $typeId.");
    }

    // Assign values to instance variables
    this.categoryId = categoryId;
    this.subCategoryId = subCategoryId;
    this.selectedCategoryLabel = label;

    // Debug logs
    print('Debug: Loaded from SharedPreferences:');
    print('  label: $label');
    print('  imagePath: $imagePath');
    print('  category_id: $categoryId');
    print('  sub_category_id: $subCategoryId');
    print('  typeId: $typeId');
    print('  typelistId: $typelistId');

    update();

    return {
      'label': label,
      'imagePath': imagePath,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'type_id': typeId.toString(),
    };
  }

  @override
  Future<bool> add() async {
    try {
      // Load the category and subcategory data
      await loadCategoryData();

      // Validate required category and subcategory data
      if (categoryId == null || subCategoryId == null) {
        Get.snackbar(
          'Error',
          'Please select a valid category and subcategory.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Retrieve additional data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? typelistId = prefs.getInt('typelistId');
      int? typeId = prefs.getInt('typeId'); // Fallback if typelistId is null
      String? savedCategoryLabel = prefs.getString('category_label');

      // Ensure typelistId is set correctly
      if (typelistId == null) {
        typelistId =
            (categoryId == '10') ? 3 : typeId ?? 1; // Assume 3 for attachments
        print(
            "Debug: typelistId is null, defaulting based on categoryId or typeId.");
      }

      // Debugging logs
      print("Debug: typelistId = $typelistId");
      print("Debug: typeId = $typeId");
      print("Debug: categoryId = $categoryId");
      print("Debug: subCategoryId = $subCategoryId");
      print("Debug: savedCategoryLabel = $savedCategoryLabel");

      // Determine the action based on typelistId or category
      if (categoryId == '10' ||
          (savedCategoryLabel != null &&
              savedCategoryLabel.toLowerCase() == "attachement")) {
        print('Adding an Attachment...');
        return await _addAttachment();
      }

      switch (typelistId) {
        case 1:
          print('Adding a Vehicle...');
          return await _addVehicle(Get.context!);
        case 2:
          print('Adding Equipment...');
          return await _addEquipment();
        default:
          print('Invalid typelistId or category label');
          Get.snackbar(
            'Error',
            'Invalid category type. Please select a valid option.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return false;
      }
    } catch (e) {
      // Handle unexpected errors
      print('Exception: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  String getOfferTypeValue(String userSelection) {
    if (userSelection.toLowerCase() == "fixed") {
      return "fixed";
    } else if (userSelection.toLowerCase() == "negotiable") {
      return "negotiable";
    }
    return "";
  }

  Widget _buildOfferTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: offerType.text.isEmpty ? null : offerType.text,
      items: const [
        DropdownMenuItem(value: "fixed", child: Text("Fixed")),
        DropdownMenuItem(value: "negotiable", child: Text("Negotiable")),
      ],
      onChanged: (value) {
        offerType.text = value ?? "";
      },
      decoration: const InputDecoration(
        labelText: "Offer Type",
        border: OutlineInputBorder(),
      ),
    );
  }

  Future<bool> _addVehicle(BuildContext context) async {
    try {
      // Build the API request
      var uri = Uri.parse('${ApiLinkNames.server}/api/vehicles');
      var request = http.MultipartRequest('POST', uri);

      // Add required fields
      request.fields.addAll({
        'category_id': categoryId ?? '',
        'sub_category_id': subCategoryId ?? '',
        'brand': marque.text,
        'model': model.text,
        'year': annee.text,
        'price_per_day': prixperjour.text,
        'price_per_month': prixpermois.text,
        'offer_type': getOfferTypeValue(offerType.text),
        'transport_price': transportPrice.text,
        'region': region.text,
        'city': city.text,
        'phone_number': phone.text,
        'operator_price': operatorPrice.text, // Include operator price
      });

      // Add photos
      for (var photo in selectedPhotos) {
        request.files
            .add(await http.MultipartFile.fromPath('photos[]', photo.path));
      }

      // Add documents
      for (var document in selectedDocuments) {
        request.files.add(
            await http.MultipartFile.fromPath('documents[]', document.path));
      }

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${myServices.getToken()}',
      });

      // Send the request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Vehicle added successfully.');
        Get.snackbar(
          'Success',
          'Vehicle added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        print('Error adding vehicle: ${response.statusCode}');
        print('Response body: $responseBody');
        Get.snackbar(
          'Error',
          'Failed to add vehicle. Please check your input.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> _addAttachment() async {
    const String apiUrl = '${ApiLinkNames.server}/api/attachments';
    const timeoutDuration = Duration(minutes: 2); // Max timeout of 2 minutes
    const maxRetries = 3; // Retry up to 3 times
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        print('Debug: Attempt ${retryCount + 1} to send request to $apiUrl');

        var uri = Uri.parse(apiUrl);
        var request = http.MultipartRequest('POST', uri);

        request.fields.addAll({
          'sub_category_id': subCategoryId ?? '',
          'brand': marque.text,
          'model': model.text,
          'year': annee.text,
          'price_per_day': prixperjour.text,
          'price_per_month': prixpermois.text,
          'offer_type': getOfferTypeValue(offerType.text),
          'transport_price': transportPrice.text,
          'region': region.text,
          'city': city.text,
          'phone_number': phone.text,
          'operator_price': operatorPrice.text.isEmpty
              ? '0'
              : operatorPrice.text, // Default value
        });

        for (var i = 0; i < selectedPhotos.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'photos[]', selectedPhotos[i].path));
          print("Debug: Adding photo $i - ${selectedPhotos[i].path}");
        }

        for (var i = 0; i < selectedDocuments.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
              'documents[]', selectedDocuments[i].path));
          print("Debug: Adding document $i - ${selectedDocuments[i].path}");
        }

        request.headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer ${myServices.getToken()}',
        });

        print('Debug: Sending request to API');

        var response = await request.send().timeout(timeoutDuration);
        var responseBody = await response.stream.bytesToString();

        print('Response status: ${response.statusCode}');
        print('Response body: $responseBody');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Attachment added successfully.');
          Get.snackbar(
            'Success',
            'Attachment created successfully with ID: ${jsonDecode(responseBody)['id']}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          return true;
        } else {
          print('Error: $responseBody');
          Get.snackbar(
            'Error',
            'Failed to add attachment. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } on TimeoutException catch (e) {
        print('Debug: TimeoutException on attempt ${retryCount + 1} - $e');
        retryCount++;
        if (retryCount == maxRetries) {
          Get.snackbar(
            'Timeout',
            'Attachment request timed out after $maxRetries attempts. Please try again later.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        await Future.delayed(
            const Duration(seconds: 5)); // Delay before retrying
      } catch (e) {
        print('Debug: Exception - $e');
        Get.snackbar(
          'Error',
          'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }

    return false;
  }

  Future<bool> _addEquipment() async {
    try {
      // Validate fields before sending request
      if (subCategoryId == null || subCategoryId!.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Sub-category is required for Equipment.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      var uri = Uri.parse('${ApiLinkNames.server}/api/equipments');
      var request = http.MultipartRequest('POST', uri);

      // Add required fields
      request.fields.addAll({
        'category_id': categoryId ?? '',
        'sub_category_id': subCategoryId ?? '', // Ensure this is valid
        'brand': marque.text,
        'model': model.text,
        'year': annee.text,
        'price_per_day': prixperjour.text,
        'price_per_month': prixpermois.text,
        'offer_type': getOfferTypeValue(offerType.text),
        'transport_price': transportPrice.text,
        'region': region.text,
        'city': city.text,
        'phone_number': phone.text,
        'operator_price': operatorPrice.text,
      });

      // Add photos
      for (var photo in selectedPhotos) {
        request.files
            .add(await http.MultipartFile.fromPath('photos[]', photo.path));
      }

      // Add documents
      for (var document in selectedDocuments) {
        request.files.add(
            await http.MultipartFile.fromPath('documents[]', document.path));
      }

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${myServices.getToken()}',
      });

      // Send the request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Equipment added successfully.');
        Get.snackbar(
          'Success',
          'Equipment added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        print('Error adding equipment: ${response.statusCode}');
        print('Response body: $responseBody');
        Get.snackbar(
          'Error',
          'Failed to add equipment. Please check your input.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<void> _addFilesToRequest(http.MultipartRequest request) async {
    // Define maximum file size limit for each file (10 MB)
    const int maxFileSize = 10 * 1024 * 1024; // 10 MB in bytes

    // Notify the user that the upload is starting
    Get.snackbar('Uploading', 'Starting file upload...',
        snackPosition: SnackPosition.BOTTOM);

    // Track any files that are too large
    List<String> oversizedFiles = [];

    // Upload photos
    for (var i = 0; i < selectedPhotos.length; i++) {
      var file = selectedPhotos[i];
      int fileSize = await file.length();

      // Debug: Log each file's size
      print("Photo ${i + 1}: ${file.path}, Size: ${fileSize} bytes");

      // Check if the file size exceeds the per-file limit
      if (fileSize > maxFileSize) {
        oversizedFiles.add(file.path);
        print("Skipping photo ${i + 1} - file size exceeds 10 MB.");
        continue; // Skip this file if it is too large
      }

      // Add the file to the request
      request.files
          .add(await http.MultipartFile.fromPath('photos[]', file.path));
      Get.snackbar(
          'Uploading', 'Uploading photo ${i + 1} of ${selectedPhotos.length}',
          snackPosition: SnackPosition.BOTTOM);
    }

    // Upload documents
    for (var i = 0; i < selectedDocuments.length; i++) {
      var file = selectedDocuments[i];
      int fileSize = await file.length();

      // Debug: Log each file's size
      print("Document ${i + 1}: ${file.path}, Size: ${fileSize} bytes");

      // Check if the file size exceeds the per-file limit
      if (fileSize > maxFileSize) {
        oversizedFiles.add(file.path);
        print("Skipping document ${i + 1} - file size exceeds 10 MB.");
        continue; // Skip this file if it is too large
      }

      // Add the file to the request
      request.files
          .add(await http.MultipartFile.fromPath('documents[]', file.path));
      Get.snackbar('Uploading',
          'Uploading document ${i + 1} of ${selectedDocuments.length}',
          snackPosition: SnackPosition.BOTTOM);
    }

    // Notify the user if any files were too large
    if (oversizedFiles.isNotEmpty) {
      Get.snackbar(
        'Error',
        'Some files exceeded the 10 MB limit and were not uploaded:\n' +
            oversizedFiles.join('\n'),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );
    } else {
      // Notify the user that all files were added successfully
      Get.snackbar('Success', 'All files added to the upload request.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _sendRequest(http.MultipartRequest request) async {
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer ${myServices.getToken()}',
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success: $responseData');
        Get.snackbar(
          'Success',
          'Data submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 422) {
        print('Validation Error: ${decodedResponse['errors']}');
        Get.snackbar(
          'Validation Error',
          'Please check your input: ${decodedResponse['errors']}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response body: $responseData');
        Get.snackbar(
          'Error',
          'Failed to submit data: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickImage() async {
    await requestPermissions();
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      selectedPhotos.addAll(images.map((image) => File(image.path)).toList());
    }
    update();
  }

  Future<void> pickDocument() async {
    await requestPermissions();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      File selectedFile = File(result.files.single.path!);
      selectedDocuments.add(selectedFile);
    } else {
      Get.snackbar('Invalid File', 'Please select a valid PDF or DOCX file.',
          snackPosition: SnackPosition.BOTTOM);
    }
    update();
  }

  Future<void> requestPermissions() async {
    var storageStatus = await Permission.storage.request();
    var cameraStatus = await Permission.camera.request();

    if (!storageStatus.isGranted || !cameraStatus.isGranted) {
      Get.snackbar('Permissions Required',
          'Storage and camera permissions are required to upload files.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

// abstract class AddequipmentController extends GetxController {
//   add();
// }

// class AddequipmentControllerImp extends AddequipmentController {
//   late TextEditingController marque;
//   late TextEditingController model;
//   late TextEditingController annee;
//   late TextEditingController prixperjour;
//   late TextEditingController prixpermois;
//   late TextEditingController region;
//   late TextEditingController city;

//   bool ischecked1 = false;
//   bool ischecked2 = false;

//   String offre = "";

//   @override
//   add() {}
//   String? selectedcat;
// chooseCat(String chosencat) {
//   selectedcat = chosencat;
//   update();
// }

//   @override
//   void onInit() {
//     super.onInit();
//     marque = TextEditingController();
//     model = TextEditingController();
//     annee = TextEditingController();
//     prixperjour = TextEditingController();
//     prixpermois = TextEditingController();
//     region = TextEditingController();
//     city = TextEditingController();
//   }

//   @override
//   void dispose() {
//     marque.dispose();
//     model.dispose();
//     annee.dispose();
//     prixperjour.dispose();
//     prixpermois.dispose();
//     region.dispose();
//     city.dispose();
//     super.dispose();
//   }
// }
