// import 'package:flutter/material.dart';

// class CustomTextInput extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;

//   // Constructor to accept parameters
//   const CustomTextInput({
//     Key? key,
//     required this.controller,
//     required this.label,
//     required this.hint,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:hasad/controller/add/AttachmentSelectionScreen.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/widgets/home/add/customtitle.dart';
import 'package:hasad/widgets/home/add/smallheadline.dart';
import 'package:hasad/widgets/home/homepagelogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hasad/controller/add/addequipment_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class Addequipment extends StatefulWidget {
  const Addequipment({super.key});

  @override
  _AddequipmentState createState() => _AddequipmentState();
}

class _AddequipmentState extends State<Addequipment> {
  bool isPhoneSelected = false;

  String? imageUrl;
  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString('image_url');
    });
  }

  Future<String> _fetchPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("User is not authenticated.");
    }

    final response = await http.get(
      Uri.parse('${ApiLinkNames.server}/api/user-info'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if 'user' and 'phone' keys exist and return the phone number or an empty string
      if (data['user'] != null && data['user']['phone'] != null) {
        return data['user']['phone'];
      } else {
        // Return a default value or an empty string if phone is not found
        return 'No phone number available';
      }
    } else {
      throw Exception("Failed to load user information.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AddequipmentControllerImp());

    return WillPopScope(
      onWillPop: () async {
        await _clearCategoryData(); // Clear category data when back is pressed
        return true; // Allow navigation back
      },
      child: Scaffold(
        appBar: AppBar(
          title: const HomepageLogo(),
          automaticallyImplyLeading: false, // Removes the back arrow
        ),
        body: SafeArea(
          child: Container(
            width: Get.width,
            height: Get.height,
            margin:
                EdgeInsets.symmetric(horizontal: Get.width * .02, vertical: 5),
            child: Form(
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  const CustomTitle(number: "1", title: "Choisir la catégorie"),
                  const SizedBox(height: 10),
                  FutureBuilder<Map<String, String?>>(
                    future: _loadCategoryData(),
                    builder: (context, snapshot) {
                      // Check if snapshot has data
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        var data = snapshot.data!;
                        String label = data['label'] ?? "Choose Machine";
                        String? imagePath = data['imagePath'];
                        String? categoryId = data['category_id'];
                        String? subCategoryId = data['sub_category_id'];
                        int typeId = int.tryParse(data['type_id'] ?? '1') ??
                            1; // Ensure typeId is parsed correctly

                        String orderType = 'Unknown';

                        if (categoryId != null) {
                          int id = int.tryParse(categoryId) ?? -1;

                          // Determine order type based on typeId
                          if (typeId == 2) {
                            orderType = 'Equipment';
                          } else {
                            if (id >= 1 && id <= 8) {
                              orderType = 'Vehicle';
                            } else if (id == 9) {
                              orderType = 'Transportation';
                            } else if (id == 10) {
                              orderType = 'Attachment';
                            } else {
                              orderType = 'Equipment';
                            }
                          }
                        }

                        // Handle image URL and display info...
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AppNetworkImage(
                              imagePath ??
                                  'http://192.168.x.x:8000/storage/placeholder.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey);
                              },
                            ),
                          ),
                          title: Text(
                            label,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Category Type: $orderType\nCategory ID: $categoryId\nSub-Category ID: $subCategoryId',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        );
                      }

                      return const Text("No category selected.");
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.backgroundColor,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      Get.offNamed(AppRoutesNames
                          .addCategorieView); // Navigate to category selection
                    },
                    child: const Text("Choisir"),
                  ),
                  const SizedBox(height: 20),
                  const CustomTitle(number: "2", title: "Description"),
                  const SizedBox(height: 20),
                  _buildTextInput(Get.find<AddequipmentControllerImp>().marque,
                      "Marque", "Enter vehicle brand"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextInput(
                            Get.find<AddequipmentControllerImp>().model,
                            "Model",
                            "Enter vehicle model"),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: _buildTextInput(
                            Get.find<AddequipmentControllerImp>().annee,
                            "Année",
                            "Enter vehicle year"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const CustomTitle(number: "3", title: "Prix"),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextInput(
                            Get.find<AddequipmentControllerImp>().prixperjour,
                            "Prix par jour",
                            "Enter price per day"),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: _buildTextInput(
                            Get.find<AddequipmentControllerImp>().prixpermois,
                            "Prix par mois",
                            "Enter price per month"),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSelectField(
                          Get.find<AddequipmentControllerImp>().offerType,
                          "Type d'offre",
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: _buildTextInput(
                            Get.find<AddequipmentControllerImp>()
                                .transportPrice,
                            "Prix de transport",
                            "Enter transport price"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextInput(
                      Get.find<AddequipmentControllerImp>().operatorPrice,
                      "Prix de l'opérateur",
                      "Enter operator price"),
                  const SizedBox(height: 10),
                  const CustomTitle(number: "4", title: "Contact"),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColor.primaryColor,
                          ),
                          const Text('Location'),
                        ],
                      ),
                      Text("Utiliser votre position actuelle")
                    ],
                  ),

                  const SizedBox(height: 10),
                  _buildTextInput(Get.find<AddequipmentControllerImp>().region,
                      "Région", "Enter region"),
                  const SizedBox(height: 10),
                  _buildTextInput(Get.find<AddequipmentControllerImp>().city,
                      "Ville", "Enter city"),
                  const SizedBox(height: 20),

                  // Attachment Price Selection
                  Row(
                    children: [
                      Icon(Icons.phone_enabled, color: AppColor.primaryColor),
                      const Text('Numéro téléphone'),
                    ],
                  ),
                  FutureBuilder<String>(
                    future: _fetchPhoneNumber(), // Fetch user phone number
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('0549445167',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ));
                        // return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        String phoneNumber = snapshot.data!;
                        bool hasPhoneNumber = phoneNumber.isNotEmpty;

                        return StatefulBuilder(
                          // Use StatefulBuilder to manage state for the checkbox locally
                          builder: (context, setState) {
                            return Row(
                              children: [
                                Checkbox(
                                  value: hasPhoneNumber,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      hasPhoneNumber = value ??
                                          false; // Toggle the checkbox state
                                    });
                                  },
                                  activeColor: hasPhoneNumber
                                      ? AppColor.backgroundColor
                                      : Colors.grey,
                                ),
                                Text(
                                  hasPhoneNumber
                                      ? phoneNumber
                                      : 'Not Available',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Text("No phone number found.");
                      }
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<AddequipmentControllerImp>(
                        init: AddequipmentControllerImp(),
                        builder: (controller) {
                          int selectedCount =
                              controller.selectedAttachments.length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Text(
                              'Attachments selected: $selectedCount',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment
                            .centerLeft, // Align to the left, adjust as needed
                        child: GestureDetector(
                          onTap: () async {
                            _showAttachmentPopup(
                                context); // Show attachment pop-up
                          },
                          child: Container(
                            width: 120, // Set a fixed width for the button
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4), // Smaller padding
                            decoration: BoxDecoration(
                              color: AppColor.backgroundColor, // Button color
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 2), // Shadow position
                                ),
                              ],
                            ),
                            alignment: Alignment
                                .center, // Center the text within the container
                            child: const Text(
                              "Select",
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 12, // Smaller text
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

// Display selected attachments
                  GetBuilder<AddequipmentControllerImp>(
                    init:
                        AddequipmentControllerImp(), // Ensure the correct controller is used
                    builder: (controller) {
                      if (controller.selectedAttachments.isNotEmpty) {
                        return SizedBox(
                          height: 160, // Set a fixed height for the cards
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: controller.selectedAttachments.entries
                                  .map((entry) {
                                String attachmentName = entry.value['name']!;
                                String attachmentPrice = entry.value['price']!;
                                String? imagePath = entry.value[
                                    'imagePath']; // Assuming image path is here

                                // Use constructImageUrl() and print it
                                String? imageUrl = constructImageUrl(imagePath);
                                print(
                                    "Image URL for $attachmentName: $imageUrl");

                                return Container(
                                  width: 120,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      imageUrl != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: AppNetworkImage(
                                                imageUrl,
                                                height: 80,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  print(
                                                      "Failed to load image: $imageUrl"); // Log failed URLs
                                                  return Icon(
                                                    Icons.broken_image,
                                                    size: 80,
                                                    color: Colors.grey,
                                                  );
                                                },
                                              ),
                                            )
                                          : Icon(Icons.image,
                                              size: 80, color: Colors.grey),
                                      const SizedBox(height: 8),
                                      Text(
                                        attachmentName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Price: $attachmentPrice',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      } else {
                        return const Text(
                          "No attachments selected",
                          style: TextStyle(fontSize: 16),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  // Section for Photos
                  SmallHeadline(
                      subtitle: "Photos", icon: "assets/icons/photos.svg"),
                  InkWell(
                    onTap: () {
                      Get.find<AddequipmentControllerImp>()
                          .pickImage(); // Pick images from gallery
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          border: Border.all(color: AppColor.backgroundColor)),
                      child: GetBuilder<AddequipmentControllerImp>(
                        builder: (_) {
                          return Get.find<AddequipmentControllerImp>()
                                  .selectedPhotos
                                  .isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      Get.find<AddequipmentControllerImp>()
                                          .selectedPhotos
                                          .length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Image.file(
                                          Get.find<AddequipmentControllerImp>()
                                              .selectedPhotos[index],
                                          fit: BoxFit.cover),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: SvgPicture.asset(
                                      "assets/icons/addIcon.svg"),
                                );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Section for Documents
                  SmallHeadline(
                      subtitle: "Documents", icon: "assets/icons/doc.svg"),
                  InkWell(
                    onTap: () {
                      Get.find<AddequipmentControllerImp>()
                          .pickDocument(); // Pick documents (PDF or DOCX)
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        border: Border.all(color: AppColor.backgroundColor),
                      ),
                      child: GetBuilder<AddequipmentControllerImp>(
                        builder: (_) {
                          return Get.find<AddequipmentControllerImp>()
                                  .selectedDocuments
                                  .isNotEmpty
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      Get.find<AddequipmentControllerImp>()
                                          .selectedDocuments
                                          .length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        Get.find<AddequipmentControllerImp>()
                                            .selectedDocuments[index]
                                            .path
                                            .split('/')
                                            .last, // Show file name
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    );
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: SvgPicture.asset(
                                      "assets/icons/addIcon.svg"),
                                );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit and Cancel buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_validateForm(
                              Get.find<AddequipmentControllerImp>())) {
                            Get.find<AddequipmentControllerImp>()
                                .add(); // Submit data

                            // Navigate back to Providerhome but inside the context of Homepage
                            Get.offAllNamed(AppRoutesNames.homepage);
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill out all required fields correctly',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: const Text("Submit"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await _clearCategoryData();
                          // Navigate back to Providerhome but inside the context of Homepage
                          Get.offAllNamed(AppRoutesNames.homepage);
                        },
                        child: const Text("Cancel"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create text input fields
  Widget _buildTextInput(
      TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

// Helper function to create a dropdown select field
  Widget _buildSelectField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: controller.text.isEmpty ? null : controller.text,
        items: const [
          DropdownMenuItem(value: "Negotiable", child: Text("Negotiable")),
          DropdownMenuItem(value: "Fixed", child: Text("Fixed")),
        ],
        onChanged: (value) {
          controller.text = value!; // Update the controller with selected value
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // Validation for all fields
  bool _validateForm(AddequipmentControllerImp controller) {
    if (controller.marque.text.isEmpty ||
        controller.model.text.isEmpty ||
        controller.annee.text.isEmpty ||
        controller.prixperjour.text.isEmpty ||
        controller.prixpermois.text.isEmpty ||
        controller.offerType.text.isEmpty ||
        controller.transportPrice.text.isEmpty ||
        controller.operatorPrice.text.isEmpty ||
        controller.region.text.isEmpty ||
        controller.city.text.isEmpty ||
        controller.selectedAttachments.isEmpty || // Validate attachments
        controller.selectedPhotos.isEmpty || // Validate at least one photo
        controller.selectedDocuments.isEmpty) {
      // Validate at least one document
      return false;
    }
    return true;
  }

// In your method that shows the attachment popup
  Future<void> _showAttachmentPopup(BuildContext context) async {
    Map<String, Map<String, String>>? selectedAttachments =
        await showModalBottomSheet<Map<String, Map<String, String>>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Select Attachments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: AttachmentSelectionPopup(
                selectedAttachments:
                    Get.find<AddequipmentControllerImp>().selectedAttachments,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (Get.find<AddequipmentControllerImp>()
                    .selectedAttachments
                    .isNotEmpty) {
                  Navigator.pop(
                      context,
                      Get.find<AddequipmentControllerImp>()
                          .selectedAttachments);
                } else {
                  Get.snackbar(
                    'No Selection',
                    'No attachments selected',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.yellow,
                    colorText: Colors.black,
                  );
                }
              },
              child: const Text("Confirm Selection"),
            ),
          ],
        ),
      ),
    );

    // This part runs after the bottom sheet closes
    if (selectedAttachments != null && selectedAttachments.isNotEmpty) {
      Get.find<AddequipmentControllerImp>()
          .selectedAttachments
          .assignAll(selectedAttachments);
      Get.find<AddequipmentControllerImp>().update();
    } else {
      // Optional: handle the case where no attachments were selected
      print("No attachments were selected.");
    }
  }
}

// Load selected category and subcategory data from SharedPreferences
Future<Map<String, String?>> _loadCategoryData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? label = prefs.getString('label');
  String? imagePath = prefs.getString('imagePath');
  String? categoryId = prefs.getString('category_id');
  String? subCategoryId = prefs.getString('sub_category_id');
  int? typeId = prefs.getInt('typeId') ??
      1; // Fetch typeId from SharedPreferences (default to 1)

  // Print retrieved data for debugging
  print(
      "Loaded from SharedPreferences: label=$label, imagePath=$imagePath, categoryId=$categoryId, subCategoryId=$subCategoryId, typeId=$typeId");

  // Return the values in a map
  return {
    'label': label,
    'imagePath': imagePath,
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
    'type_id': typeId.toString(), // Store typeId as a string
  };
}

// Clear selected category and subcategory data from SharedPreferences
Future<void> _clearCategoryData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('category_id');
  await prefs.remove('id');
  await prefs.remove('label');
  print("Category data cleared.");
}
