class OwnerModel {
  final String email;
  final String name;
  final String phone;
  final List<String> venues;
  OwnerModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.venues
  });

  factory OwnerModel.fromMap(Map<String,dynamic> map){
    return OwnerModel(email: map["email"], name: map["name"], phone: map["phone"], venues: map["venues"]);
  }
}