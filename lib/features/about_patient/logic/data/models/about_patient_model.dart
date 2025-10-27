class PatientModel {
  final int? userId;
  final String? lastName;
  final String? firstName;
  final String? middleName;
  final String? iin;
  final String? birthDate;
  final String? address;
  final String? phoneNumber;
  final String? relativePhoneNumber;
  final String? gender;
  final String? mail;
  final String? language;
  final int? heightCm;
  final int? weightKg;
  final String? bloodPressure;
  final double? sugarLevel;
  final int? heartRate;
  final List<Disease>? diseases;
  final Sector? sector;
  final Department? department;
  final Polyclinic? polyclinic;
  final int? medStaffId;
  final bool? isActive;
  final dynamic zone;
  final String? lastSurveyAt;

  PatientModel({
    this.userId,
    this.lastName,
    this.firstName,
    this.middleName,
    this.iin,
    this.birthDate,
    this.address,
    this.phoneNumber,
    this.relativePhoneNumber,
    this.gender,
    this.mail,
    this.language,
    this.heightCm,
    this.weightKg,
    this.bloodPressure,
    this.sugarLevel,
    this.heartRate,
    this.diseases,
    this.sector,
    this.department,
    this.polyclinic,
    this.medStaffId,
    this.isActive,
    this.zone,
    this.lastSurveyAt,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      userId: json['user_id'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      iin: json['iin'],
      birthDate: json['birth_date'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      relativePhoneNumber: json['relative_phone_number'],
      gender: json['gender'],
      mail: json['mail'],
      language: json['language'],
      heightCm: json['height_cm'],
      weightKg: json['weight_kg'],
      bloodPressure: json['blood_pressure'],
      sugarLevel: (json['sugar_level'] as num?)?.toDouble(),
      heartRate: json['heart_rate'],
      diseases: json['diseases'] != null
          ? List<Disease>.from(json['diseases'].map((x) => Disease.fromJson(x)))
          : null,
      sector: json['sector'] != null ? Sector.fromJson(json['sector']) : null,
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      polyclinic: json['polyclinic'] != null ? Polyclinic.fromJson(json['polyclinic']) : null,
      medStaffId: json['med_staff_id'],
      isActive: json['is_active'],
      zone: json['zone'],
      lastSurveyAt: json['last_survey_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'last_name': lastName,
      'first_name': firstName,
      'middle_name': middleName,
      'iin': iin,
      'birth_date': birthDate,
      'address': address,
      'phone_number': phoneNumber,
      'relative_phone_number': relativePhoneNumber,
      'gender': gender,
      'mail': mail,
      'language': language,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'blood_pressure': bloodPressure,
      'sugar_level': sugarLevel,
      'heart_rate': heartRate,
      'diseases': diseases?.map((x) => x.toJson()).toList(),
      'sector': sector?.toJson(),
      'department': department?.toJson(),
      'polyclinic': polyclinic?.toJson(),
      'med_staff_id': medStaffId,
      'is_active': isActive,
      'zone': zone,
      'last_survey_at': lastSurveyAt,
    };
  }
}

class Disease {
  final int diseaseId;
  final String name;

  Disease({
    required this.diseaseId,
    required this.name,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['disease_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'disease_id': diseaseId,
      'name': name,
    };
  }
}

class Sector {
  final int sectorId;
  final int number;
  final String address;

  Sector({
    required this.sectorId,
    required this.number,
    required this.address,
  });

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      sectorId: json['SectorID'],
      number: json['Number'],
      address: json['Address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SectorID': sectorId,
      'Number': number,
      'Address': address,
    };
  }
}

class Department {
  final int departmentId;
  final String name;
  final int polyclinicId;

  Department({
    required this.departmentId,
    required this.name,
    required this.polyclinicId,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['department_id'],
      name: json['name'],
      polyclinicId: json['polyclinic_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department_id': departmentId,
      'name': name,
      'polyclinic_id': polyclinicId,
    };
  }
}

class Polyclinic {
  final int polyclinicId;
  final String name;

  Polyclinic({
    required this.polyclinicId,
    required this.name,
  });

  factory Polyclinic.fromJson(Map<String, dynamic> json) {
    return Polyclinic(
      polyclinicId: json['polyclinic_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'polyclinic_id': polyclinicId,
      'name': name,
    };
  }
}
