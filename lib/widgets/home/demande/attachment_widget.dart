import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

// Utility function to construct image URL
// String? constructImageUrl(String? url) {
//   if (url == null) {
//     print("Image URL is null");
//     return null;
//   }

//   // If the URL contains '/api/public/', remove '/api/' and adjust it to use 'storage/' instead of 'public/'
//   if (url.contains('/api/public/')) {
//     url = url.replaceFirst('/api/public/', '/storage/');
//   }

//   // Check if it's a relative path that starts with 'public/' and replace it with 'storage/'
//   if (url.startsWith('public/')) {
//     url = url.replaceFirst('public/', '/storage/');
//   }

//   // Check if the URL is already a full URL, and return it without modification
//   if (url.startsWith('http://') || url.startsWith('https://')) {
//     print("Full URL provided: $url");
//     return url;
//   }

//   // Prepend the base URL to relative paths
//   String fullUrl = '${ApiLinkNames.server}/$url';

//   // Ensure proper formatting of slashes
//   fullUrl = fullUrl.replaceAll('//', '/').replaceFirst('http:/', 'http://');

//   // print("Constructed Image URL: $fullUrl");

//   return fullUrl;
// }
String? constructImageUrl(String? url) {
  if (url == null) {
    print("Image URL is null");
    return null;
  }

  // Ensure the URL replaces '/public/' with '/storage/'
  if (url.contains('/public/')) {
    url = url.replaceFirst('/public/', '/storage/');
  }

  // Prepend the base URL if it's a relative path without "http"
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = '${ApiLinkNames.server}/' + url.replaceFirst(RegExp(r'^/'), '');
  }

  print("Constructed Image URL: $url");
  return url;
}

class AttachmentScreen extends StatefulWidget {
  @override
  _AttachmentScreenState createState() => _AttachmentScreenState();
}

class _AttachmentScreenState extends State<AttachmentScreen> {
  List<Map<String, String>> attachments = []; // List to store attachments
  List<String> selectedIds = []; // Store selected attachment IDs
  final Dio _dio = Dio(); // Create Dio instance

  Future<void> fetchAttachments() async {
    try {
      final response =
          await _dio.get('${ApiLinkNames.server}/api/vehicle-categories/10');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          attachments = data.map((item) {
            String photoUrl = item['photo'] as String;
            // Replace 'public' with 'storage' in the URL
            if (photoUrl.contains('/public/')) {
              photoUrl = photoUrl.replaceFirst('/public/', '/storage/');
            }

            return {
              "id": item['id'].toString(),
              "label": item['label'] as String,
              "photo": "${ApiLinkNames.server}/$photoUrl", // Constructed full URL
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load attachments');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttachments();
  }

  @override
  Widget build(BuildContext context) {
    return attachments.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: attachments.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedIds.contains(attachments[index]['id']!)) {
                            selectedIds.remove(attachments[index]['id']!);
                          } else {
                            selectedIds.add(attachments[index]['id']!);
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          AttachmentCard(
                            label: attachments[index]['label']!,
                            imageUrl: attachments[index]['photo'],
                          ),
                          if (selectedIds.contains(attachments[index]['id']!))
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 24,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    selectedIds.map((id) {
                      return attachments
                          .firstWhere((attachment) => attachment['id'] == id);
                    }).toList(),
                  ); // Return full details of selected attachments
                },
                child: const Text("Confirm Selections"),
              ),
            ],
          );
  }
}

class AttachmentCard extends StatelessWidget {
  final String label;
  final String? imageUrl;

  const AttachmentCard({
    Key? key,
    required this.label,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: imageUrl != null
                  ? AppNetworkImage(
                      constructImageUrl(imageUrl)!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text("Error loading image");
                      },
                    )
                  : const Text("No Image Available"),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
