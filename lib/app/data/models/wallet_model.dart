class WalletModel {
  final String id;
  final double balance;

  WalletModel({required this.id, required this.balance});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id']?.toString() ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}

class WalletTransactionModel {
  final String id;
  final String type;
  final double amount;
  final String description;
  final DateTime? createdAt;

  WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
