class LabTest {
  LabTest(
      {this.id,
      this.name,
      this.patient,
      this.pathologist,
      this.testType,
      this.state,
      this.requestor,
      this.dateAnalysis,
      this.dateRequested,
      this.labTestCriteria,
      this.results});

  int? id;
  String? name;
  String? dateAnalysis;
  String? patient,
      pathologist,
      dateRequested,
      requestor,
      results,
      state,
      testType;
  List<LabTestCriteria>? labTestCriteria;

  factory LabTest.fromJson(Map<String, dynamic> json) => LabTest(
      id: json["id"] as int,
      name: json["name"] as String,
      patient: json["patient"] as String,
      pathologist: json["pathologist"] as String,
      state: json["state"] as String,
      requestor: json["requestor"] as String,
      dateRequested: json["date_requested"] as String,
      dateAnalysis: json["date_analysis"].toString(),
      results: json["results"] as String,
      testType: json["test_type"] as String,
      labTestCriteria: json["lab_test_criteria"] == null
          ? null
          : List<LabTestCriteria>.from(
              json["lab_test_criteria"].map((x) => LabTestCriteria.fromJson(x)))

      // prescriptionLine: List<SubCategory>.from(json["prescription_line"].map((x) => PrescriptionLine.fromJson(x as Map<String, dynamic>)) as Iterable<dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "patient": patient,
        "pathologist": pathologist,
        "results": results,
        "state": state,
        "requestor": requestor,
        "date_analysis": dateAnalysis,
        "date_requested": dateRequested,
        "test_type": testType,
        "lab_test_criteria": labTestCriteria == null
            ? null
            : List<dynamic>.from(labTestCriteria!.map((x) => x.toJson())),
      };
}

class LabTestCriteria {
  LabTestCriteria({
    this.name,
    this.result,
    this.normalRange,
    this.unit,
  });

  String? name;
  String? result;
  String? normalRange;
  String? unit;

  factory LabTestCriteria.fromJson(Map<String, dynamic> json) =>
      LabTestCriteria(
        name: json["name"],
        result: json["result"],
        normalRange: json["normal_range"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "result": result,
        "normal_range": normalRange,
        "unit": unit,
      };
}
