class Customer {
  final int id;
  final String name;
  final String mobileNumber;
  final String address;
  final String aadhaarNumber;
  final String? notes;

  Customer({required this.id, required this.name, required this.mobileNumber, required this.address, required this.aadhaarNumber, this.notes});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'],
        name: json['name'],
        mobileNumber: json['mobile_number'],
        address: json['address'],
        aadhaarNumber: json['aadhaar_number'],
        notes: json['notes'],
      );
}
