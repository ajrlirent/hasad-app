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

  Future<String?> _fetchPhoneNumber() async {
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
      if (data['phone'] != null) {
        return data['phone']; // Return the phone number
      }
      return null; // Return null if phone number is not found
    } else {
      throw Exception("Failed to fetch user information.");
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
              child: FutureBuilder<Map<String, String?>>(
                future:
                    Get.find<AddequipmentControllerImp>().loadCategoryData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data!;
                    String label = data['label'] ?? "Choose Machine";
                    String? imagePath = data['imagePath'];
                    String? categoryId = data['category_id'];
                    String? subCategoryId = data['sub_category_id'];
                    int typeId = int.tryParse(data['type_id'] ?? '1') ?? 1;

                    String orderType = 'Unknown';
                    if (typeId == 2) {
                      orderType = 'Equipment';
                    } else {
                      int id = int.tryParse(categoryId ?? '-1') ?? -1;

                      if (id >= 1 && id <= 8) {
                        orderType = 'Vehicle';
                      } else if (id == 9) {
                        orderType = 'Transportation';
                      } else if (id == 10) {
                        orderType = 'Attachment';
                      } else {
                        orderType = 'Unknown'; // Catch unexpected cases
                      }
                    }

                    return ListView(
                      children: [
                        const SizedBox(height: 20),
                        const CustomTitle(
                            number: "1", title: "Choisir la catégorie"),
                        const SizedBox(height: 10),
                        ListTile(
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
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.backgroundColor,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onPressed: () {
                            Get.offNamed(AppRoutesNames.addCategorieView);
                          },
                          child: const Text("Choisir"),
                        ),
                        const SizedBox(height: 20),
                        const CustomTitle(number: "2", title: "Description"),
                        const SizedBox(height: 20),
                        _buildTextInput(
                            Get.find<AddequipmentControllerImp>().marque,
                            "Marque",
                            "Enter vehicle brand"),
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
                                  Get.find<AddequipmentControllerImp>()
                                      .prixperjour,
                                  "Prix par jour",
                                  "Enter price per day"),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: _buildTextInput(
                                  Get.find<AddequipmentControllerImp>()
                                      .prixpermois,
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
                            const SizedBox(width: 5),
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

                        // Hide Operator Price if orderType == 'Attachment'
                        if (orderType != 'Attachment')
                          _buildTextInput(
                              Get.find<AddequipmentControllerImp>()
                                  .operatorPrice,
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
                        _buildTextInput(
                            Get.find<AddequipmentControllerImp>().region,
                            "Région",
                            "Enter region"),
                        const SizedBox(height: 10),
                        _buildTextInput(
                            Get.find<AddequipmentControllerImp>().city,
                            "Ville",
                            "Enter city"),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildPhoneNumberSelector(context),
                            const SizedBox(height: 20),
                          ],
                        ),

                        // Attachment Price Selection
                        // Row(
                        //   children: [
                        //     Icon(Icons.phone_enabled,
                        //         color: AppColor.primaryColor),
                        //     const Text('Numéro téléphone'),
                        //   ],
                        // ),
                        // FutureBuilder<String>(
                        //   future:
                        //       _fetchPhoneNumber(), // Fetch user phone number
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState ==
                        //         ConnectionState.waiting) {
                        //       return const CircularProgressIndicator();
                        //     } else if (snapshot.hasError) {
                        //       return Text('0549445167',
                        //           style: TextStyle(
                        //             color: Colors.red,
                        //             fontSize:
                        //                 MediaQuery.of(context).size.width *
                        //                     0.04,
                        //           ));
                        //       // return Text('Error: ${snapshot.error}');
                        //     } else if (snapshot.hasData &&
                        //         snapshot.data != null) {
                        //       String phoneNumber = snapshot.data!;
                        //       bool hasPhoneNumber = phoneNumber.isNotEmpty;

                        //       return StatefulBuilder(
                        //         // Use StatefulBuilder to manage state for the checkbox locally
                        //         builder: (context, setState) {
                        //           return Row(
                        //             children: [
                        //               Checkbox(
                        //                 value: hasPhoneNumber,
                        //                 onChanged: (bool? value) {
                        //                   setState(() {
                        //                     hasPhoneNumber = value ??
                        //                         false; // Toggle the checkbox state
                        //                   });
                        //                 },
                        //                 activeColor: hasPhoneNumber
                        //                     ? AppColor.backgroundColor
                        //                     : Colors.grey,
                        //               ),
                        //               Text(
                        //                 hasPhoneNumber
                        //                     ? phoneNumber
                        //                     : 'Not Available',
                        //                 style: TextStyle(fontSize: 16),
                        //               ),
                        //             ],
                        //           );
                        //         },
                        //       );
                        //     } else {
                        //       return const Text("No phone number found.");
                        //     }
                        //   },
                        // ),

                        const SizedBox(height: 10),

                        // Hide attachments section if orderType == 'Equipment' or 'Attachment'
                        if (orderType != 'Equipment' &&
                            orderType != 'Attachment')
                          Column(
                            children: [
                              GetBuilder<AddequipmentControllerImp>(
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
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () async {
                                    _showAttachmentPopup(context);
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColor.backgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Select",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),

                        const SizedBox(height: 10),

                        // Photos Section
                        SmallHeadline(
                            subtitle: "Photos",
                            icon: "assets/icons/photos.svg"),
                        InkWell(
                          onTap: () async {
                            await Get.find<AddequipmentControllerImp>()
                                .pickImage();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              border:
                                  Border.all(color: AppColor.backgroundColor),
                            ),
                            child: GetBuilder<AddequipmentControllerImp>(
                              builder: (controller) {
                                return controller.selectedPhotos.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            controller.selectedPhotos.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Image.file(
                                              controller.selectedPhotos[index],
                                              fit: BoxFit.cover,
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
                        const SizedBox(height: 10),

                        // Documents Section
                        SmallHeadline(
                            subtitle: "Documents",
                            icon: "assets/icons/doc.svg"),
                        InkWell(
                          onTap: () {
                            Get.find<AddequipmentControllerImp>()
                                .pickDocument(); // Pick documents
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              border:
                                  Border.all(color: AppColor.backgroundColor),
                            ),
                            child: GetBuilder<AddequipmentControllerImp>(
                              builder: (controller) {
                                return controller.selectedDocuments.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            controller.selectedDocuments.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              controller
                                                  .selectedDocuments[index].path
                                                  .split('/')
                                                  .last,
                                              style:
                                                  const TextStyle(fontSize: 12),
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
                                final controller =
                                    Get.find<AddequipmentControllerImp>();

                                // Validation logic
                                if (['Vehicle', 'Equipment']
                                        .contains(orderType) &&
                                    controller.operatorPrice.text.isEmpty) {
                                  Get.snackbar(
                                    'Validation Error',
                                    'Operator price is required for this order type.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                if (controller.selectedDocuments.isEmpty) {
                                  Get.snackbar(
                                    'Validation Error',
                                    'Please attach at least one document.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                // Call the add method after validation
                                controller.add();
                              },
                              child: const Text("Submit"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _clearCategoryData();
                                Get.offAllNamed(AppRoutesNames.homepage);
                              },
                              child: const Text("Cancel"),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return const Center(child: Text("No category selected."));
                },
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: controller.text.isEmpty ? null : controller.text,
        // Let the dropdown shrink to the field width instead of overflowing
        // with "RIGHT OVERFLOWED BY X PIXELS" in the Prix section.
        isExpanded: true,
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

  Widget buildPhoneNumberSelector(BuildContext context) {
    return FutureBuilder<String?>(
      future: _fetchPhoneNumber(), // Fetch the phone number
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            'Failed to load phone number',
            style: TextStyle(
              color: Colors.red,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final phoneNumber = snapshot.data!;
          final controller = Get.find<AddequipmentControllerImp>();
          controller.phone.text =
              phoneNumber; // Set phone number in the controller

          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone Number:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.phone,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your phone number',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Allow user to edit the phone number if needed
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          return const Text('No phone number found.');
        }
      },
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

Future<void> saveCategorySelection(String categoryId, String subCategoryId,
    String label, String imagePath) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('category_id', categoryId);
  await prefs.setString('sub_category_id', subCategoryId); // Save subCategoryId
  await prefs.setString('label', label);
  await prefs.setString('imagePath', imagePath);

  // Debugging: Print the saved values
  print("Saved to SharedPreferences:");
  print("  category_id=$categoryId");
  print("  sub_category_id=$subCategoryId");
  print("  label=$label");
  print("  imagePath=$imagePath");
}

// Load selected category and subcategory data from SharedPreferences
// Future<Map<String, String?>> _loadCategoryData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   String? label = prefs.getString('label');
//   String? imagePath = prefs.getString('image_url');
//   String? categoryId = prefs.getString('category_id');
//   String? subCategoryId = prefs.getString('sub_category_id');
//   int? typeId = prefs.getInt('typeId') ?? 1;

//   // Debugging: Print all retrieved values
//   print("Loaded from SharedPreferences:");
//   print("  label=$label");
//   print("  imagePath=$imagePath");
//   print("  category_id=$categoryId");
//   print("  sub_category_id=$subCategoryId");
//   print("  typeId=$typeId");

//   return {
//     'label': label,
//     'imagePath': imagePath,
//     'category_id': categoryId,
//     'sub_category_id': subCategoryId,
//     'type_id': typeId.toString(),
//   };
// }

// Clear selected category and subcategory data from SharedPreferences
Future<void> _clearCategoryData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('category_id');
  await prefs.remove('id');
  await prefs.remove('label');
  print("Category data cleared.");
}

// import 'package:hasad/controller/add/addequipment_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:hasad/widgets/auth/signup/clientdocsection.dart';
// import 'package:hasad/widgets/home/add/ajouteattachmenttext.dart';
// import 'package:hasad/widgets/home/add/attachmentbottomsheet.dart';
// import 'package:hasad/widgets/home/add/checkphoneno.dart';
// import 'package:hasad/widgets/home/add/customtitle.dart';
// import 'package:hasad/widgets/home/add/descriptionsection.dart';
// import 'package:hasad/widgets/home/add/localisationfromgps.dart';

// import 'package:hasad/widgets/home/add/prixsection.dart';
// import 'package:hasad/widgets/home/add/smallheadline.dart';
// import 'package:hasad/widgets/home/backbtnlogo.dart';
// import 'package:hasad/widgets/home/providerhome/provider_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Addequipment extends GetView<AddequipmentControllerImp> {
//   const Addequipment({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => AddequipmentControllerImp());
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: Get.width,
//           height: Get.height,
//           margin:
//               EdgeInsets.symmetric(horizontal: Get.width * .02, vertical: 5),
//           child: Form(
//             child: ListView(
//               children: [
//                 const Backbtnlogo(),
//                 const SizedBox(height: 20),
//                 Text(
//                   "addequipmentHeadline1".tr,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w700, fontSize: 20),
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTitle(
//                   number: "1",
//                   title: "addequipmentFirstsec".tr,
//                 ),
//                 const SizedBox(height: 10),
//                 FutureBuilder<Map<String, String?>>(
//                   future: _loadCategoryData(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     }

//                     var data = snapshot.data!;
//                     String? label = data['label'];

//                     return ListTile(
//                       title: Text(
//                         label ?? "Choisir la categorie",
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                     );
//                   },
//                 ),
//                 // Button to choose another category
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor
//                         .backgroundColor, // Set your desired background color here
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                   ),
//                   onPressed: () {
//                     Get.offNamed(AppRoutesNames.addCategorieView);
//                   },
//                   child: const Text("Choisir une autre catégorie"),
//                 ),
//                 // Additional UI components...
//                 CustomTitle(
//                   number: "2",
//                   title: "addequipmentSecondsec".tr,
//                 ),
//                 const SizedBox(height: 20),
//                 DescriptionSection(controller: controller),
//                 CustomTitle(
//                   number: "3",
//                   title: "addequipmentThirdsec".tr,
//                 ),
//                 const SizedBox(height: 10),
//                 const PrixSection(),
//                 const SizedBox(height: 10),
//                 CustomTitle(
//                   number: "4",
//                   title: "addequipmentFourthsec".tr,
//                 ),
//                 const SizedBox(height: 5),
//                 SmallHeadline(
//                   subtitle: "addequipmentSmallheadline1".tr,
//                   icon: AppImageAsset.locationIcon,
//                 ),
//                 const SizedBox(height: 5),
//                 const LocalisationfromGPS(),
//                 const SizedBox(height: 10),
//                 CustomTextfield(() {},
//                     icon: "",
//                     hinttext: "localisationregionhint".tr, isvalid: (v) {
//                   return null;
//                 }, mycontroller: controller.region),
//                 const SizedBox(height: 10),
//                 Container(
//                     margin: EdgeInsets.only(right: Get.width * .5),
//                     child: CustomTextfield(() {},
//                         icon: "",
//                         hinttext: "localisationcityhint".tr, isvalid: (v) {
//                       return null;
//                     }, mycontroller: controller.city)),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: SmallHeadline(
//                     subtitle: "addequipmentSmallheadline2".tr,
//                     icon: AppImageAsset.phoneIcon,
//                   ),
//                 ),
//                 CheckPhoneNumber(
//                     phone: "0699 17 45 56", checker: controller.ischecked1),
//                 CheckPhoneNumber(
//                   phone: "0555 55 55 55",
//                   checker: controller.ischecked2,
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(right: Get.width * .5),
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: -4),
//                           backgroundColor: Colors.transparent,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                               side: const BorderSide(
//                                   color: AppColor.secondaryColor, width: 2),
//                               borderRadius: BorderRadius.circular(10))),
//                       onPressed: () {},
//                       child: Row(
//                         children: [
//                           Transform.scale(
//                               scale: 2,
//                               child: SvgPicture.asset(AppImageAsset.penIcon)),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             "phonebookbtntext".tr,
//                             style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColor.secondaryColor),
//                           )
//                         ],
//                       )),
//                 ),
//                 const SizedBox(height: 10),
//                 const AjouteAttachmentText(),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           elevation: 5,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 10),
//                           backgroundColor: AppColor.backgroundColor,
//                           foregroundColor: AppColor.primaryColor),
//                       onPressed: () {
//                         showModalBottomSheet(
//                             context: context,
//                             builder: (context) {
//                               return const AttachmentBottomsheet();
//                             });
//                       },
//                       child: const Text(
//                         "Selectionner des attachements",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                 ),
//                 const SizedBox(height: 10),
//                 CustomTitle(number: "5", title: "addequipmentFifthsec".tr),
//                 const SizedBox(height: 10),
//                 SmallHeadline(
//                     subtitle: "addequipmentSmallheadline3".tr,
//                     icon: AppImageAsset.photosIcon),
//                 InkWell(
//                   radius: 40,
//                   splashColor: const Color.fromARGB(118, 250, 136, 23),
//                   onTap: () {},
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 60),
//                     height: 130,
//                     width: 44,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(23),
//                         border: Border.all(color: AppColor.backgroundColor)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(40),
//                       child: SvgPicture.asset(
//                         AppImageAsset.addpicture,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 SmallHeadline(
//                     subtitle: "addequipmentSmallheadline4".tr,
//                     icon: AppImageAsset.docIcon),
//                 InkWell(
//                   radius: 40,
//                   splashColor: const Color.fromARGB(118, 250, 136, 23),
//                   onTap: () {},
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 60),
//                     height: 130,
//                     width: 44,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(23),
//                         border: Border.all(color: AppColor.backgroundColor)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(40),
//                       child: SvgPicture.asset(
//                         AppImageAsset.addpicture,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 AddEquipmentBtn(
//                   prompt: "addequipmentbtntext".tr,
//                   onpressed: () => Get.offNamed(AppRoutesNames.addSuccess),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<Map<String, String?>> _loadCategoryData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return {
//       'id': prefs.getString('id'),
//       'category_id': prefs.getString('category_id'),
//       'label': prefs.getString('label'),
//     };
//   }
// }import 'dart:io';
// import 'package:hasad/widgets/home/add/ajouteattachmenttext.dart';
// import 'package:hasad/widgets/home/add/attachmentbottomsheet.dart';
// import 'package:hasad/widgets/home/add/checkphoneno.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart' as dio; // Aliased import
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:hasad/controller/add/addequipment_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:hasad/widgets/home/add/customtitle.dart';
// import 'package:hasad/widgets/home/add/descriptionsection.dart';
// import 'package:hasad/widgets/home/add/localisationfromgps.dart';
// import 'package:hasad/widgets/home/add/prixsection.dart';
// import 'package:hasad/widgets/home/add/smallheadline.dart';
// import 'package:hasad/widgets/home/backbtnlogo2.dart';

// class Addequipment extends GetView<AddequipmentControllerImp> {
//   const Addequipment({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => AddequipmentControllerImp());
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: Get.width,
//           height: Get.height,
//           margin:
//               EdgeInsets.symmetric(horizontal: Get.width * .02, vertical: 5),
//           child: Form(
//             child: ListView(
//               children: [
//                 const Backbtnlogo2(),
//                 const SizedBox(height: 20),
//                 Text(
//                   "addequipmentHeadline1".tr,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w700, fontSize: 20),
//                 ),
//                 const SizedBox(height: 20),
//                 CustomTitle(
//                   number: "1",
//                   title: "addequipmentFirstsec".tr,
//                 ),
//                 const SizedBox(height: 10),
//                 FutureBuilder<Map<String, String?>>(
//                   future: _loadCategoryData(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     }

//                     var data = snapshot.data!;
//                     String? label = data['label'];
//                     String? categoryId = data['category_id'];

//                     return ListTile(
//                       title: Text(
//                         label ?? "Choisir la categorie",
//                         style: const TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w600),
//                       ),
//                     );
//                   },
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.backgroundColor,
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                   ),
//                   onPressed: () {
//                     controller.resetSelections(); // Reset all fields
//                     Get.offNamed(AppRoutesNames.addCategorieView);
//                   },
//                   child: const Text("Choisir une autre catégorie"),
//                 ),
//                 CustomTitle(
//                   number: "2",
//                   title: "addequipmentSecondsec".tr,
//                 ),
//                 const SizedBox(height: 20),
//                 DescriptionSection(controller: controller),
//                 CustomTitle(
//                   number: "3",
//                   title: "addequipmentThirdsec".tr,
//                 ),
//                 const SizedBox(height: 10),
//                 // PrixSection(), // Use the PrixSection widget here
//                 // Conditional Form Fields Based on Category
//                 FutureBuilder<Map<String, String?>>(
//                   future: _loadCategoryData(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     }

//                     var data = snapshot.data!;
//                     String? categoryId = data['category_id'];
//                     String? categoryLabel = data['label'];

//                     // Determine which form to display based on the category
//                     if (categoryId == '1') {
//                       if (categoryLabel != "Attachement") {
//                         return Column(
//                           children: [
//                             CustomTextfield(() {},
//                                 icon: "", hinttext: "brand".tr, isvalid: (v) {
//                               return null;
//                             }, mycontroller: controller.marque),
//                             CustomTextfield(() {},
//                                 icon: "", hinttext: "model".tr, isvalid: (v) {
//                               return null;
//                             }, mycontroller: controller.model),
//                             CustomTextfield(() {},
//                                 icon: "", hinttext: "year".tr, isvalid: (v) {
//                               return null;
//                             }, mycontroller: controller.annee),
//                             CustomTextfield(() {},
//                                 icon: "",
//                                 hinttext: "price_per_day".tr, isvalid: (v) {
//                               return null;
//                             }, mycontroller: controller.prixperjour),
//                             CustomTextfield(() {},
//                                 icon: "",
//                                 hinttext: "price_per_month".tr, isvalid: (v) {
//                               return null;
//                             }, mycontroller: controller.prixpermois),
//                           ],
//                         );
//                       } else {
//                         // For attachments
//                         return Column(
//                           children: [
//                             CustomTextfield(() {},
//                                 icon: "",
//                                 hinttext: "sub_category_id".tr, isvalid: (v) {
//                               return null;
//                             }, mycontroller: controller.subCategoryId),
//                           ],
//                         );
//                       }
//                     } else if (categoryId == '2') {
//                       return Column(
//                         children: [
//                           CustomTextfield(() {}, icon: "", hinttext: "brand".tr,
//                               isvalid: (v) {
//                             return null;
//                           }, mycontroller: controller.marque),
//                           CustomTextfield(() {}, icon: "", hinttext: "model".tr,
//                               isvalid: (v) {
//                             return null;
//                           }, mycontroller: controller.model),
//                         ],
//                       );
//                     }
//                     return const SizedBox();
//                   },
//                 ),

//                 const SizedBox(height: 10),
//                 CustomTitle(
//                   number: "4",
//                   title: "addequipmentFourthsec".tr,
//                 ),
//                 const SizedBox(height: 5),
//                 SmallHeadline(
//                   subtitle: "addequipmentSmallheadline1".tr,
//                   icon: AppImageAsset.locationIcon,
//                 ),
//                 const SizedBox(height: 5),
//                 const LocalisationfromGPS(),
//                 const SizedBox(height: 10),
//                 CustomTextfield(() {},
//                     icon: "",
//                     hinttext: "localisationregionhint".tr, isvalid: (v) {
//                   return null;
//                 }, mycontroller: controller.region),
//                 const SizedBox(height: 10),
//                 Container(
//                     margin: EdgeInsets.only(right: Get.width * .5),
//                     child: CustomTextfield(() {},
//                         icon: "",
//                         hinttext: "localisationcityhint".tr, isvalid: (v) {
//                       return null;
//                     }, mycontroller: controller.city)),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: SmallHeadline(
//                     subtitle: "addequipmentSmallheadline2".tr,
//                     icon: AppImageAsset.phoneIcon,
//                   ),
//                 ),
//                 CheckPhoneNumber(
//                     phone: "0699 17 45 56", checker: controller.ischecked1),
//                 CheckPhoneNumber(
//                     phone: "0555 55 55 55", checker: controller.ischecked2),
//                 const AjouteAttachmentText(),
//                 const SizedBox(height: 10),

//                 // File upload for photos
//                 SmallHeadline(
//                   subtitle: "addequipmentSmallheadline3".tr,
//                   icon: AppImageAsset.photosIcon,
//                 ),
//                 AttachmentBottomsheet(),
//                 InkWell(
//                   // onTap: () {
//                   //   controller.pickImage(); // Pick images from gallery
//                   // },
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 60),
//                     height: 130,
//                     width: 130,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(23),
//                         border: Border.all(color: AppColor.backgroundColor)),
//                     // child: controller.selectedPhotos.isNotEmpty
//                     //     ? ListView.builder(
//                     //         scrollDirection: Axis.horizontal,
//                     //         itemCount: controller.selectedPhotos.length,
//                     //         itemBuilder: (context, index) {
//                     //           return Padding(
//                     //             padding: const EdgeInsets.all(5),
//                     //             child: Image.file(
//                     //                 controller.selectedPhotos[index],
//                     //                 fit: BoxFit.cover),
//                     //           );
//                     //         },
//                     //       )
//                     //     :
//                     child: Padding(
//                       padding: const EdgeInsets.all(40),
//                       child: SvgPicture.asset(AppImageAsset.addpicture),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // File upload for documents
//                 SmallHeadline(
//                   subtitle: "addequipmentSmallheadline4".tr,
//                   icon: AppImageAsset.docIcon,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     // controller.pickDocument(); // Pick documents (PDF or DOCX)
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 60),
//                     height: 130,
//                     width: 130,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(23),
//                       border: Border.all(color: AppColor.backgroundColor),
//                     ),
//                     child:
//                         // controller.selectedDocuments.isNotEmpty
//                         //     ? ListView.builder(
//                         //         scrollDirection: Axis.horizontal,
//                         //         itemCount: controller.selectedDocuments.length,
//                         //         itemBuilder: (context, index) {
//                         //           return Padding(
//                         //             padding: const EdgeInsets.all(5),
//                         //             child: Text(
//                         //               controller.selectedDocuments[index].path
//                         //                   .split('/')
//                         //                   .last, // Show file name
//                         //               style: const TextStyle(fontSize: 12),
//                         //             ),
//                         //           );
//                         //         },
//                         //       )
//                         //     :
//                         Padding(
//                       padding: const EdgeInsets.all(40),
//                       child: SvgPicture.asset(AppImageAsset.addpicture),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 const SizedBox(height: 10),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           elevation: 5,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 40, vertical: 10),
//                           backgroundColor: AppColor.backgroundColor,
//                           foregroundColor: AppColor.primaryColor),
//                       onPressed: () {
//                         controller.add(); // Call add method from controller
//                       },
//                       child: const Text(
//                         "Submit",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       )),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<Map<String, String?>> _loadCategoryData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return {
//       'id': prefs.getString('id'),
//       'category_id': prefs.getString('category_id'),
//       'label': prefs.getString('label'),
//     };
//   }
// }import 'package:hasad/core/constants/routes_names.dart';
