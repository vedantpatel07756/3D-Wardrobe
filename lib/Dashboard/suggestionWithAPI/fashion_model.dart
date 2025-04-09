// models/fashion_item.dart
class FashionItem {
  final String code;
  final String name;
  final String imageUrl;

  FashionItem({required this.code, required this.name, required this.imageUrl});

  factory FashionItem.fromJson(Map<String, dynamic> json) {
    return FashionItem(
      code: json['code'],
      name: json['name'],
      imageUrl: json['images'][0]['url'],
    );
  }
}
