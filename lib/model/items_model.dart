class Item {
  final String title;
  final String description;

  // Constructor
  Item({
    required this.title,
    required this.description,
  });

  // Factory method to create an instance of Item from a Map
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      title: map['title'] ?? '', // Default value if null
      description: map['description'] ?? '', // Default value if null
    );
  }

  // Method to convert Item object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }
}
