import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'last_name')
  String? lastName;
  String? username;
  String? password;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'middle_name')
  String? middleName;
  @JsonKey(name: 'birth_date')
  String? birthDate;
  String? address;
  @JsonKey(name: 'phone_number')
  String? phoneNumber;
  String? gender;
  String? mail;
  String? language;
  List<Roles>? roles;
  List<Sectors>? sectors;
  Department? department;
  Polyclinic? polyclinic;


  ProfileModel({
    this.userId,
    this.lastName,
    this.username,
    this.password,
    this.firstName,
    this.middleName,
    this.birthDate,
    this.address,
    this.phoneNumber,
    this.gender,
    this.mail,
    this.language,
    this.roles,
    this.sectors,
    this.department,
    this.polyclinic,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@JsonSerializable()
class Roles {
  @JsonKey(name: 'role_id')
  int? roleId;
  @JsonKey(name: 'role_name')
  String? roleName;


  Roles({this.roleId, this.roleName});

  factory Roles.fromJson(Map<String, dynamic> json) =>
      _$RolesFromJson(json);

  Map<String, dynamic> toJson() => _$RolesToJson(this);
}

@JsonSerializable()
class Sectors {
  @JsonKey(name: 'SectorID')
  int? sectorId;
  @JsonKey(name: 'Number')
  int? number;
  @JsonKey(name: 'Address')
  String? address;


  Sectors({this.sectorId, this.number, this.address});

  factory Sectors.fromJson(Map<String, dynamic> json) =>
      _$SectorsFromJson(json);

  Map<String, dynamic> toJson() => _$SectorsToJson(this);
}

@JsonSerializable()
class Department {
  @JsonKey(name: 'department_id')
  int? departmentId;
  String? name;
  @JsonKey(name: 'polyclinic_id')
  int? polyclinicId;
  
  Department({this.departmentId, this.name, this.polyclinicId});

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}

@JsonSerializable()
class Polyclinic {
  @JsonKey(name: 'polyclinic_id')
  int? polyclinicId;
  @JsonKey(name: 'name')
  String? name;


  Polyclinic({this.polyclinicId, this.name});

  factory Polyclinic.fromJson(Map<String, dynamic> json) =>
      _$PolyclinicFromJson(json);

  Map<String, dynamic> toJson() => _$PolyclinicToJson(this);
}