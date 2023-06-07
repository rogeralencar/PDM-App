class User {
  int? age;
  String? bio;
  String? cep;
  String? cpf;
  String? email;
  String? gender;
  String? image;
  String? name;
  String? phoneNumber;
  String? socialName;

  User({
    this.age,
    this.bio,
    this.cep,
    this.cpf,
    this.email,
    this.gender,
    this.image,
    this.name,
    this.phoneNumber,
    this.socialName,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age ?? 0,
      'bio': bio ?? '',
      'cep': cep ?? '',
      'cpf': cpf ?? '',
      'email': email ?? '',
      'gender': gender ?? '',
      'image': image ?? '',
      'name': name ?? '',
      'phoneNumber': phoneNumber ?? '',
      'socialName': socialName ?? ''
    };
  }
}
