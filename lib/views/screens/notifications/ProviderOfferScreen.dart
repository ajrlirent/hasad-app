import 'dart:convert';

import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Screen where a provider reviews a renting demand (renting-request-placed
// notification, which carries the demand itself) and manually submits an
// offer for it. This is the ONLY way an offer is created.
//
// orderData is the notification's data payload: it contains the demand
// (order_id, dates, capacity, quantity, operator/transport requirements)
// and the provider's matching machine info (brand, model, price per day).
class ProviderOfferScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final String notificationType;

  const ProviderOfferScreen({
    Key? key,
    required this.orderData,
    required this.notificationType,
  }) : super(key: key);

  @override
  State<ProviderOfferScreen> createState() => _ProviderOfferScreenState();
}

class _ProviderOfferScreenState extends State<ProviderOfferScreen> {
  late TextEditingController pricePerDayController;
  late TextEditingController operatorPriceController;
  late TextEditingController transportPriceController;
  late TextEditingController distancePriceController;
  bool isSubmitting = false;

  // Machine key prefix (construction_vehicle / construction_equipment /
  // construction_attachment / transportation_vehicle) based on the
  // notification type.
  late String machinePrefix;

  bool get needsOperator => widget.orderData['operator'] == true;

  bool get needsTransport => widget.orderData['transport'] == 'by_us';

  bool get isTransportation =>
      widget.notificationType.contains('transportation-vehicle');

  bool get isPerDistance => widget.orderData['your_need'] == 'per_distance';

  @override
  void initState() {
    super.initState();

    if (widget.notificationType.contains('construction-vehicle')) {
      machinePrefix = 'construction_vehicle';
    } else if (widget.notificationType.contains('construction-equipment')) {
      machinePrefix = 'construction_equipment';
    } else if (widget.notificationType.contains('construction-attachment')) {
      machinePrefix = 'construction_attachment';
    } else {
      machinePrefix = 'transportation_vehicle';
    }

    pricePerDayController = TextEditingController(
        text: widget.orderData['machine_price_per_day']?.toString() ?? '');
    operatorPriceController = TextEditingController(text: '');
    transportPriceController = TextEditingController(text: '');
    distancePriceController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    pricePerDayController.dispose();
    operatorPriceController.dispose();
    transportPriceController.dispose();
    distancePriceController.dispose();
    super.dispose();
  }

  String? get _machinePhotoUrl {
    final String? photo = widget.orderData['${machinePrefix}_sub_category_photo'];
    if (photo == null || photo.isEmpty) return null;
    return '${ApiLinkNames.server}/${photo.replaceFirst('public/', 'storage/')}';
  }

  String get _submitEndpoint {
    if (widget.notificationType.contains('construction-vehicle')) {
      return '${ApiLinkNames.server}/api/construction-vehicle-order-matches';
    } else if (widget.notificationType.contains('construction-equipment')) {
      return '${ApiLinkNames.server}/api/construction-equipment-order-matches';
    } else if (widget.notificationType.contains('construction-attachment')) {
      return '${ApiLinkNames.server}/api/construction-attachment-order-matches';
    } else {
      return '${ApiLinkNames.server}/api/transportation-vehicle-order-matches';
    }
  }

