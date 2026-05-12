class UserModel {
  final String id;
  final String name;
  final String phone;

  UserModel({required this.id, required this.name, required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone};
}
