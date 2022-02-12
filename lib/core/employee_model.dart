class EmployeeModel {
  final String? name, job;
  final int? id;

  EmployeeModel({this.id, this.name, this.job});

  Map<String, dynamic> toMap() {
    return {
      'id': id!,
      'name': name,
      'job': job,
    };
  }

  @override
  String toString() {
    super.toString();
    return 'EmployeeModel(id: $id, name: $name, age: $job)';
  }
}
