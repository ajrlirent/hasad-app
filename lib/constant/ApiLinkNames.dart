class ApiLinkNames {
  /// Backend base URL.
  ///
  /// Local LAN default. For cloud builds override it without touching code:
  ///   flutter build apk --release \
  ///     --dart-define=API_BASE_URL=https://hasad-api.onrender.com
  static const String server = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: "http://192.168.1.7:8000",
  );
  static const images = "$server/storage";
// ======================Images==================================

  static const providerMachines = "$server/api/provider-machines";
  static const demanderMachines = "$server/api/renter-machines";

  static const submitEquipmentOrder =
      "$server/api/construction-equipment-orders";

  static const submitAttachmentOrder =
      "$server/api/construction-attachment-orders";

  static const submitTransportationVehicleOrder =
      "$server/api/transportation-vehicle-orders";

  static const submitConstructionVehicleOrder =
      "$server/api/construction-vehicle-orders";
}
