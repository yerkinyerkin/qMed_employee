class PatientModel {
  final int? sectorId;
  final String? lastName;
  final String? firstName;
  final String? middleName;
  final String? iin;
  final String? birthDate;
  final int? heightCm;
  final int? weightKg;
  final String? gender;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final String? familyContactPhone;
  final List<int>? diseases;
  final String? bloodPressure;
  final double? sugarLevel;
  final int? heartRate;
  final String? hba1cValue;
  final String? hba1cDate;
  final String? ldlValue;
  final String? ldlDate;
  final String? footExamDate;
  final String? retinopathyDate;
  final String? sakDate;
  final VisitData? visitData;

  const PatientModel({
    this.sectorId,
    this.lastName,
    this.firstName,
    this.middleName,
    this.iin,
    this.birthDate,
    this.heightCm,
    this.weightKg,
    this.gender,
    this.address,
    this.phoneNumber,
    this.email,
    this.familyContactPhone,
    this.diseases,
    this.bloodPressure,
    this.sugarLevel,
    this.heartRate,
    this.hba1cValue,
    this.hba1cDate,
    this.ldlValue,
    this.ldlDate,
    this.footExamDate,
    this.retinopathyDate,
    this.sakDate,
    this.visitData,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      sectorId: json['sector_id'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      iin: json['iin'],
      birthDate: json['birth_date'],
      heightCm: json['height_cm'],
      weightKg: json['weight_kg'],
      gender: json['gender'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      familyContactPhone: json['family_contact_phone'],
      diseases: json['diseases'] != null ? List<int>.from(json['diseases']) : null,
      bloodPressure: json['blood_pressure'],
      sugarLevel: (json['sugar_level'] as num?)?.toDouble(),
      heartRate: json['heart_rate'],
      hba1cValue: json['hba1c_value'],
      hba1cDate: json['hba1c_date'],
      ldlValue: json['ldl_value'],
      ldlDate: json['ldl_date'],
      footExamDate: json['foot_exam_date'],
      retinopathyDate: json['retinopathy_date'],
      sakDate: json['sak_date'],
      visitData: json['visit_data'] != null ? VisitData.fromJson(json['visit_data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sector_id': sectorId,
      'last_name': lastName,
      'first_name': firstName,
      'middle_name': middleName,
      'iin': iin,
      'birth_date': birthDate,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'gender': gender,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'family_contact_phone': familyContactPhone,
      'diseases': diseases,
      'blood_pressure': bloodPressure,
      'sugar_level': sugarLevel,
      'heart_rate': heartRate,
      'hba1c_value': hba1cValue,
      'hba1c_date': hba1cDate,
      'ldl_value': ldlValue,
      'ldl_date': ldlDate,
      'foot_exam_date': footExamDate,
      'retinopathy_date': retinopathyDate,
      'sak_date': sakDate,
      'visit_data': visitData?.toJson(),
    };
  }
}

class VisitData {
  final VisitHypertension? visitHypertension;

  VisitData({this.visitHypertension});

  factory VisitData.fromJson(Map<String, dynamic> json) {
    return VisitData(
      visitHypertension: json['visit_hypertension'] != null 
          ? VisitHypertension.fromJson(json['visit_hypertension']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visit_hypertension': visitHypertension?.toJson(),
    };
  }
}

class VisitHypertension {
  final int? ldl;
  final String? ldlDate;
  final int? cholesterol;
  final String? cholesterolDate;
  final int? riskLevel;
  final VisitGeneral? visitGeneral;

  VisitHypertension({
    this.ldl,
    this.ldlDate,
    this.cholesterol,
    this.cholesterolDate,
    this.riskLevel,
    this.visitGeneral,
  });

  factory VisitHypertension.fromJson(Map<String, dynamic> json) {
    return VisitHypertension(
      ldl: json['ldl'],
      ldlDate: json['ldl_date'],
      cholesterol: json['cholesterol'],
      cholesterolDate: json['cholesterol_date'],
      riskLevel: json['risk_level'],
      visitGeneral: json['visit_general'] != null 
          ? VisitGeneral.fromJson(json['visit_general']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ldl': ldl,
      'ldl_date': ldlDate,
      'cholesterol': cholesterol,
      'cholesterol_date': cholesterolDate,
      'risk_level': riskLevel,
      'visit_general': visitGeneral?.toJson(),
    };
  }
}

class VisitGeneral {
  final double? bmi;
  final String? bpMeasurementDate;
  final int? diastolicBp;
  final int? heightCm;
  final String? selfConfidenceAssessmentDate;
  final int? selfConfidenceLevel;
  final String? selfManagementGoalDate;
  final String? smokingCessationCounselingDate;
  final bool? smokingStatus;
  final String? smokingStatusAssessmentDate;
  final int? systolicBp;
  final int? weightKg;

  VisitGeneral({
    this.bmi,
    this.bpMeasurementDate,
    this.diastolicBp,
    this.heightCm,
    this.selfConfidenceAssessmentDate,
    this.selfConfidenceLevel,
    this.selfManagementGoalDate,
    this.smokingCessationCounselingDate,
    this.smokingStatus,
    this.smokingStatusAssessmentDate,
    this.systolicBp,
    this.weightKg,
  });

  factory VisitGeneral.fromJson(Map<String, dynamic> json) {
    return VisitGeneral(
      bmi: (json['bmi'] as num?)?.toDouble(),
      bpMeasurementDate: json['bp_measurement_date'],
      diastolicBp: json['diastolic_bp'],
      heightCm: json['height_cm'],
      selfConfidenceAssessmentDate: json['self_confidence_assessment_date'],
      selfConfidenceLevel: json['self_confidence_level'],
      selfManagementGoalDate: json['self_management_goal_date'],
      smokingCessationCounselingDate: json['smoking_cessation_counseling_date'],
      smokingStatus: json['smoking_status'],
      smokingStatusAssessmentDate: json['smoking_status_assessment_date'],
      systolicBp: json['systolic_bp'],
      weightKg: json['weight_kg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bmi': bmi,
      'bp_measurement_date': bpMeasurementDate,
      'diastolic_bp': diastolicBp,
      'height_cm': heightCm,
      'self_confidence_assessment_date': selfConfidenceAssessmentDate,
      'self_confidence_level': selfConfidenceLevel,
      'self_management_goal_date': selfManagementGoalDate,
      'smoking_cessation_counseling_date': smokingCessationCounselingDate,
      'smoking_status': smokingStatus,
      'smoking_status_assessment_date': smokingStatusAssessmentDate,
      'systolic_bp': systolicBp,
      'weight_kg': weightKg,
    };
  }
}

