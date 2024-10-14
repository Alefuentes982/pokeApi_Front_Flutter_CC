class Pokemon {
  final int id;
  final String name;
  final String types;
  final String image;
  bool captured;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.image,
    this.captured = false,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      types: json['types'],
      image: json['image'],
      captured: json['captured'] ?? false,
    );
  }
}
