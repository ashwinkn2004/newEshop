class ProductModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    this.isFavorite = false,
  });

  ProductModel copyWith({bool? isFavorite}) {
    return ProductModel(
      id: id,
      name: name,
      image: image,
      category: category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
