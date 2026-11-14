// class CategoriesModel {
//   int? id;
//   int? typeId;
//   String? name;
//   String? icon;

//   CategoriesModel({this.id, this.name, this.icon, this.typeId});

//   CategoriesModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     typeId = json['typeId'];
//     name = json['name'];
//     icon = json['icon'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['typeId'] = typeId;
//     data['name'] = name;
//     data['icon'] = icon;
//     return data;
//   }
// }
class CategoriesModel {
  int id;
  String label;
  String value;

  CategoriesModel({
    required this.id,
    required this.label,
    required this.value,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      label: json['label'],
      value: json['value'],
    );
  }
}
