class BookingRequest {
  final String id;
  final String venueName;
  final DateTime selectedDate;
  final String selectedCapacity;
  final String status;

  BookingRequest({
    required this.id,
    required this.venueName,
    required this.selectedDate,
    required this.selectedCapacity,
    required this.status,
  });
}