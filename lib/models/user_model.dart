class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    photoUrl: json['photoUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };
}
