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
    return AddressModel(
      id: json['id']?.toString() ?? '',
      label: json['title'] ?? json['label'] ?? '',
      recipientName: json['recipientName'] ?? '',
      phone: json['phoneNumber'] ?? json['phone'] ?? '',
      fullAddress: json['fullAddress'] ?? json['address'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
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
