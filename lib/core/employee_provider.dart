import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/core/employee_model.dart';
import 'package:sqflite_demo/dbhelper.dart';

final Database? db = DatabaseHelper.db;

class EmployeeProvider with ChangeNotifier {
  List<EmployeeModel> _employeeList = [];
  List<EmployeeModel> get employeeList => _employeeList;
  set employeeList(List<EmployeeModel> newValue) {
    _employeeList = newValue;
    notifyListeners();
  }

  // pag kuha ng employee list
  static Future<List<EmployeeModel>> getEmployeeList() async {
    final List<Map<String, dynamic>>? employeeMap = await db?.query('employee');
    return List.generate(
      employeeMap!.length,
      (index) {
        return EmployeeModel(
          id: employeeMap[index]['id'],
          name: employeeMap[index]['name'],
          job: employeeMap[index]['job'],
        );
      },
    );
  }

  void generateEmployeeList() async {
    _employeeList = await getEmployeeList();
    notifyListeners();
  }
}
