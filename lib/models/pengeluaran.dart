class Pengeluaran {
  final int? id;
  final String expense;
  final int cost;
  final String category;
  final DateTime updatedAt;
  final DateTime createdAt;

  Pengeluaran({
    this.id,
    required this.expense,
    required this.cost,
    required this.category,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Pengeluaran.fromJson(Map<String, dynamic> json) {
    return Pengeluaran(
      id: json['id'],
      expense: json['expense'],
      cost: json['cost'],
      category: json['category'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expense': expense,
      'cost': cost,
      'category': category,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
