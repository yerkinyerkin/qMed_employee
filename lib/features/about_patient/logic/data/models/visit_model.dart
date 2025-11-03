class VisitModel {
  final VisitGeneral? visitGeneral;
  final double? ldl;
  final String? ldlDate;
  final double? cholesterol;
  final String? cholesterolDate;
  final int? riskLevel;
  final String? nyhaClass;
  final int? ejectionFraction;
  final String? echoDate;
  final bool? takesBetaBlockers;
  final bool? takesACEInhibitor;
  final bool? takesAldosteroneAntagonists;
  final String? hospitalizationDate;
  final String? fluVaccinationDate;
  final int? egfr;
  final bool? hasEchoECGStudy;
  final bool? hasLeftVentricularDysfunction;
  final double? hba1c;
  final String? hba1cDate;
  final bool? hasCVD;
  final String? footExamDate;
  final bool? hasRetinopathy;
  final String? retinopathyExamDate;
  final bool? takesStatin;
  final String? sakDate;

  VisitModel({
    this.visitGeneral,
    this.ldl,
    this.ldlDate,
    this.cholesterol,
    this.cholesterolDate,
    this.riskLevel,
    this.nyhaClass,
    this.ejectionFraction,
    this.echoDate,
    this.takesBetaBlockers,
    this.takesACEInhibitor,
    this.takesAldosteroneAntagonists,
    this.hospitalizationDate,
    this.fluVaccinationDate,
    this.egfr,
    this.hasEchoECGStudy,
    this.hasLeftVentricularDysfunction,
    this.hba1c,
    this.hba1cDate,
    this.hasCVD,
    this.footExamDate,
    this.hasRetinopathy,
    this.retinopathyExamDate,
    this.takesStatin,
    this.sakDate,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      visitGeneral: json['visit_general'] != null
          ? VisitGeneral.fromJson(json['visit_general'])
          : null,
      ldl: (json['ldl'] as num?)?.toDouble(),
      ldlDate: json['ldl_date'],
      cholesterol: (json['cholesterol'] as num?)?.toDouble(),
      cholesterolDate: json['cholesterol_date'],
      riskLevel: json['risk_level'],
      nyhaClass: json['nyha_class'],
      ejectionFraction: json['ejection_fraction'],
      echoDate: json['echo_date'],
      takesBetaBlockers: json['takes_beta_blockers'],
      takesACEInhibitor: json['takes_ace_inhibitor'],
      takesAldosteroneAntagonists: json['takes_aldosterone_antagonists'],
      hospitalizationDate: json['hospitalization_date'],
      fluVaccinationDate: json['flu_vaccination_date'],
      egfr: json['egfr'],
      hasEchoECGStudy: json['has_echo_ecg_study'],
      hasLeftVentricularDysfunction: json['has_left_ventricular_dysfunction'],
      hba1c: (json['hba1c'] as num?)?.toDouble(),
      hba1cDate: json['hba1c_date'],
      hasCVD: json['has_cvd'],
      footExamDate: json['foot_exam_date'],
      hasRetinopathy: json['has_retinopathy'],
      retinopathyExamDate: json['retinopathy_exam_date'],
      takesStatin: json['takes_statin'],
      sakDate: json['sak_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (visitGeneral != null) 'visit_general': visitGeneral!.toJson(),
      if (ldl != null) 'ldl': ldl,
      if (ldlDate != null) 'ldl_date': ldlDate,
      if (cholesterol != null) 'cholesterol': cholesterol,
      if (cholesterolDate != null) 'cholesterol_date': cholesterolDate,
      if (riskLevel != null) 'risk_level': riskLevel,
      if (nyhaClass != null) 'nyha_class': nyhaClass,
      if (ejectionFraction != null) 'ejection_fraction': ejectionFraction,
      if (echoDate != null) 'echo_date': echoDate,
      if (takesBetaBlockers != null) 'takes_beta_blockers': takesBetaBlockers,
      if (takesACEInhibitor != null) 'takes_ace_inhibitor': takesACEInhibitor,
      if (takesAldosteroneAntagonists != null)
        'takes_aldosterone_antagonists': takesAldosteroneAntagonists,
      if (hospitalizationDate != null) 'hospitalization_date': hospitalizationDate,
      if (fluVaccinationDate != null) 'flu_vaccination_date': fluVaccinationDate,
      if (egfr != null) 'egfr': egfr,
      if (hasEchoECGStudy != null) 'has_echo_ecg_study': hasEchoECGStudy,
      if (hasLeftVentricularDysfunction != null)
        'has_left_ventricular_dysfunction': hasLeftVentricularDysfunction,
      if (hba1c != null) 'hba1c': hba1c,
      if (hba1cDate != null) 'hba1c_date': hba1cDate,
      if (hasCVD != null) 'has_cvd': hasCVD,
      if (footExamDate != null) 'foot_exam_date': footExamDate,
      if (hasRetinopathy != null) 'has_retinopathy': hasRetinopathy,
      if (retinopathyExamDate != null) 'retinopathy_exam_date': retinopathyExamDate,
      if (takesStatin != null) 'takes_statin': takesStatin,
      if (sakDate != null) 'sak_date': sakDate,
    };
  }
}

class VisitGeneral {
  final int? heightCm;
  final int? weightKg;
  final double? bmi;
  final int? systolicBp;
  final int? diastolicBp;
  final String? bpMeasurementDate;
  final String? selfManagementGoalDate;
  final bool? smokingStatus;
  final String? smokingStatusAssessmentDate;
  final String? smokingCessationCounselingDate;
  final int? selfConfidenceLevel;
  final String? selfConfidenceAssessmentDate;

  VisitGeneral({
    this.heightCm,
    this.weightKg,
    this.bmi,
    this.systolicBp,
    this.diastolicBp,
    this.bpMeasurementDate,
    this.selfManagementGoalDate,
    this.smokingStatus,
    this.smokingStatusAssessmentDate,
    this.smokingCessationCounselingDate,
    this.selfConfidenceLevel,
    this.selfConfidenceAssessmentDate,
  });

  factory VisitGeneral.fromJson(Map<String, dynamic> json) {
    return VisitGeneral(
      heightCm: json['height_cm'],
      weightKg: json['weight_kg'],
      bmi: (json['bmi'] as num?)?.toDouble(),
      systolicBp: json['systolic_bp'],
      diastolicBp: json['diastolic_bp'],
      bpMeasurementDate: json['bp_measurement_date'],
      selfManagementGoalDate: json['self_management_goal_date'],
      smokingStatus: json['smoking_status'],
      smokingStatusAssessmentDate: json['smoking_status_assessment_date'],
      smokingCessationCounselingDate: json['smoking_cessation_counseling_date'],
      selfConfidenceLevel: json['self_confidence_level'],
      selfConfidenceAssessmentDate: json['self_confidence_assessment_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bmi != null) 'bmi': bmi,
      if (systolicBp != null) 'systolic_bp': systolicBp,
      if (diastolicBp != null) 'diastolic_bp': diastolicBp,
      if (bpMeasurementDate != null) 'bp_measurement_date': bpMeasurementDate,
      if (selfManagementGoalDate != null) 'self_management_goal_date': selfManagementGoalDate,
      if (smokingStatus != null) 'smoking_status': smokingStatus,
      if (smokingStatusAssessmentDate != null)
        'smoking_status_assessment_date': smokingStatusAssessmentDate,
      if (smokingCessationCounselingDate != null)
        'smoking_cessation_counseling_date': smokingCessationCounselingDate,
      if (selfConfidenceLevel != null) 'self_confidence_level': selfConfidenceLevel,
      if (selfConfidenceAssessmentDate != null)
        'self_confidence_assessment_date': selfConfidenceAssessmentDate,
    };
  }
}

