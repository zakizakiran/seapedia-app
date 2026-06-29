class AddressModel {
  final String id;
  final String label;
  final String recipientName;
  final String phone;
  final String fullAddress;
  final String city;
  final String postalCode;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.fullAddress,
    required this.city,
    required this.postalCode,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    String rawAddress = json['fullAddress'] ?? json['address'] ?? '';
    String parsedFull = rawAddress;
    String parsedCity = json['city'] ?? '';
    String parsedPostal = json['postalCode'] ?? '';

    if (parsedCity.isEmpty && parsedPostal.isEmpty) {
      final commaIndex = rawAddress.lastIndexOf(',');
      if (commaIndex != -1) {
        parsedFull = rawAddress.substring(0, commaIndex).trim();
        final cityPostal = rawAddress.substring(commaIndex + 1).trim();
        final spaceIndex = cityPostal.lastIndexOf(' ');
        if (spaceIndex != -1) {
          parsedCity = cityPostal.substring(0, spaceIndex).trim();
          parsedPostal = cityPostal.substring(spaceIndex + 1).trim();
        } else {
          parsedCity = cityPostal;
        }
      }
    }

    return AddressModel(
      id: json['id']?.toString() ?? '',
      label: json['title'] ?? json['label'] ?? '',
      recipientName: json['recipientName'] ?? '',
      phone: json['phoneNumber'] ?? json['phone'] ?? '',
      fullAddress: parsedFull,
      city: parsedCity,
      postalCode: parsedPostal,
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'recipientName': recipientName,
      'phone': phone,
      'fullAddress': fullAddress,
      'city': city,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }
}
