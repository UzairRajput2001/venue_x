import 'dart:convert';

import 'package:flutter/foundation.dart';

class Venue {
  final String name;
  final String address;
  final String phone;
  final String email;
  final List<String> venues; 
  final List<DateTime> availableDates;
  final int capacity;
  final String description;
  final String eventType;
  final String imageUrl;
  final String venueLocation;

  Venue({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.venues,
    required this.availableDates,
    required this.capacity,
    required this.description,
    required this.eventType,
    required this.imageUrl,
    required this.venueLocation,
  });

  Venue copyWith({
    String? name,
    String? address,
    String? phone,
    String? email,
    List<String>? venues,
    List<DateTime>? availableDates,
    int? capacity,
    String? description,
    String? eventType,
    String? imageUrl,
    String? venueLocation,
  }) {
    return Venue(
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      venues: venues ?? this.venues,
      availableDates: availableDates ?? this.availableDates,
      capacity: capacity ?? this.capacity,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      imageUrl: imageUrl ?? this.imageUrl,
      venueLocation: venueLocation ?? this.venueLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'venues': venues,
      'availableDates': availableDates.map((x) => x.millisecondsSinceEpoch).toList(),
      'capacity': capacity,
      'description': description,
      'eventType': eventType,
      'imageUrl': imageUrl,
      'venueLocation': venueLocation,
    };
  }

  factory Venue.fromMap(Map<String, dynamic> map) {
    return Venue(
      name: map['name'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      venues: List<String>.from((map['venues'] as List<String>)),
      availableDates: List<DateTime>.from((map['availableDates'] as List<int>).map<DateTime>((x) => DateTime.fromMillisecondsSinceEpoch(x),),),
      capacity: map['capacity'] as int,
      description: map['description'] as String,
      eventType: map['eventType'] as String,
      imageUrl: map['imageUrl'] as String,
      venueLocation: map['venueLocation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Venue.fromJson(String source) => Venue.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Venue(name: $name, address: $address, phone: $phone, email: $email, venues: $venues, availableDates: $availableDates, capacity: $capacity, description: $description, eventType: $eventType, imageUrl: $imageUrl, venueLocation: $venueLocation)';
  }

  @override
  bool operator ==(covariant Venue other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.address == address &&
      other.phone == phone &&
      other.email == email &&
      listEquals(other.venues, venues) &&
      listEquals(other.availableDates, availableDates) &&
      other.capacity == capacity &&
      other.description == description &&
      other.eventType == eventType &&
      other.imageUrl == imageUrl &&
      other.venueLocation == venueLocation;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      address.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      venues.hashCode ^
      availableDates.hashCode ^
      capacity.hashCode ^
      description.hashCode ^
      eventType.hashCode ^
      imageUrl.hashCode ^
      venueLocation.hashCode;
  }
}
