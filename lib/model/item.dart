part of 'model.dart';

class Item {
  final int? id;
  final String name;
  final String unit;
  final int stock;
  final int? minStock;

  Item({
    this.id,
    required this.name,
    required this.unit,
    required this.stock,
    this.minStock,
  });

  /// Convert Map → Item (from SQLite row)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int?,
      name: map['name'] as String,
      unit: map['unit'] as String,
      stock: map['stock'] as int,
      minStock: map['min_stock'] as int?,
    );
  }

  /// Convert Item → Map (for SQLite insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'stock': stock,
      'min_stock': minStock,
    };
  }

  /// Clone with updated values
  Item copyWith({
    int? id,
    String? name,
    String? unit,
    int? stock,
    int? minStock,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      minStock: minStock ?? this.minStock,
    );
  }
}
