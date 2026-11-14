import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class ProviderNegotiateScreen extends StatefulWidget {
  final Map<String, dynamic>? orderData;
  final int? matchId;
  final String? notificationType;
  const ProviderNegotiateScreen({
    Key? key,
    required this.orderData,
    this.matchId,
    this.notificationType,
  }) : super(key: key);

  @override
  _ProviderNegotiateScreenState createState() =>
      _ProviderNegotiateScreenState();
}

class _ProviderNegotiateScreenState extends State<ProviderNegotiateScreen> {
  late TextEditingController capacityController;
  late TextEditingController quantityController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;
  late TextEditingController hourController;
  late TextEditingController pricePerDayController;
  late TextEditingController operatorPriceController;
  late TextEditingController transportPriceController;
  late TextEditingController moreDetailsController;
  bool operatorStatus = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("orderData received in ProviderNegotiateScreen: ${widget.orderData}");

    if (widget.orderData == null) {
      print('Error: orderData is null.');
    } else if (widget.orderData?['categoryType'] == null) {
      print('Error: categoryType is null.');
    }

    _initializeControllers(widget.orderData);
    operatorStatus = widget.orderData?['order']?['operator'] == 1;
  }

  void _initializeControllers(Map<String, dynamic>? orderData) {
    String? timeString = orderData?['order']?['hour'];

    if (timeString != null && timeString.isNotEmpty) {
      try {
        DateTime parsedTime = DateTime.parse(timeString);
        hourController =
            TextEditingController(text: DateFormat('H:m').format(parsedTime));
      } catch (e) {
        hourController = TextEditingController(text: '');
      }
    } else {
      hourController = TextEditingController(text: '');
    }

    capacityController = TextEditingController(
        text: orderData?['order']?['capacity']?.toString() ?? '');
    quantityController = TextEditingController(
        text: orderData?['order']?['quantity']?.toString() ?? '');
    startDateController =
        TextEditingController(text: orderData?['order']?['start_date'] ?? '');
    endDateController =
        TextEditingController(text: orderData?['order']?['end_date'] ?? '');
    pricePerDayController = TextEditingController(
        text: orderData?['price_per_day']?.toString() ?? '');
    operatorPriceController = TextEditingController(
        text: orderData?['operator_price']?.toString() ?? '');
    transportPriceController = TextEditingController(
        text: orderData?['transport_price']?.toString() ?? '');
    moreDetailsController =
        TextEditingController(text: orderData?['order']?['more_details'] ?? '');
  }

  @override
  void dispose() {
    capacityController.dispose();
    quantityController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    hourController.dispose();
    pricePerDayController.dispose();
    operatorPriceController.dispose();
    transportPriceController.dispose();
    moreDetailsController.dispose();
    super.dispose();
  }

  Future<void> _refreshOrderData() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String categoryType = widget.orderData?['categoryType'] ?? 'Unknown';
      int? id = widget.orderData?['order']?['id'];

      if (categoryType == 'Unknown') {
        print('Error: categoryType is null or unknown. Cannot proceed.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Category type is missing. Please go back and try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      String endpoint = _getOrderEndpoint(categoryType, id!);
      print("Refreshing order data from endpoint: $endpoint");

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
          Uri.parse('${ApiLinkNames.server}/api' + endpoint),
          headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> updatedOrderData = json.decode(response.body);

        setState(() {
          widget.orderData?.addAll(updatedOrderData);
          _initializeControllers(updatedOrderData);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to refresh order data.');
      }
    } catch (e) {
      print('Error refreshing order data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getOrderEndpoint(String categoryType, int id) {
    switch (categoryType) {
      case "Construction Vehicle":
        return '/construction-vehicle-order-matches/$id';
      case "Transportation Vehicle":
        return '/transportation-vehicle-order-matches/$id';
      case "Construction Equipment":
        return '/construction-equipment-order-matches/$id';
      case "Construction Attachment":
        return '/construction-attachment-order-matches/$id';
      default:
        throw Exception('Unknown category type');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orderData == null) {
      return const Center(child: Text("No order data available"));
    }

    final Map<String, dynamic>? order =
        widget.orderData?['order'] as Map<String, dynamic>?;
    final Map<String, dynamic>? subCategory =
        order?['sub_category'] as Map<String, dynamic>?;
    final Map<String, dynamic>? provider =
        widget.orderData?['provider'] as Map<String, dynamic>?;

    String machineLabel = subCategory?['label'] ?? 'Unknown';
    bool canNegotiate = widget.orderData?['can_negotiate'] ?? false;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildHeader(machineLabel, subCategory?['photo']),
                const Divider(),
                _buildEditableField('Capacité', capacityController),
                _buildEditableField('Quantité', quantityController),
                _buildEditableField('Date de début', startDateController),
                _buildEditableField('Date de fin', endDateController),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: AbsorbPointer(
                    child: _buildEditableField('Heure', hourController),
                  ),
                ),
                _buildEditableField(
                    'Détails supplémentaires', moreDetailsController),
                _buildOperatorField(),
                const Divider(),
                _buildInvoiceSection(canNegotiate),
                const Divider(),
                _buildProviderDetails(provider),
                _buildActionButtons(),
              ],
            ),
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String machineLabel, String? imageUrl) {
    final String? imagePath = imageUrl != null
        ? '${ApiLinkNames.server}/${imageUrl.replaceFirst('public/', 'storage/')}'
        : null;

    return Column(
      children: [
        SizedBox(
          height: 250,
          width: 120,
          child: imagePath != null && imagePath.isNotEmpty
              ? AppNetworkImage(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/no_image_available.png');
                  },
                )
              : Image.asset('assets/images/no_image_available.png'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            machineLabel,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildOperatorField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Opérateur',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Switch(
          value: operatorStatus,
          onChanged: (value) {
            setState(() {
              operatorStatus = value;
            });
          },
        ),
        Text(operatorStatus ? "Avec" : "Sans",
            style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  void _handleModify() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Print the order data to see what we have received
      print('Order data received for modification: ${widget.orderData}');

      // Prepare form data with the current values in the controllers
      Map<String, String> formData = {
        'operator': operatorStatus ? '1' : '0',
        'capacity': capacityController.text,
        'quantity': quantityController.text,
        'start_date': startDateController.text,
        'end_date': endDateController.text,
        'hour': _validateHourFormat(hourController.text),
        'more_details': moreDetailsController.text,
        'price_per_day': pricePerDayController.text,
        'operator_price': operatorPriceController.text,
        'transport_price': transportPriceController.text,
      };

      // Print the form data being submitted
      print('Submitting form data: $formData');

      // Extract notification type and match ID from the widget properties
      String? notificationType = widget.notificationType;
      int? matchId =
          widget.matchId; // Change to get matchId directly from widget

      // Print notificationType and matchId to debug its value
      print('Notification Type: $notificationType');
      print('Match ID: $matchId');

      if (notificationType == null || matchId == null) {
        print(
            'Error: notificationType or matchId is null. Cannot proceed with modification.');
        return;
      }

      // Determine the correct endpoint based on the notification type
      String endpoint = '';
      if (notificationType ==
          "construction-vehicle-renting-request-negotiated-by-renter") {
        endpoint = '/construction-vehicle-order-matches/negotiate/$matchId';
      } else if (notificationType ==
          "construction-equipment-renting-request-negotiated-by-renter") {
        endpoint = '/construction-equipment-order-matches/negotiate/$matchId';
      } else if (notificationType ==
          "construction-attachment-renting-request-negotiated-by-renter") {
        endpoint = '/construction-attachment-order-matches/negotiate/$matchId';
      } else if (notificationType ==
          "transportation-vehicle-renting-request-negotiated-by-renter") {
        endpoint = '/transportation-vehicle-order-matches/negotiate/$matchId';
      } else {
        print('Error: Unknown notification type. Cannot determine endpoint.');
        return;
      }

      // Print the endpoint to verify correctness
      print('Using endpoint: $endpoint');

      // Submit negotiation
      await submitNegotiation(notificationType, endpoint, matchId, formData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Order modified successfully!'),
            backgroundColor: Colors.green),
      );

      await _refreshOrderData();
    } catch (e) {
      print('Error modifying order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to modify the order. Please try again.'),
            backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Method to submit the negotiation request
  // Future<void> submitNegotiation(
  //     String endpoint, Map<String, String> formData) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');

  //   if (token == null) {
  //     throw Exception('Token is null. Please login again.');
  //   }

  //   var headers = {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };

  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('${ApiLinkNames.server}/api' + endpoint));

  //   request.fields.addAll(formData);
  //   request.headers.addAll(headers);

  //   try {
  //     http.StreamedResponse response = await request.send();
  //     String responseBody = await response.stream.bytesToString();

  //     // Log the entire response for debugging purposes
  //     print('Response Status Code: ${response.statusCode}');
  //     print('Response Body: $responseBody');

  //     if (response.statusCode == 200) {
  //       print('Negotiation successful: $responseBody');
  //     } else {
  //       throw Exception(
  //           'Failed to negotiate. Status Code: ${response.statusCode}. Response: $responseBody');
  //     }
  //   } catch (e) {
  //     print('Error occurred during negotiation: $e');
  //     throw Exception('Failed to submit negotiation: $e');
  //   }
  // }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // Format the hour in 24-hour format (H:i)
      String formattedTime = picked.hour.toString().padLeft(2, '0') +
          ":" +
          picked.minute.toString().padLeft(2, '0');

      setState(() {
        hourController.text = formattedTime;
      });
    }
  }

  Future<void> submitNegotiation(String? notificationType, String endpoint,
      int matchId, Map<String, String> formData) async {
    if (endpoint.isEmpty) {
      print("Error: Endpoint is empty.");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("Error: Token is null. Please login again.");
      return;
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiLinkNames.server}/api' + endpoint));

    // Add fields based on notification type
    switch (notificationType) {
      case "construction-vehicle-renting-request-negotiated-by-renter":
        request.fields.addAll({
          'operator': formData['operator'] ?? '',
          'capacity': formData['capacity'] ?? '',
          'quantity': formData['quantity'] ?? '',
          'start_date': formData['start_date'] ?? '',
          'end_date': formData['end_date'] ?? '',
          'hour': formData['hour'] ?? '',
          'transport':
              formData['transport'] ?? 'by_yourself', // Default transport
          'more_details': formData['more_details'] ?? '',
          'price_per_day': formData['price_per_day'] ?? '',
          'operator_price': formData['operator_price'] ?? '',
          'transport_price': formData['transport_price'] ?? '',
        });
        break;
      case "construction-attachment-renting-request-negotiated-by-renter":
        request.fields.addAll({
          'capacity': formData['capacity'] ?? '',
          'quantity': formData['quantity'] ?? '',
          'start_date': formData['start_date'] ?? '',
          'end_date': formData['end_date'] ?? '',
          'hour': formData['hour'] ?? '',
          'transport': formData['transport'] ?? 'by_yourself',
          'more_details': formData['more_details'] ?? '',
          'price_per_day': formData['price_per_day'] ?? '',
          'transport_price': formData['transport_price'] ?? '',
        });
        break;
      case "construction-equipment-renting-request-negotiated-by-renter":
        request.fields.addAll({
          'operator': formData['operator'] ?? '',
          'capacity': formData['capacity'] ?? '',
          'quantity': formData['quantity'] ?? '',
          'start_date': formData['start_date'] ?? '',
          'end_date': formData['end_date'] ?? '',
          'hour': formData['hour'] ?? '',
          'transport': formData['transport'] ?? 'by_yourself',
          'more_details': formData['more_details'] ?? '',
          'price_per_day': formData['price_per_day'] ?? '',
          'operator_price': formData['operator_price'] ?? '',
          'transport_price': formData['transport_price'] ?? '',
        });
        break;
      case "transportation-vehicle-renting-request-negotiated-by-renter":
        request.fields.addAll({
          'operator': formData['operator'] ?? '',
          'start_date': formData['start_date'] ?? '',
          'end_date': formData['end_date'] ?? '',
          'more_details': formData['more_details'] ?? '',
          'operator_price': formData['operator_price'] ?? '',
        });
        break;
      default:
        print("Error: Unknown notification type: $notificationType");
        return;
    }

    request.headers.addAll(headers);

    try {
      print("Making API call to: ${request.url}");
      print("Headers: ${request.headers}");
      print("Form data: ${request.fields}");

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200) {
        print('Negotiation successful: $responseBody');
      } else {
        throw Exception(
            'Failed to negotiate. Status Code: ${response.statusCode}. Response: $responseBody');
      }
    } catch (e) {
      print('Error occurred during negotiation: $e');
      throw Exception('Failed to submit negotiation: $e');
    }
  }

  String _validateHourFormat(String hour) {
    final hourFormat = RegExp(r'^\d{1,2}:\d{2}$');
    if (!hourFormat.hasMatch(hour)) {
      throw Exception("Invalid hour format: $hour. Expected format is H:i.");
    }
    return hour;
  }

  Widget _buildInvoiceSection(bool canNegotiate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Facture',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildDetailRow('Prix par jour',
            widget.orderData?['price_per_day'].toString() ?? 'N/A DZD'),
        _buildDetailRow('Durée',
            widget.orderData?['order']?['duration'].toString() ?? 'N/A Jours'),
        _buildDetailRow('Opérateur',
            widget.orderData?['operator_price'].toString() ?? 'N/A DZD'),
        _buildDetailRow('Transport',
            widget.orderData?['transport_price'].toString() ?? 'N/A DZD'),
        _buildDetailRow(
            'Total', widget.orderData?['total_price'].toString() ?? 'N/A DZD'),
        if (canNegotiate) ...[
          _buildNegotiableFields(),
        ]
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNegotiableFields() {
    return Column(
      children: [
        _buildEditableField('Prix par jour', pricePerDayController),
        _buildEditableField('Prix opérateur', operatorPriceController),
        _buildEditableField('Prix transport', transportPriceController),
      ],
    );
  }

  Widget _buildProviderDetails(Map<String, dynamic>? provider) {
    String providerName = provider?['first_name'] ?? 'Unknown';
    String providerCity = provider?['city'] ?? 'Unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Détails du fournisseur:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildDetailRow('Nom', providerName),
        _buildDetailRow('Ville', providerCity),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _handleAccept,
            child: const Text('Accepter', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _handleModify,
            child: const Text('Modifier', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: _handleCancel,
            child: const Text('Annuler', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _handleAccept() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetching the shared preferences to retrieve the token.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Extracting categoryType and order id from widget.orderData.
      String? categoryType = widget.orderData?['categoryType'];
      int? id = widget.orderData?['order']?['id'];

      // Debugging the values before proceeding
      if (token == null) {
        print('Error: Token is null. Please login again.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token is missing. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (categoryType == null) {
        print('Error: categoryType is null. Cannot proceed.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category type is missing.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (id == null) {
        print('Error: id is null. Cannot proceed.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order ID is missing.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Determining the correct API endpoint based on categoryType
      String endpoint = '';
      switch (categoryType) {
        case "Construction Vehicle":
          endpoint = '/construction-vehicle-order-matches/accept/$id';
          break;
        case "Transportation Vehicle":
          endpoint = '/transportation-vehicle-order-matches/accept/$id';
          break;
        case "Construction Equipment":
          endpoint = '/construction-equipment-order-matches/accept/$id';
          break;
        case "Construction Attachment":
          endpoint = '/construction-attachment-order-matches/accept/$id';
          break;
        default:
          print('Error: Unknown category type - $categoryType');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unknown category type: $categoryType'),
              backgroundColor: Colors.red,
            ),
          );
          return;
      }

      print('API Endpoint: $endpoint');

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Sending the PUT request to accept the order.
      var response = await http.put(
        Uri.parse('${ApiLinkNames.server}/api' + endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print('Order accepted successfully.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order accepted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print(
            'Failed to accept order. Status Code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept order. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Exception occurred while accepting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while accepting the order.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleCancel() {
    Navigator.pop(context);
  }
}