  Future<void> _submitOffer() async {
    if (isSubmitting) return;

    setState(() => isSubmitting = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        _showSnackBar('You are not logged in. Please log in again.',
            Colors.red);
        return;
      }

      Map<String, dynamic> body = {
        'order_id': widget.orderData['order_id'],
      };

      // Only send the price fields relevant to this demand, and only when
      // the provider filled them.
      if (pricePerDayController.text.trim().isNotEmpty) {
        body['price_per_day'] = num.tryParse(pricePerDayController.text.trim());
      }
      if (needsOperator && operatorPriceController.text.trim().isNotEmpty) {
        body['operator_price'] = num.tryParse(operatorPriceController.text.trim());
      }
      if (needsTransport && transportPriceController.text.trim().isNotEmpty) {
        body['transport_price'] = num.tryParse(transportPriceController.text.trim());
      }
      if (isTransportation && isPerDistance &&
          distancePriceController.text.trim().isNotEmpty) {
        body['price_of_distance'] =
            num.tryParse(distancePriceController.text.trim());
      }

      var response = await http.post(
        Uri.parse(_submitEndpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        _showSnackBar('Your offer has been sent to the renter.', Colors.green);
        await Future.delayed(const Duration(milliseconds: 1200));
        Get.back();
      } else if (response.statusCode == 409) {
        _showSnackBar(
            'You already sent an offer for this demand.', Colors.orange);
      } else if (response.statusCode == 403) {
        _showSnackBar(
            'You do not own an approved machine matching this demand.',
            Colors.red);
      } else if (response.statusCode == 401) {
        _showSnackBar('Only providers can send offers.', Colors.red);
      } else {
        String message = 'Failed to send the offer. Please try again.';
        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map && decoded['message'] != null) {
            message = decoded['message'].toString();
          }
        } catch (_) {}
        _showSnackBar(message, Colors.red);
      }
    } catch (e) {
      print('Error submitting offer: $e');
      _showSnackBar('An error occurred. Please try again.', Colors.red);
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 10,
          right: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String subCategoryLabel =
        widget.orderData['${machinePrefix}_sub_category']?.toString() ??
            'Unknown';
    final String brand =
        widget.orderData['${machinePrefix}_brand']?.toString() ?? 'Unknown';
    final String model =
        widget.orderData['${machinePrefix}_model']?.toString() ?? 'Unknown';
    final String city =
        widget.orderData['${machinePrefix}_city']?.toString() ?? 'Unknown';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildHeader(subCategoryLabel, _machinePhotoUrl),
                const Divider(),
                _buildDetailRow('Machine', '$brand $model'),
                _buildDetailRow('City', city),
                _buildDetailRow(
                    'Capacity', widget.orderData['capacity']?.toString() ?? '-'),
                _buildDetailRow(
                    'Quantity', widget.orderData['quantity']?.toString() ?? '-'),
                _buildDetailRow('Start date',
                    widget.orderData['start_date']?.toString() ?? '-'),
                _buildDetailRow('End date',
                    widget.orderData['end_date']?.toString() ?? '-'),
                if (widget.orderData['hour'] != null)
                  _buildDetailRow(
                      'Hour', widget.orderData['hour'].toString()),
                if (isTransportation)
                  _buildDetailRow('Need',
                      widget.orderData['your_need']?.toString() ?? '-'),
                if (isTransportation &&
                    widget.orderData['departure_location'] != null)
                  _buildDetailRow('Departure',
                      widget.orderData['departure_location'].toString()),
                if (isTransportation &&
                    widget.orderData['arrival_location'] != null)
                  _buildDetailRow('Arrival',
                      widget.orderData['arrival_location'].toString()),
                _buildDetailRow('Operator needed', needsOperator ? 'Yes' : 'No'),
                _buildDetailRow('Transport needed', needsTransport ? 'By us' : 'By renter'),
                const Divider(),
                _buildPriceSection(),
                const SizedBox(height: 8),
                const Text(
                  'Note: a 5% service fee is added to your daily price.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                _buildSubmitButton(),
                const SizedBox(height: 30),
              ],
            ),
            if (isSubmitting)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String machineLabel, String? imageUrl) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          width: 120,
          child: imageUrl != null && imageUrl.isNotEmpty
              ? AppNetworkImage(
                  imageUrl,
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
        const Text(
          'New renting demand - send your offer',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your offer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildEditableField(
            'Price per day (DZD)', pricePerDayController, TextInputType.number),
        if (needsOperator)
          _buildEditableField('Operator price (DZD)', operatorPriceController,
              TextInputType.number),
        if (needsTransport)
          _buildEditableField('Transport price (DZD)', transportPriceController,
              TextInputType.number),
        if (isTransportation && isPerDistance)
          _buildEditableField('Price of distance (DZD)',
              distancePriceController, TextInputType.number),
      ],
    );
  }

  Widget _buildEditableField(
      String label, TextEditingController controller, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
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
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      onPressed: isSubmitting ? null : _submitOffer,
      child: const Text('Send Offer', style: TextStyle(fontSize: 16)),
    );
  }
}
