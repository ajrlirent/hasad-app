import 'package:hasad/constant/ApiLinkNames.dart';
class ProviderMachineModel {
  List<Vehicles>? vehicles;
  List<Equipments>? equipments;
  List<Attachments>? attachments;

  ProviderMachineModel({this.vehicles, this.equipments, this.attachments});

  ProviderMachineModel.fromJson(Map<String, dynamic> json) {
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(Vehicles.fromJson(v));
      });
    } else {
      vehicles = [];
    }

    if (json['equipments'] != null) {
      equipments = <Equipments>[];
      json['equipments'].forEach((v) {
        equipments!.add(Equipments.fromJson(v));
      });
    } else {
      equipments = [];
    }

    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    } else {
      attachments = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vehicles != null) {
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    }
    if (equipments != null) {
      data['equipments'] = equipments!.map((v) => v.toJson()).toList();
    }
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicles {
  int? id;
  int? categoryId;
  int? subCategoryId;
  String? brand;
  String? model;
  String? year;
  String? pricePerDay;
  String? pricePerMonth;
  String? offerType;
  String? transportPrice;
  String? operatorPrice;
  String? region;
  String? city;
  String? phoneNumber;
  String? activityStatus;
  String? approvalStatus;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? photo;

  Vehicles({
    this.id,
    this.categoryId,
    this.subCategoryId,
    this.brand,
    this.model,
    this.year,
    this.pricePerDay,
    this.pricePerMonth,
    this.offerType,
    this.transportPrice,
    this.operatorPrice,
    this.region,
    this.city,
    this.phoneNumber,
    this.activityStatus,
    this.approvalStatus,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.photo,
  });

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    brand = json['brand'];
    model = json['model'];
    year = json['year']?.toString();
    pricePerDay = json['price_per_day'];
    pricePerMonth = json['price_per_month'];
    offerType = json['offer_type'];
    transportPrice = json['transport_price'];
    operatorPrice = json['operator_price'];
    region = json['region'];
    city = json['city'];
    phoneNumber = json['phone_number'];
    activityStatus = json['activity_status'];
    approvalStatus = json['approval_status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    // Prefer the machine's own photo, fall back to sub-category photo
    String? photoPath;
    if (json['photos'] != null && (json['photos'] as List).isNotEmpty) {
      photoPath = json['photos'][0]['path'];
    } else {
      photoPath = json['sub_category']?['photo'];
    }
    if (photoPath != null) {
      photo = "${ApiLinkNames.server}/$photoPath";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['sub_category_id'] = subCategoryId;
    data['brand'] = brand;
    data['model'] = model;
    data['year'] = year;
    data['price_per_day'] = pricePerDay;
    data['price_per_month'] = pricePerMonth;
    data['offer_type'] = offerType;
    data['transport_price'] = transportPrice;
    data['operator_price'] = operatorPrice;
    data['region'] = region;
    data['city'] = city;
    data['phone_number'] = phoneNumber;
    data['activity_status'] = activityStatus;
    data['approval_status'] = approvalStatus;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['photo'] = photo;
    return data;
  }
}

class Equipments {
  int? id;
  int? subCategoryId;
  String? brand;
  String? model;
  String? year;
  String? pricePerDay;
  String? pricePerMonth;
  String? offerType;
  String? transportPrice;
  String? region;
  String? city;
  String? phoneNumber;
  String? activityStatus;
  String? approvalStatus;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? photo;

  Equipments({
    this.id,
    this.subCategoryId,
    this.brand,
    this.model,
    this.year,
    this.pricePerDay,
    this.pricePerMonth,
    this.offerType,
    this.transportPrice,
    this.region,
    this.city,
    this.phoneNumber,
    this.activityStatus,
    this.approvalStatus,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.photo,
  });

  Equipments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryId = json['sub_category_id'];
    brand = json['brand'];
    model = json['model'];
    year = json['year']?.toString();
    pricePerDay = json['price_per_day'];
    pricePerMonth = json['price_per_month'];
    offerType = json['offer_type'];
    transportPrice = json['transport_price'];
    region = json['region'];
    city = json['city'];
    phoneNumber = json['phone_number'];
    activityStatus = json['activity_status'];
    approvalStatus = json['approval_status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    String? photoPath;
    if (json['photos'] != null && (json['photos'] as List).isNotEmpty) {
      photoPath = json['photos'][0]['path'];
    } else {
      photoPath = json['sub_category']?['photo'];
    }
    photo = photoPath;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sub_category_id'] = subCategoryId;
    data['brand'] = brand;
    data['model'] = model;
    data['year'] = year;
    data['price_per_day'] = pricePerDay;
    data['price_per_month'] = pricePerMonth;
    data['offer_type'] = offerType;
    data['transport_price'] = transportPrice;
    data['region'] = region;
    data['city'] = city;
    data['phone_number'] = phoneNumber;
    data['activity_status'] = activityStatus;
    data['approval_status'] = approvalStatus;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['photo'] = photo;
    return data;
  }
}

class Attachments {
  int? id;
  int? subCategoryId;
  String? brand;
  String? model;
  String? label;
  String? year;
  String? pricePerDay;
  String? pricePerMonth;
  String? offerType;
  String? transportPrice;
  String? region;
  String? city;
  String? phoneNumber;
  String? activityStatus;
  String? approvalStatus;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? photo;

  Attachments({
    this.id,
    this.subCategoryId,
    this.brand,
    this.model,
    this.label,
    this.year,
    this.pricePerDay,
    this.pricePerMonth,
    this.offerType,
    this.transportPrice,
    this.region,
    this.city,
    this.phoneNumber,
    this.activityStatus,
    this.approvalStatus,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.photo,
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subCategoryId = json['sub_category_id'];
    brand = json['brand'];
    model = json['model'];
    label = json['label'];
    year = json['year']?.toString();
    pricePerDay = json['price_per_day'];
    pricePerMonth = json['price_per_month'];
    offerType = json['offer_type'];
    transportPrice = json['transport_price'];
    region = json['region'];
    city = json['city'];
    phoneNumber = json['phone_number'];
    activityStatus = json['activity_status'];
    approvalStatus = json['approval_status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    String? photoPath;
    if (json['photos'] != null && (json['photos'] as List).isNotEmpty) {
      photoPath = json['photos'][0]['path'];
    } else {
      photoPath = json['sub_category']?['photo'];
    }
    photo = photoPath;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sub_category_id'] = subCategoryId;
    data['brand'] = brand;
    data['model'] = model;
    data['label'] = label;
    data['year'] = year;
    data['price_per_day'] = pricePerDay;
    data['price_per_month'] = pricePerMonth;
    data['offer_type'] = offerType;
    data['transport_price'] = transportPrice;
    data['region'] = region;
    data['city'] = city;
    data['phone_number'] = phoneNumber;
    data['activity_status'] = activityStatus;
    data['approval_status'] = approvalStatus;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['photo'] = photo;
    return data;
  }
}
