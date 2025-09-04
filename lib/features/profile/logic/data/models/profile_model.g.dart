// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  userId: (json['user_id'] as num?)?.toInt(),
  lastName: json['last_name'] as String?,
  username: json['username'] as String?,
  password: json['password'] as String?,
  firstName: json['first_name'] as String?,
  middleName: json['middle_name'] as String?,
  birthDate: json['birth_date'] as String?,
  address: json['address'] as String?,
  phoneNumber: json['phone_number'] as String?,
  gender: json['gender'] as String?,
  mail: json['mail'] as String?,
  language: json['language'] as String?,
  roles:
      (json['roles'] as List<dynamic>?)
          ?.map((e) => Roles.fromJson(e as Map<String, dynamic>))
          .toList(),
  sectors:
      (json['sectors'] as List<dynamic>?)
          ?.map((e) => Sectors.fromJson(e as Map<String, dynamic>))
          .toList(),
  department:
      json['department'] == null
          ? null
          : Department.fromJson(json['department'] as Map<String, dynamic>),
  polyclinic:
      json['polyclinic'] == null
          ? null
          : Polyclinic.fromJson(json['polyclinic'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'last_name': instance.lastName,
      'username': instance.username,
      'password': instance.password,
      'first_name': instance.firstName,
      'middle_name': instance.middleName,
      'birth_date': instance.birthDate,
      'address': instance.address,
      'phone_number': instance.phoneNumber,
      'gender': instance.gender,
      'mail': instance.mail,
      'language': instance.language,
      'roles': instance.roles,
      'sectors': instance.sectors,
      'department': instance.department,
      'polyclinic': instance.polyclinic,
    };

Roles _$RolesFromJson(Map<String, dynamic> json) => Roles(
  roleId: (json['role_id'] as num?)?.toInt(),
  roleName: json['role_name'] as String?,
);

Map<String, dynamic> _$RolesToJson(Roles instance) => <String, dynamic>{
  'role_id': instance.roleId,
  'role_name': instance.roleName,
};

Sectors _$SectorsFromJson(Map<String, dynamic> json) => Sectors(
  sectorId: (json['SectorID'] as num?)?.toInt(),
  number: (json['Number'] as num?)?.toInt(),
  address: json['Address'] as String?,
);

Map<String, dynamic> _$SectorsToJson(Sectors instance) => <String, dynamic>{
  'SectorID': instance.sectorId,
  'Number': instance.number,
  'Address': instance.address,
};

Department _$DepartmentFromJson(Map<String, dynamic> json) => Department(
  departmentId: (json['department_id'] as num?)?.toInt(),
  name: json['name'] as String?,
  polyclinicId: (json['polyclinic_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'name': instance.name,
      'polyclinic_id': instance.polyclinicId,
    };

Polyclinic _$PolyclinicFromJson(Map<String, dynamic> json) => Polyclinic(
  polyclinicId: (json['polyclinic_id'] as num?)?.toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$PolyclinicToJson(Polyclinic instance) =>
    <String, dynamic>{
      'polyclinic_id': instance.polyclinicId,
      'name': instance.name,
    };
