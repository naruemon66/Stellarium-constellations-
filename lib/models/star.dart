class Star {
  final int? id;
  final String name;
  final double brightness;
  final double distance;
  final double size;
  final String? imagePath;
  final DateTime date;
  final int isUserAdded;

  Star({
    this.id,
    required this.name,
    required this.brightness,
    required this.distance,
    required this.size,
    this.imagePath,
    required this.date,
    required this.isUserAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brightness': brightness,
      'distance': distance,
      'size': size,
      'imagePath': imagePath,
      'date': date.toIso8601String(),
      'isUserAdded': isUserAdded,
    };
  }

  factory Star.fromMap(Map<String, dynamic> map) {
    return Star(
      id: map['id'],
      name: map['name'],
      brightness: map['brightness'],
      distance: map['distance'],
      size: map['size'],
      imagePath: map['imagePath'],
      date: DateTime.parse(map['date']),
      isUserAdded: map['isUserAdded'],
    );
  }
}
