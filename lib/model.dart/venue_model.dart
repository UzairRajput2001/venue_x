import 'dart:convert';

class Venues {
  final String address;
  final List<String> availableDates;
  final int capacity;
  final String description;
  final String eventType;
  final String imageUrl;
  final String name;
  final String userId;
  final String venueLocation;

  Venues({
    required this.address,
    required this.availableDates,
    required this.capacity,
    required this.description,
    required this.eventType,
    required this.imageUrl,
    required this.name,
    required this.userId,
    required this.venueLocation,
  });

  Venues copyWith({
    String? address,
    List<String>? availableDates,
    int? capacity,
    String? description,
    String? eventType,
    String? imageUrl,
    String? name,
    String? userId,
    String? venueLocation,
  }) {
    return Venues(
      address: address ?? this.address,
      availableDates: availableDates ?? this.availableDates,
      capacity: capacity ?? this.capacity,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      venueLocation: venueLocation ?? this.venueLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'availableDates': availableDates,
      'capacity': capacity,
      'description': description,
      'eventType': eventType,
      'imageUrl': imageUrl,
      'name': name,
      'userId': userId,
      'venue_location': venueLocation,
    };
  }

  factory Venues.fromMap(Map<String, dynamic> map) {
    return Venues(
      address: map['address'] as String,
      availableDates: List<String>.from((map['availableDates'] ??[])),
      capacity: map['capacity'] as int,
      description: map['description'] as String,
      eventType: map['eventType'] ?? "",
      imageUrl: map['imageUrl'] ??"",
      name: map['name'] as String,
      userId: map['userId'] as String,
      venueLocation: map['venueLocation']?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Venues.fromJson(String source) => Venues.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Venues(address: $address, availableDates: $availableDates, capacity: $capacity, description: $description, eventType: $eventType, imageUrl: $imageUrl, name: $name, userId: $userId, venueLocation: $venueLocation)';
  }
}
