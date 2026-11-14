import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class DemanderItemStatusCard extends StatelessWidget {
  final String? imageUrl, brand, model, userType, region, totalPrice;
  final Color statusColor;
  final String statusText;

  const DemanderItemStatusCard({
    super.key,
    this.imageUrl,
    this.brand,
    this.model,
    this.userType,
    this.region,
    this.totalPrice,
    required this.statusColor,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.width * .05, vertical: Get.height * .01),
      child: Card(
        elevation: 5,
        child: SizedBox(
          height: Get.height * .30, // Adjusting height to make it consistent
          width: Get.width, // Full width of the card
          child: Column(
            children: [
              Row(
                children: [
                  // Photo Section
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: AppNetworkImage(
                      imageUrl ??
                          'https://via.placeholder.com/150', // Fallback if imageUrl is null
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                            Icons.error); // Error icon if image fails
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Information Section
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brand ?? 'Unknown Brand', // Fallback if brand is null
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          model ?? 'Unknown Model', // Fallback if model is null
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              userType ??
                                  'Unknown User Type', // Fallback if userType is null
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              region ??
                                  'Unknown Region', // Fallback if region is null
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${totalPrice ?? '0'} DZD", // Fallback if totalPrice is null
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Status Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor:
                          statusColor, // The color changes based on status
                    ),
                    onPressed: () {
                      // Add any button functionality here if needed
                    },
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sample usage of the DemanderItemStatusCard
class DemanderHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demander Home'),
      ),
      body: ListView(
        children: [
          DemanderItemStatusCard(
            imageUrl: 'https://via.placeholder.com/150', // Placeholder image
            brand: 'JCB',
            model: 'Excavator SE 550',
            userType: 'Individuel',
            region: 'Alger, Khrecia',
            totalPrice: '261,322.00',
            statusColor: Colors.green,
            statusText: 'En travaille',
          ),
          DemanderItemStatusCard(
            imageUrl: 'https://via.placeholder.com/150', // Placeholder image
            brand: 'Caterpillar',
            model: 'Bulldozer D6T',
            userType: 'Société',
            region: 'Oran, Ain El Turk',
            totalPrice: '450,000.00',
            statusColor: Colors.red,
            statusText: 'Hors service',
          ),
          DemanderItemStatusCard(
            imageUrl: 'https://via.placeholder.com/150', // Placeholder image
            brand: 'Volvo',
            model: 'Excavator EC 950',
            userType: 'Individuel',
            region: 'Alger, Bab Ezzouar',
            totalPrice: '380,000.00',
            statusColor: Colors.orange,
            statusText: 'Complète',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    home: DemanderHome(),
  ));
}
