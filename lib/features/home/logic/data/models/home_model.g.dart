// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
  'data': instance.data,
  'total': instance.total,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  userId: (json['user_id'] as num?)?.toInt(),
  lastName: json['last_name'] as String?,
  firstName: json['first_name'] as String?,
  middleName: json['middle_name'] as String?,
  iin: json['iin'] as String?,
  birthDate: json['birth_date'] as String?,
  address: json['address'] as String?,
  phoneNumber: json['phone_number'] as String?,
  relativePhoneNumber: json['relative_phone_number'] as String?,
  gender: json['gender'] as String?,
  mail: json['mail'] as String?,
  language: json['language'] as String?,
  heightCm: (json['height_cm'] as num?)?.toInt(),
  weightKg: (json['weight_kg'] as num?)?.toInt(),
  bloodPressure: json['blood_pressure'] as String?,
  sugarLevel: (json['sugar_level'] as num?)?.toInt(),
  heartRate: (json['heart_rate'] as num?)?.toInt(),
  diseases:
      (json['diseases'] as List<dynamic>?)
          ?.map((e) => Diseases.fromJson(e as Map<String, dynamic>))
          .toList(),
  sector:
      json['sector'] == null
          ? null
          : Sectors.fromJson(json['sector'] as Map<String, dynamic>),
  department:
      json['department'] == null
          ? null
          : Department.fromJson(json['department'] as Map<String, dynamic>),
  polyclinic:
      json['polyclinic'] == null
          ? null
          : Polyclinic.fromJson(json['polyclinic'] as Map<String, dynamic>),
  medStaffId: (json['med_staff_id'] as num?)?.toInt(),
  isActive: json['is_active'] as bool?,
  zone: json['zone'] as String?,
  lastSurveyAt: json['last_survey_at'] as String?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'user_id': instance.userId,
  'last_name': instance.lastName,
  'first_name': instance.firstName,
  'middle_name': instance.middleName,
  'iin': instance.iin,
  'birth_date': instance.birthDate,
  'address': instance.address,
  'phone_number': instance.phoneNumber,
  'relative_phone_number': instance.relativePhoneNumber,
  'gender': instance.gender,
  'mail': instance.mail,
  'language': instance.language,
  'height_cm': instance.heightCm,
  'weight_kg': instance.weightKg,
  'blood_pressure': instance.bloodPressure,
  'sugar_level': instance.sugarLevel,
  'heart_rate': instance.heartRate,
  'diseases': instance.diseases,
  'sector': instance.sector,
  'department': instance.department,
  'polyclinic': instance.polyclinic,
  'med_staff_id': instance.medStaffId,
  'is_active': instance.isActive,
  'zone': instance.zone,
  'last_survey_at': instance.lastSurveyAt,
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

Diseases _$DiseasesFromJson(Map<String, dynamic> json) => Diseases(
  diseaseId: (json['disease_id'] as num?)?.toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$DiseasesToJson(Diseases instance) => <String, dynamic>{
  'disease_id': instance.diseaseId,
  'name': instance.name,
};
