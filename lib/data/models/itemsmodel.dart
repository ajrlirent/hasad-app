// class ItemsModel {
//   int? itemId;
//   int? catId;
//   String? name;
//   String? image;
//   double? price;
//   bool? haveattachments;

//   ItemsModel({this.itemId, this.catId, this.name, this.image, this.price,this.haveattachments});

//   ItemsModel.fromJson(Map<String, dynamic> json) {
//     itemId = json['itemId'];
//     catId = json['catId'];
//     name = json['name'];
//     image = json['image'];
//     price = json['price'];
//     haveattachments = json['haveattachments'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['itemId'] = itemId;
//     data['catId'] = catId;
//     data['name'] = name;
//     data['image'] = image;
//     data['price'] = price;
//     data['haveattachments'] = haveattachments;
//     return data;
//   }
// }
import 'package:hasad/constant/ApiLinkNames.dart';

class ItemsModel {
  final int id;
  final int categoryId;
  final String label;
  final String value;
  final String? photo; // Make photo nullable
  final bool haveattachments;

  ItemsModel({
    required this.id,
    required this.categoryId,
    required this.label,
    required this.value,
    this.photo, // Make optional
    required this.haveattachments,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) {
    return ItemsModel(
      id: json['id'],
      categoryId: json['category_id'],
      label: json['label'],
      value: json['value'],
      photo: constructImageUrl(json['photo']), // Can be null
      haveattachments: json['haveattachments'] ?? false,
    );
  }

  static String? constructImageUrl(String? url) {
    if (url == null) {
      return null;
    }
    if (url.startsWith('public/')) {
      url = url.replaceFirst('public/', '/');
    }
    return '${ApiLinkNames.images}$url'; // Replace with your actual base URL
  }
}
