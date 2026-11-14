class DemanderMachineModel {
  List<Vehicles>? vehicles;
  List<Equipments>? equipments;
  List<Attachments>? attachments;
  List<TransportationVehicles>? transportationVehicles;

  DemanderMachineModel({
    this.vehicles,
    this.equipments,
    this.attachments,
    this.transportationVehicles,
  });

  DemanderMachineModel.fromJson(Map<String, dynamic> json) {
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

    if (json['transportation_vehicles'] != null) {
      transportationVehicles = <TransportationVehicles>[];
      json['transportation_vehicles'].forEach((v) {
        transportationVehicles!.add(TransportationVehicles.fromJson(v));
      });
    } else {
      transportationVehicles = [];
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
    if (transportationVehicles != null) {
      data['transportation_vehicles'] =
          transportationVehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicles {
  int? id;
  String? model;
  String? brand;
  String? renterActivityStatus;
  Match? match;

  Vehicles(
      {this.id, this.model, this.brand, this.renterActivityStatus, this.match});

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    renterActivityStatus = json['renter_activity_status'];
    match = json['match'] != null ? Match.fromJson(json['match']) : null;

    // Extract brand and model from the construction_vehicle object inside match
    brand = json['match']?['construction_vehicle']?['brand'] ?? 'Unknown Brand';
    model = json['match']?['construction_vehicle']?['model'] ?? 'Unknown Model';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['brand'] = brand;
    data['renter_activity_status'] = renterActivityStatus;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    return data;
  }
}

class Equipments {
  int? id;
  String? model;
  String? brand;
  String? renterActivityStatus;
  Match? match;

  Equipments(
      {this.id, this.model, this.brand, this.renterActivityStatus, this.match});

  Equipments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    renterActivityStatus = json['renter_activity_status'];
    match = json['match'] != null ? Match.fromJson(json['match']) : null;

    // Extract brand and model from the construction_equipment object inside match
    brand =
        json['match']?['construction_equipment']?['brand'] ?? 'Unknown Brand';
    model =
        json['match']?['construction_equipment']?['model'] ?? 'Unknown Model';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['brand'] = brand;
    data['renter_activity_status'] = renterActivityStatus;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    return data;
  }
}

class Attachments {
  int? id;
  String? model;
  String? brand;
  String? renterActivityStatus;
  Match? match;

  Attachments(
      {this.id, this.model, this.brand, this.renterActivityStatus, this.match});

  Attachments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    renterActivityStatus = json['renter_activity_status'];
    match = json['match'] != null ? Match.fromJson(json['match']) : null;

    // Extract brand and model from the construction_attachment object inside match
    brand =
        json['match']?['construction_attachment']?['brand'] ?? 'Unknown Brand';
    model =
        json['match']?['construction_attachment']?['model'] ?? 'Unknown Model';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['brand'] = brand;
    data['renter_activity_status'] = renterActivityStatus;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    return data;
  }
}

class TransportationVehicles {
  int? id;
  String? model;
  String? brand;
  String? renterActivityStatus;
  Match? match;

  TransportationVehicles(
      {this.id, this.model, this.brand, this.renterActivityStatus, this.match});

  TransportationVehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    renterActivityStatus = json['renter_activity_status'];
    match = json['match'] != null ? Match.fromJson(json['match']) : null;

    // Extract brand and model from the transportation_vehicle object inside match
    brand =
        json['match']?['transportation_vehicle']?['brand'] ?? 'Unknown Brand';
    model =
        json['match']?['transportation_vehicle']?['model'] ?? 'Unknown Model';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['brand'] = brand;
    data['renter_activity_status'] = renterActivityStatus;
    if (match != null) {
      data['match'] = match!.toJson();
    }
    return data;
  }
}

// Define Match class based on the response
class Match {
  String? totalPrice;
  String? region;

  Match({this.totalPrice, this.region});

  Match.fromJson(Map<String, dynamic> json) {
    totalPrice = json['total_price'];

    if (json.containsKey('construction_vehicle')) {
      region = json['construction_vehicle']?['region'];
    } else if (json.containsKey('construction_equipment')) {
      region = json['construction_equipment']?['region'];
    } else if (json.containsKey('construction_attachment')) {
      region = json['construction_attachment']?['region'];
    } else if (json.containsKey('transportation_vehicle')) {
      region = json['transportation_vehicle']?['region'];
    } else {
      region = json['region'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_price'] = totalPrice;
    data['region'] = region;
    return data;
  }
}
