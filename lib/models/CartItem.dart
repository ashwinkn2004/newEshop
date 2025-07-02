import 'package:eshop/models/Model.dart';

class CartItem extends Model {
  static const String PRODUCT_ID_KEY = "product_id";
  static const String ITEM_COUNT_KEY = "item_count";

  final String? productId;
  int itemCount;

  CartItem({
    String? id,
    this.productId,
    this.itemCount = 0,
  }) : super(id!);

  factory CartItem.fromMap(Map<String, dynamic> map, {String? id}) {
    return CartItem(
      id: id,
      productId: map[PRODUCT_ID_KEY],
      itemCount: map[ITEM_COUNT_KEY] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      PRODUCT_ID_KEY: productId,
      ITEM_COUNT_KEY: itemCount,
    };
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    return {
      if (productId != null) PRODUCT_ID_KEY: productId,
      ITEM_COUNT_KEY: itemCount,
    };
  }
}
