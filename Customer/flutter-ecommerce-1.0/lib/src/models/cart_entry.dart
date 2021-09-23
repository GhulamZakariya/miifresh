import 'package:hive/hive.dart';

part 'cart_entry.g.dart';

@HiveType(typeId: 0)
class CartEntry {
  @HiveField(0)
  String id;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  String attributes;

  CartEntry({this.id, this.quantity, this.attributes});
}
