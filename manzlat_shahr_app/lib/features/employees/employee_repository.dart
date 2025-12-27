import 'package:hive/hive.dart';

import '../../services/storage/boxes.dart';
import 'employee.dart';

class EmployeeRepository {
  Box get _box => Hive.box(Boxes.employees);

  static Future<void> ensureOpen() async {
    if (!Hive.isBoxOpen(Boxes.employees)) {
      await Hive.openBox(Boxes.employees);
    }
  }

  List<Employee> listAll() {
    final keys = _box.keys.toList(growable: false);
    final employees = <Employee>[];
    for (final key in keys) {
      final value = _box.get(key);
      if (value is Map) {
        employees.add(Employee.fromMap(value));
      }
    }
    employees.sort((a, b) => b.createdAtMillis.compareTo(a.createdAtMillis));
    return employees;
  }

  Employee? findByUsername(String username) {
    final value = _box.get(username);
    if (value is Map) return Employee.fromMap(value);
    return null;
  }

  Future<void> upsert(Employee employee) async {
    await _box.put(employee.username, employee.toMap());
  }

  Future<void> delete(String username) async {
    await _box.delete(username);
  }
}

