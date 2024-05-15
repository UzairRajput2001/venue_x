class Venue {
  final String imagePath;
  final String name;
  final String description;
  final String event_type;
  final String address;
  final String location;
  final int capacity;
  final List<dynamic> dates; // Change the type to List<DateTime>

  Venue({
    required this.imagePath,
    required this.name,
    required this.capacity,
    required this.dates, // Update the constructor parameter type
    required this.address,
    required this.description,
    required this.event_type,
    required this.location,
  });
}
