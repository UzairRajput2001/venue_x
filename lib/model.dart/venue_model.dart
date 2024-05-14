// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

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
      'venueLocation': venueLocation,
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

  @override
  bool operator ==(covariant Venues other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.address == address &&
      listEquals(other.availableDates, availableDates) &&
      other.capacity == capacity &&
      other.description == description &&
      other.eventType == eventType &&
      other.imageUrl == imageUrl &&
      other.name == name &&
      other.userId == userId &&
      other.venueLocation == venueLocation;
  }

  @override
  int get hashCode {
    return address.hashCode ^
      availableDates.hashCode ^
      capacity.hashCode ^
      description.hashCode ^
      eventType.hashCode ^
      imageUrl.hashCode ^
      name.hashCode ^
      userId.hashCode ^
      venueLocation.hashCode;
  }
}
