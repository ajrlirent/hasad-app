class EquipmentOrderPayload {
  final int subCategoryId;
  final String operator;
  final String capacity;
  final String quantity;
  final String startDate;
  final String endDate;
  final String hour;
  final bool transport;
  final String moreDetails;
  final List<String> photos;

  EquipmentOrderPayload({
    required this.subCategoryId,
    required this.operator,
    required this.capacity,
    required this.quantity,
    required this.startDate,
    required this.endDate,
    required this.hour,
    required this.transport,
    required this.moreDetails,
    required this.photos,
  });

  Map<String, dynamic> toJson() {
    return {
      'sub_category_id': subCategoryId,
      'operator': operator,
      'capacity': capacity,
      'quantity': quantity,
      'start_date': startDate,
      'end_date': endDate,
      'hour': hour,
      'transport': transport,
      'more_details': moreDetails,
      'photos': photos,
    };
  }
}
