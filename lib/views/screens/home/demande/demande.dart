import 'dart:convert';
import 'dart:io';
import 'package:hasad/controller/demande/demande_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/widgets/home/backbtnlogo.dart';
import 'package:hasad/widgets/home/demande/attachment_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class DemandeItem extends StatefulWidget {
  DemandeItem({super.key});

  @override
  _DemandeItemState createState() => _DemandeItemState();
}

class _DemandeItemState extends State<DemandeItem> {
  // List<String> selectedAttachmentIds =
  //     []; // Store multiple selected attachment IDs
  File? _pickedImage;
  List<Map<String, String>> selectedAttachments =
      []; // Store full attachment details
  List<Map<String, String>> selectedAttachmentIds =
      []; // Store multiple selected attachments with details

  final TextEditingController operatorController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController moreDetailsController = TextEditingController();
  final TextEditingController departureLocationController =
      TextEditingController();
  final TextEditingController arrivalLocationController =
      TextEditingController();

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  int operatorSelected = 0;
  int equipmentSelected = 0;
  String transportSelected = 'by_yourself';
  String needSelected = 'per_day';
  String dateDurationText = '';
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        print("Picked Image Path: ${_pickedImage!.path}");
      });
    } else {
      print("No image selected.");
    }
  }

  Future<void> _showAttachmentScreen(BuildContext context) async {
    final List<Map<String, String>>? result =
        await showModalBottomSheet<List<Map<String, String>>>(
      context: context,
      builder: (BuildContext context) {
        return AttachmentScreen();
      },
    );

    if (result != null) {
      setState(() {
        // Ensure the 'public' in the URL is replaced with 'storage'
        selectedAttachments = result.map((attachment) {
          String photoUrl = attachment['photo'] ?? '';
          if (photoUrl.contains('/public/')) {
            photoUrl = photoUrl.replaceFirst('/public/', '/storage/');
          }
          return {
            'label': attachment['label'] ?? 'No label',
            'photo': photoUrl, // Corrected URL
          };
        }).toList();
      });

      // Print selected attachments with their labels and corrected photo paths
      for (var attachment in selectedAttachments) {
        print(
            "Selected Attachment - Label: ${attachment['label']}, Photo Path: ${attachment['photo']}");
      }
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final timeIn24HourFormat =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        hourController.text = DateFormat('HH:mm').format(timeIn24HourFormat);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final String categoryType = arguments['categoryType'];
    final String? typeIdString = arguments['typeId'];
    final int? typeId = int.tryParse(typeIdString ?? '');
    final String subCategoryId = arguments['sub_category_id'].toString();
    final String? imageUrl = arguments['photo'];
    final String? machineLabel = arguments['label']; // Get the selected label
    bool showOperator = categoryType == "Construction Vehicle" ||
        categoryType == "Transportation Vehicle" ||
        categoryType == "Construction Equipment";
    bool showEquipments = categoryType == "Transportation Vehicle";
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  const Backbtnlogo(), // Positioned on the left
                  const SizedBox(
                      width: 5), // Space between logo and next widget
                ],
              ),
              SizedBox(
                height: 250,
                width: 120,
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? AppNetworkImage(imageUrl, fit: BoxFit.contain)
                    : Image.asset(AppImageAsset.pleteuse, fit: BoxFit.contain),
              ),

              const Divider(color: AppColor.backgroundColor),
              // Operator Status (Switch)
              // Show Operator field conditionally
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround, // Aligns to start
                children: [
                  if (machineLabel != null)
                    Flexible(
                      // Allows machineLabel to use available space without forcing expansion
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          machineLabel,
                          style: const TextStyle(
                            fontSize: 14, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  if (showOperator)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: FittedBox(
                        // Scales inner row contents to fit if needed
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, // Align to the end of available space
                          children: [
                            Checkbox(
                              value: operatorSelected == 1,
                              onChanged: (bool? isChecked) {
                                setState(() {
                                  operatorSelected = isChecked == true ? 1 : 0;
                                });
                              },
                              activeColor: AppColor.backgroundColor,
                              checkColor: Colors.white,
                            ),
                            const SizedBox(
                                width: 5), // Space between checkbox and label
                            const Text(
                              "Operator Active:",
                              style: TextStyle(
                                fontSize: 14, // Reduced font size
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                                width: 5), // Space between text and icon
                            const Icon(
                              Icons.person, // Icon for operator
                              size: 18, // Adjust size as needed
                              color: AppColor.backgroundColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const Divider(color: AppColor.backgroundColor),

              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   child: Text(
              //     "Fill Your Request",
              //     style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
              //   ),
              // ),
              if (showEquipments)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Equipment Active:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Switch(
                        value: equipmentSelected ==
                            1, // Check if operator is active
                        onChanged: (bool isActive) {
                          setState(() {
                            equipmentSelected =
                                isActive ? 1 : 0; // Set active/inactive status
                          });
                        },
                        activeColor: AppColor.primaryColor,
                        activeTrackColor: Colors.lightGreen,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],
                  ),
                ),

              Column(
                children: _buildFormFields(context, categoryType),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await _pickImage();
                  },
                  child: const Text("Add Image",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String filePath =
                            _pickedImage != null ? _pickedImage!.path : "";

                        // Call submitForm and handle the result
                        await submitForm(
                            typeId, categoryType, subCategoryId, filePath);

                        // You can add additional logic here if necessary, but without navigation
                      },
                      child: const Text(
                        "Submit Request",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // ElevatedButton(
                    //   onPressed: () async {
                    //     String filePath =
                    //         _pickedImage != null ? _pickedImage!.path : "";

                    //     await submitForm(
                    //         typeId, categoryType, subCategoryId, filePath);

                    //     // Example: Replace this with actual dynamic data from the form submission response
                    //     var totalPrice = '10000';
                    //     var providerFirstName = 'John';
                    //     var providerUserType = 'provider_individual';
                    //     var transportationCity = 'New York';
                    //     var imageUrl = filePath.isNotEmpty
                    //         ? filePath
                    //         : 'https://example.com/default_photo.jpg';

                    //     Get.toNamed(
                    //       AppRoutesNames.demandeSearching,
                    //       arguments: {
                    //         'label': operatorController.text,
                    //         'first_name': providerFirstName,
                    //         'user_type': providerUserType,
                    //         'city': transportationCity,
                    //         'total_price': totalPrice,
                    //         'photo': imageUrl,
                    //       },
                    //     );
                    //   },
                    //   child: const Text(
                    //     "Submit Request",
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        Get.offNamed(AppRoutesNames.homepage);
                      },
                      child: const Text("Cancel",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context, String categoryType) {
    List<Widget> formFields = [
      buildTextField("Capacity", capacityController),
      buildTextField("Quantity", quantityController),
      buildDateRangeField(context),
      buildTimeField(context),
      buildTransportToggle(),
      const Divider(color: AppColor.backgroundColor),

      // Button to open the attachment screen
      ElevatedButton(
        onPressed: () {
          _showAttachmentScreen(context); // Show the attachment popup
        },
        child: const Text("Select Attachment"),
      ),

      // Display selected attachments if any are selected
      if (selectedAttachments.isNotEmpty) buildSelectedAttachmentsView(),

      const Divider(color: AppColor.backgroundColor),
      buildTextDetailsField("Plus de détails :", moreDetailsController),
    ];

    // Add conditional fields based on categoryType
    if (categoryType == "Transportation Vehicle") {
      formFields.insert(5, buildNeedToggle());
      formFields.insert(
        6,
        buildCustomLocationTextField(
          "Departure Location",
          departureLocationController,
          Icons.location_on,
        ),
      );
      formFields.insert(
        7,
        buildCustomLocationTextField(
          "Arrival Location",
          arrivalLocationController,
          Icons.location_city,
        ),
      );
    }

    return formFields;
  }

  Widget buildSelectedAttachmentsView() {
    return SizedBox(
      height: 150, // Adjust height for the attachment cards
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedAttachments.length,
        itemBuilder: (context, index) {
          final attachment = selectedAttachments[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                Expanded(
                  child: attachment['photo'] != null
                      ? AppNetworkImage(
                          attachment['photo']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image);
                          },
                        )
                      : const Icon(Icons.broken_image),
                ),
                const SizedBox(height: 5),
                Text(
                  attachment['label'] ?? 'No label',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget buildEquipmentToggle() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         const Text("Equipments"),
  //         Switch(
  //           value: equipmentSelected == 1,
  //           onChanged: (bool value) {
  //             equipmentSelected = value ? 1 : 0;
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildTransportToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Transport"),
          // Transport Dropdown
          DropdownButton<String>(
            value: transportSelected,
            onChanged: (String? newValue) {
              setState(() {
                transportSelected = newValue!;
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: 'by_yourself', // Internal value
                child: Text("Par vous"), // Displayed to the user
              ),
              DropdownMenuItem<String>(
                value: 'by_us', // Internal value
                child: Text("Par nous"), // Displayed to the user
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildNeedToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Votre besoin?"),
          // Need Dropdown
          DropdownButton<String>(
            value: needSelected,
            onChanged: (String? newValue) {
              setState(() {
                needSelected = newValue!;
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: 'per_day', // This is the value used internally
                child: Text("Par jour"), // This is what the user sees
              ),
              DropdownMenuItem<String>(
                value: 'per_distance', // This is the value used internally
                child: Text("Par distance"), // This is what the user sees
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
              width: 10), // Add some spacing between label and TextField

          // Wrap TextField in Expanded to control its width
          Container(
            width: 100, // Fixed width for a square shape
            height: 50, // Fixed height for a square shape
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true, // Reduces the height within the box
                contentPadding:
                    EdgeInsets.all(8), // Control padding inside the box
              ),
              textAlign: TextAlign.center, // Center text within the box
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextDetailsField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10), // Space between the label and the text field

          Container(
            width: 350, // Width adjusted for more content
            height: 150, // Height suitable for a multiline description box
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400), // Border color
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            padding: EdgeInsets.all(8), // Padding inside the container
            child: TextField(
              controller: controller,
              maxLines: 5, // Allow multiple lines for text entry
              decoration: InputDecoration(
                hintText: "Enter description here...", // Placeholder text
                border: InputBorder.none, // Removes default underline border
                isDense:
                    true, // Reduces the space within the text field for more compact look
              ),
              textAlign: TextAlign
                  .start, // Start text alignment for better multiline usage
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomLocationTextField(
      String label, TextEditingController controller, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the text field
          borderRadius: BorderRadius.circular(32), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.orange)
                : null, // Conditional prefix icon
            border: InputBorder.none, // Removes default underline border
            contentPadding: EdgeInsets.symmetric(
                horizontal: 20, vertical: 18), // Adjusts padding
            enabledBorder: OutlineInputBorder(
              // Normal state
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              // Focus state
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
          style: TextStyle(fontSize: 16), // Text style
        ),
      ),
    );
  }

  Widget buildDateRangeField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Container(
                      width: 300, // Set container size to square shape
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // Background color for picker container
                        border: Border.all(
                            color: AppColor.backgroundColor, width: 2),
                        borderRadius: BorderRadius.circular(
                            15), // Rounded corners with radius 15
                      ),
                      child: ClipRRect(
                        // Clip the picker to match container's rounded corners
                        borderRadius: BorderRadius.circular(15),
                        child: SfDateRangePicker(
                          minDate: DateTime.now(),
                          selectionMode: DateRangePickerSelectionMode.range,
                          selectionColor: AppColor
                              .backgroundColor, // Set selected date color
                          rangeSelectionColor: AppColor.backgroundColor
                              .withOpacity(0.2), // Range selection color
                          startRangeSelectionColor:
                              AppColor.backgroundColor, // Start date color
                          endRangeSelectionColor:
                              AppColor.backgroundColor, // End date color
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) {
                            if (args.value is PickerDateRange) {
                              selectedStartDate = args.value.startDate;
                              selectedEndDate = args.value.endDate;

                              if (selectedEndDate != null) {
                                dateRangeController.text =
                                    "${DateFormat('yyyy-MM-dd').format(selectedStartDate!)} - ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}";
                                int duration = selectedEndDate!
                                    .difference(selectedStartDate!)
                                    .inDays;
                                setState(() {
                                  dateDurationText =
                                      "$duration days"; // Display duration
                                });
                                Navigator.pop(context);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: AbsorbPointer(
              child: TextField(
                controller: dateRangeController,
                decoration: InputDecoration(
                  labelText: "Select Date Range",
                  border: OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (selectedStartDate != null && selectedEndDate != null)
            Text(
              "Duration: $dateDurationText",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColor
                    .backgroundColor, // Applied AppColor.backgroundColor
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTimeField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          _pickTime(context);
        },
        child: AbsorbPointer(
          child: TextField(
            controller: hourController,
            decoration: InputDecoration(
              labelText: "Hour",
              border: OutlineInputBorder(),
              suffixIcon: const Icon(Icons.access_time),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitForm(int? typeId, String categoryType,
      String subCategoryId, String filePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Error: Token is null. User may not be logged in.");
      return;
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var request;

      if (categoryType == "Construction Vehicle") {
        request = http.MultipartRequest('POST',
            Uri.parse('${ApiLinkNames.server}/api/construction-vehicle-orders'));
        // Convert operator (active/inactive) to Boolean values 1 or 0
        String operatorValue = operatorSelected == 1 ? '1' : '0';
        request.fields.addAll({
          'sub_category_id': subCategoryId,
          // 'operator': operatorController.text,
          'operator': operatorValue, // Operator as active (1) or inactive (0)
          'capacity': capacityController.text,
          'quantity': quantityController.text,
          'start_date': DateFormat('yyyy-MM-dd').format(selectedStartDate!),
          'end_date': DateFormat('yyyy-MM-dd').format(selectedEndDate!),
          'hour': hourController.text,
          'transport': transportSelected,
          'more_details': moreDetailsController.text,
        });
        // Add the selected attachments dynamically
        for (int i = 0; i < selectedAttachmentIds.length; i++) {
          request.fields['attachments[$i][sub_category_id]'] =
              selectedAttachmentIds[i];
        }
      } else if (categoryType == "Transportation Vehicle") {
        request = http.MultipartRequest('POST',
            Uri.parse('${ApiLinkNames.server}/api/transportation-vehicle-orders'));
        String operatorValue = operatorSelected == 1 ? '1' : '0';
        String equipmentsValue = equipmentSelected == 1 ? '1' : '0';
        request.fields.addAll({
          'sub_category_id': subCategoryId,
          'operator': operatorValue,
          'capacity': capacityController.text,
          'quantity': quantityController.text,
          // 'equipments': equipmentSelected.toString(),
          'equipments': equipmentsValue,
          'your_need': needSelected,
          'departure_location': departureLocationController.text,
          'arrival_location': arrivalLocationController.text,
          'start_date': DateFormat('yyyy-MM-dd').format(selectedStartDate!),
          'end_date': DateFormat('yyyy-MM-dd').format(selectedEndDate!),
          'hour': hourController.text,
          'transport': transportSelected,
          'more_details': moreDetailsController.text,
        });
        // Add the selected attachments dynamically
        for (int i = 0; i < selectedAttachmentIds.length; i++) {
          request.fields['attachments[$i][sub_category_id]'] =
              selectedAttachmentIds[i];
        }
      } else if (categoryType == "Construction Attachment") {
        request = http.MultipartRequest(
            'POST',
            Uri.parse(
                '${ApiLinkNames.server}/api/construction-attachment-orders'));
        request.fields.addAll({
          'sub_category_id': subCategoryId,
          'capacity': capacityController.text,
          'quantity': capacityController.text,
          'start_date': DateFormat('yyyy-MM-dd').format(selectedStartDate!),
          'end_date': DateFormat('yyyy-MM-dd').format(selectedEndDate!),
          'hour': hourController.text,
          'transport': transportSelected,
          'more_details': moreDetailsController.text,
        });
      } else if (categoryType == "Construction Equipment") {
        request = http.MultipartRequest('POST',
            Uri.parse('${ApiLinkNames.server}/api/construction-equipment-orders'));
        String operatorValue = operatorSelected == 1 ? '1' : '0';
        request.fields.addAll({
          'sub_category_id': subCategoryId,
          'operator': operatorValue,
          'capacity': capacityController.text,
          'quantity': capacityController.text,
          'start_date': DateFormat('yyyy-MM-dd').format(selectedStartDate!),
          'end_date': DateFormat('yyyy-MM-dd').format(selectedEndDate!),
          'hour': hourController.text,
          'transport': transportSelected,
          'more_details': moreDetailsController.text,
        });
      }

      // Add image if available
      if (filePath.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('photos[]', filePath));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      // Success case
      // 201 = the new flow: the demand (order) was created and every
      // eligible provider was notified. Offers appear later, as providers
      // submit them manually. 200 kept for the legacy response shape.
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await http.Response.fromStream(response);
        print('Demand submitted: ${response.statusCode}');

        final dynamic parsed = jsonDecode(responseData.body);

        if (parsed is List) {
          // Legacy shape: a list of auto-generated matches.
          Get.toNamed(AppRoutesNames.demandeSearching, arguments: {
            'orders': parsed,
          });
        } else if (parsed is Map && parsed['order'] != null) {
          // New shape: {order: {...}, notified_providers: N}
          final dynamic order = parsed['order'];
          Get.toNamed(AppRoutesNames.demandeSearching, arguments: {
            'order': order,
            'order_id': order['id'],
            'categoryType': categoryType,
            'notified_providers': parsed['notified_providers'] ?? 0,
          });
        } else {
          Get.toNamed(AppRoutesNames.demandeSearching, arguments: {
            'order': null,
            'order_id': null,
            'categoryType': categoryType,
          });
        }
      } else {
        // Failure case: Check if it is a 404 error and show the snackbar
        final errorResponse = await response.stream.bytesToString();
        print('Error: ${response.statusCode} - ${response.reasonPhrase}');
        print('Response Body: $errorResponse');

        if (response.statusCode == 404 &&
            errorResponse.contains("No vehicles were found")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Sorry, no vehicles were found for the given order'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 150,
                  left: 10,
                  right: 10), // Position it at the top
            ),
          );
        } else {
          // Handle other errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred. Please try again.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 150,
                  left: 10,
                  right: 10), // Position it at the top
            ),
          );
        }
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fill the fields'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            left: 10,
            right: 10,
          ),
        ),
      );
    }
  }
}

// import 'package:hasad/controller/demande/demande_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:hasad/widgets/home/backbtnlogo.dart';
// import 'package:hasad/widgets/home/demande/demande_widgets.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DemandeItem extends GetView<DemandeControllerImp> {
//   const DemandeItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => DemandeControllerImp());
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           height: Get.height,
//           width: Get.width,
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: ListView(
//             physics: const BouncingScrollPhysics(),
//             children: [
//               const Backbtnlogo(),
//               SizedBox(
//                 height: 250,
//                 width: 120,
//                 child: Image.asset(
//                   AppImageAsset.pleteuse,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const Divider(
//                 color: AppColor.backgroundColor,
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   "Camion 4-5 Places + Cabin",
//                   style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
//                 ),
//               ),
//               const Divider(
//                 color: AppColor.backgroundColor,
//               ),
//               const Capacite(),
//               const Divider(
//                 color: AppColor.backgroundColor,
//               ),
//               const Quantite(),
//               const Divider(
//                 color: AppColor.backgroundColor,
//               ),
//               const BesoinDemande(),
//               const Divider(
//                 color: AppColor.backgroundColor,
//               ),
//               controller.isitemhaveanotherdetails == true
//                   ? const Duree()
//                   : const SizedBox(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   "demandePlusdedetails".tr,
//                   style: const TextStyle(
//                       fontSize: 23, fontWeight: FontWeight.w700),
//                 ),
//               ),
//               const DetailsBesoinSuplluments(),
//               const AddPhotoDetails(),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             foregroundColor: AppColor.primaryColor,
//                             backgroundColor: AppColor.backgroundColor,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 6, horizontal: 16)),
//                         onPressed: () {
//                           Get.offNamed(AppRoutesNames.demandeSearching);
//                         },
//                         child: Text(
//                           "itemsactionbtn".tr,
//                           style: const TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         )),
//                     ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             foregroundColor: AppColor.primaryColor,
//                             backgroundColor: AppColor.secondaryColor,
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 6, horizontal: 16)),
//                         onPressed: () {},
//                         child: Text("itemscancelbtn".tr,
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.w600))),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//import 'package:flutter/material.dart';
