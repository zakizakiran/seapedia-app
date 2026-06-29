double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

String _parseString(dynamic value, {List<String> mapKeys = const ['name', 'title', 'fullAddress', 'address', 'label']}) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) {
    for (final key in mapKeys) {
      if (value[key] != null) {
        return value[key].toString();
      }
    }
    return '';
  }
  return value.toString();
}

class OrderModel {
  final String id;
  final String buyerId;
  final String storeId;
  final String storeName;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double ppnAmount;
  final double discountAmount;
  final double totalAmount;
  final String shippingMethod;
  final String status;
  final String deliveryAddress;
  final List<OrderStatusHistory> statusHistory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.storeId,
    required this.storeName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.ppnAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.shippingMethod,
    required this.status,
    required this.deliveryAddress,
    this.statusHistory = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      buyerId: json['buyerId']?.toString() ?? '',
      storeId: json['storeId']?.toString() ?? '',
      storeName: _parseString(json['storeName'] ?? json['store'], mapKeys: ['name', 'title']),
      items: ((json['items'] ?? json['products']) is List)
          ? ((json['items'] ?? json['products']) as List)
              .map((e) => OrderItemModel.fromJson(e))
              .toList()
          : [],
      subtotal: _parseDouble(json['subtotal']),
      deliveryFee: _parseDouble(json['deliveryFee'] ?? json['shippingFee']),
      ppnAmount: _parseDouble(json['ppnAmount'] ?? json['ppn'] ?? json['tax']),
      discountAmount: _parseDouble(json['discountAmount'] ?? json['discount']),
      totalAmount: _parseDouble(json['totalAmount'] ?? json['total']),
      shippingMethod: _parseString(json['deliveryMethod'] ?? json['shippingMethod'], mapKeys: ['name', 'method', 'label']),
      status: _parseString(json['status'], mapKeys: ['name', 'status', 'label']),
      deliveryAddress: _parseString(json['deliveryAddress'] ?? json['address'], mapKeys: ['fullAddress', 'address', 'name']),
      statusHistory: (json['statusHistory'] is List)
          ? (json['statusHistory'] as List)
              .map((e) => OrderStatusHistory.fromJson(e))
              .toList()
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final double subtotal;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId']?.toString() ?? '',
      productName: _parseString(json['productName'] ?? json['name'] ?? json['product'], mapKeys: ['name', 'title']),
      productImage: _parseString(json['productImage'] ?? json['imageUrl'] ?? json['product'], mapKeys: ['imageUrl', 'image']),
      price: _parseDouble(json['price'] ?? (json['product'] is Map ? json['product']['price'] : null)),
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      subtotal: _parseDouble(json['subtotal'] ?? json['total']),
    );
  }
}

class OrderStatusHistory {
  final String status;
  final DateTime? timestamp;

  OrderStatusHistory({required this.status, this.timestamp});

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      status: json['status'] ?? '',
      timestamp: (json['timestamp'] ?? json['createdAt']) != null
          ? DateTime.tryParse((json['timestamp'] ?? json['createdAt']).toString())
          : null,
    );
  }
}
