class PatientModel {
  final String? id;
  final String? uchastok;
  final String surname;
  final String name;
  final String? middleName;
  final String iin;
  final String birthDate;
  final String gender;
  final String address;
  final String? email;
  final String contactPhone;
  final String? familyContactPhone;
  final double? height;
  final double? weight;
  final double? bmi;
  final bool hasHypertension;
  final bool hasHeartFailure;
  final bool hasDiabetes;
  final String? arterialPressure;
  final String? heartbeat;
  final String? sugarLevel;
  final String? lastBPDate;
  final String? lastSelfManagementDate;
  final String? smokingStatus;
  final String? confidenceLevel;
  final String? lastConfidenceDate;
  final String? hba1cValue;
  final String? hba1cDate;
  final String? ldlValue;
  final String? ldlDate;
  final bool? hasCVD;
  final String? footExamDate;
  final bool? hasRetinopathy;
  final String? retinopathyDate;
  final bool? takesStatin;
  final String? sakDate;

  const PatientModel({
    this.id,
    this.uchastok,
    required this.surname,
    required this.name,
    this.middleName,
    required this.iin,
    required this.birthDate,
    required this.gender,
    required this.address,
    this.email,
    required this.contactPhone,
    this.familyContactPhone,
    this.height,
    this.weight,
    this.bmi,
    required this.hasHypertension,
    required this.hasHeartFailure,
    required this.hasDiabetes,
    this.arterialPressure,
    this.heartbeat,
    this.sugarLevel,
    this.lastBPDate,
    this.lastSelfManagementDate,
    this.smokingStatus,
    this.confidenceLevel,
    this.lastConfidenceDate,
    this.hba1cValue,
    this.hba1cDate,
    this.ldlValue,
    this.ldlDate,
    this.hasCVD,
    this.footExamDate,
    this.hasRetinopathy,
    this.retinopathyDate,
    this.takesStatin,
    this.sakDate,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'],
      uchastok: json['uchastok'],
      surname: json['surname'] ?? '',
      name: json['name'] ?? '',
      middleName: json['middleName'],
      iin: json['iin'] ?? '',
      birthDate: json['birthDate'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      email: json['email'],
      contactPhone: json['contactPhone'] ?? '',
      familyContactPhone: json['familyContactPhone'],
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      hasHypertension: json['hasHypertension'] ?? false,
      hasHeartFailure: json['hasHeartFailure'] ?? false,
      hasDiabetes: json['hasDiabetes'] ?? false,
      arterialPressure: json['arterialPressure'],
      heartbeat: json['heartbeat'],
      sugarLevel: json['sugarLevel'],
      lastBPDate: json['lastBPDate'],
      lastSelfManagementDate: json['lastSelfManagementDate'],
      smokingStatus: json['smokingStatus'],
      confidenceLevel: json['confidenceLevel'],
      lastConfidenceDate: json['lastConfidenceDate'],
      hba1cValue: json['hba1cValue'],
      hba1cDate: json['hba1cDate'],
      ldlValue: json['ldlValue'],
      ldlDate: json['ldlDate'],
      hasCVD: json['hasCVD'],
      footExamDate: json['footExamDate'],
      hasRetinopathy: json['hasRetinopathy'],
      retinopathyDate: json['retinopathyDate'],
      takesStatin: json['takesStatin'],
      sakDate: json['sakDate'],
    );
  }

  // ✅ Преобразование модели в JSON (для сохранения в Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uchastok': uchastok,
      'surname': surname,
      'name': name,
      'middleName': middleName,
      'iin': iin,
      'birthDate': birthDate,
      'gender': gender,
      'address': address,
      'email': email,
      'contactPhone': contactPhone,
      'familyContactPhone': familyContactPhone,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'hasHypertension': hasHypertension,
      'hasHeartFailure': hasHeartFailure,
      'hasDiabetes': hasDiabetes,
      'arterialPressure': arterialPressure,
      'heartbeat': heartbeat,
      'sugarLevel': sugarLevel,
      'lastBPDate': lastBPDate,
      'lastSelfManagementDate': lastSelfManagementDate,
      'smokingStatus': smokingStatus,
      'confidenceLevel': confidenceLevel,
      'lastConfidenceDate': lastConfidenceDate,
      'hba1cValue': hba1cValue,
      'hba1cDate': hba1cDate,
      'ldlValue': ldlValue,
      'ldlDate': ldlDate,
      'hasCVD': hasCVD,
      'footExamDate': footExamDate,
      'hasRetinopathy': hasRetinopathy,
      'retinopathyDate': retinopathyDate,
      'takesStatin': takesStatin,
      'sakDate': sakDate,
    };
  }
}

