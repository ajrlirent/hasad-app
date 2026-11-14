import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

String? constructImageUrl(String? url) {
  if (url == null) return null;

  // If the URL contains '/api/public/', adjust to use 'storage/' instead of 'public/'
  if (url.contains('/api/public/')) {
    url = url.replaceFirst('/api/public/', '/storage/');
  }

  // Check if it's a relative path that starts with 'public/' and replace it with 'storage/'
  if (url.startsWith('public/')) {
    url = url.replaceFirst('public/', 'storage/');
  }

  // Prepend '${ApiLinkNames.server}/' for relative paths
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = '${ApiLinkNames.server}/$url'.replaceAll('//', '/');
    url = url.replaceFirst('http:/', 'http://'); // Ensure only one 'http://'
  }

  return url;
}

// Model for attachments
class Attachment {
  final String id;
  final String label;
  final String photo;

  Attachment({required this.id, required this.label, required this.photo});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'].toString(),
      label: json['label'],
      photo: json['photo'],
    );
  }
}

class AttachmentSelectionPopup extends StatefulWidget {
  final Map<String, Map<String, String>> selectedAttachments;

  AttachmentSelectionPopup({required this.selectedAttachments});

  @override
  _AttachmentSelectionPopupState createState() =>
      _AttachmentSelectionPopupState();
}

class _AttachmentSelectionPopupState extends State<AttachmentSelectionPopup> {
  List<Attachment> attachments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttachments();
  }

  Future<void> fetchAttachments() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiLinkNames.server}/api/vehicle-categories/10'));
      if (response.statusCode == 200) {
        setState(() {
          attachments = List<Attachment>.from(
              (jsonDecode(response.body) as List)
                  .map((e) => Attachment.fromJson(e)));

          for (var attachment in attachments) {
            print(
                "Fetched attachment: ID = ${attachment.id}, Label = ${attachment.label}");
          }

          isLoading = false;
        });
      } else {
        print(
            "Failed to fetch attachments. Status code: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching attachments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5, // The initial height of the modal
            minChildSize: 0.3, // Minimum height (30% of screen)
            maxChildSize: 0.5, // Maximum height (50% of screen)
            builder: (context, scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: attachments.length,
                itemBuilder: (context, index) {
                  final attachment = attachments[index];
                  String? imageUrl = constructImageUrl(attachment.photo);

                  bool isSelected =
                      widget.selectedAttachments.containsKey(attachment.id);

                  return ListTile(
                      leading: imageUrl != null
                          ? AppNetworkImage(imageUrl,
                              width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image_not_supported),
                      title: Text(attachment.label),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.circle_outlined),
                      onTap: () {
                        TextEditingController priceController =
                            TextEditingController();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Enter price for ${attachment.label}'),
                            content: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: 'Enter price'),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    // Ensure `photo` is added to the map
                                    widget.selectedAttachments[attachment.id] =
                                        {
                                      'name': attachment.label,
                                      'price': priceController.text,
                                      'imagePath': attachment
                                          .photo, // Add `imagePath` here
                                    };
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        );
                      });
                },
              );
            },
          );
  }
}

// Function to show the popup
Future<Map<String, Map<String, String>>?> showAttachmentPopup(
    BuildContext context,
    Map<String, Map<String, String>> selectedAttachments) async {
  return await showModalBottomSheet<Map<String, Map<String, String>>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Attachments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: AttachmentSelectionPopup(
              selectedAttachments: selectedAttachments,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedAttachments);
            },
            child: const Text("Confirm Selection"),
          ),
        ],
      ),
    ),
  );
}
