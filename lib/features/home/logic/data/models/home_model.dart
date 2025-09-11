import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeModel {
  List<Data>? data;
  int? total;

  HomeModel({this.data, this.total});

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'last_name')
  String? lastName;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'middle_name')
  String? middleName;
  String? iin;
  @JsonKey(name: 'birth_date')
  String? birthDate;
  String? address;
  @JsonKey(name: 'phone_number')
  String? phoneNumber;
  @JsonKey(name: 'relative_phone_number')
  String? relativePhoneNumber;
  String? gender;
  String? mail;
  String? language;
  @JsonKey(name: 'height_cm')
  int? heightCm;
  @JsonKey(name: 'weight_kg')
  int? weightKg;
  @JsonKey(name: 'blood_pressure')
  String? bloodPressure;
  @JsonKey(name: 'sugar_level')
  int? sugarLevel;
  @JsonKey(name: 'heart_rate')
  int? heartRate;
  List<Diseases>? diseases;
  Sectors? sector;
  Department? department;
  Polyclinic? polyclinic;
  @JsonKey(name: 'med_staff_id')
  int? medStaffId;
  @JsonKey(name: 'is_active')
  bool? isActive;
  String? zone;
  @JsonKey(name: 'last_survey_at')
  String? lastSurveyAt;

  Data({ this.userId,this.lastName,this.firstName,this.middleName,
  this.iin,this.birthDate,this.address,this.phoneNumber,this.relativePhoneNumber,
  this.gender,this.mail,this.language,this.heightCm,this.weightKg,
  this.bloodPressure,this.sugarLevel,this.heartRate,this.diseases,
  this.sector,this.department,this.polyclinic,this.medStaffId,
  this.isActive,this.zone,this.lastSurveyAt
  });

  factory Data.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
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

@JsonSerializable()
class Diseases {
  @JsonKey(name: 'disease_id')
  int? diseaseId;
  String? name;

  Diseases({this.diseaseId, this.name});

  factory Diseases.fromJson(Map<String, dynamic> json) =>
      _$DiseasesFromJson(json);

  Map<String, dynamic> toJson() => _$DiseasesToJson(this);
}