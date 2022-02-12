import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_demo/core/employee_model.dart';
import 'package:sqflite_demo/core/employee_provider.dart';
import 'package:sqflite_demo/dbhelper.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.initializeDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => EmployeeProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Employee List'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final emp = Provider.of<EmployeeProvider>(context);

    void insertEmployeeRecord() async {
      print('added record');
      final count = await DatabaseHelper.getEmployeeCount(query: 'select count(*) from employee');
      final employee = EmployeeModel(
        id: count,
        name: faker.person.name(),
        job: faker.job.title(),
      );
      await DatabaseHelper.insert(model: employee, table: 'employee');
      setState(() {
        emp.generateEmployeeList();
      });
    }

    void deleteRecord({int? id}) async {
      await DatabaseHelper.delete(table: 'employee', where: 'id = ?', whereArgs: [id]);
    }

    void updateRecord({int? id, String? name}) async {
      print('updated to a random record');
      final employee = EmployeeModel(
        id: id,
        name: name,
        job: faker.job.title(),
      );
      await DatabaseHelper.update(model: employee, table: 'employee', where: 'id = ?', whereArgs: [id]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: insertEmployeeRecord,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: emp.employeeList.length,
                itemBuilder: (BuildContext context, int index) {
                  final info = emp.employeeList[index].id.toString();
                  return GestureDetector(
                    onTap: () {
                      updateRecord(
                        id: emp.employeeList[index].id,
                        name: emp.employeeList[index].name,
                      );
                      emp.generateEmployeeList();
                    },
                    child: Dismissible(
                      background: Container(color: Colors.red),
                      key: Key(info),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(emp.employeeList[index].id.toString()),
                            width: 20,
                          ),
                          const SizedBox(width: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(emp.employeeList[index].name!),
                              Text(emp.employeeList[index].job!),
                            ],
                          ),
                        ],
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          emp.employeeList.removeAt(index);
                          deleteRecord(id: emp.employeeList[index].id);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Employee ${emp.employeeList[index].name} data dismissed'),
                          ),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
