import 'package:flutter/material.dart';

import 'employee.dart';
import 'employee_repository.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  final EmployeeRepository _repo = EmployeeRepository();
  List<Employee> _employees = const [];

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() => _employees = _repo.listAll());
  }

  Future<void> _addEmployeeDialog() async {
    final username = TextEditingController();
    final fullName = TextEditingController();
    final pin = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('افزودن کارمند'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fullName,
                  decoration: const InputDecoration(labelText: 'نام و نام خانوادگی'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'اجباری' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: username,
                  decoration: const InputDecoration(labelText: 'نام کاربری'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'اجباری' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: pin,
                  decoration: const InputDecoration(labelText: 'پین (مثلاً 1234)'),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.trim().length < 4) ? 'حداقل ۴ رقم' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لغو')),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.of(ctx).pop(true);
              },
              child: const Text('ثبت'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    final u = username.text.trim();
    final employee = Employee(
      username: u,
      pin: pin.text.trim(),
      fullName: fullName.text.trim(),
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
    );

    await _repo.upsert(employee);
    _reload();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کارمند اضافه شد')));
  }

  Future<void> _deleteEmployee(String username) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف کارمند'),
        content: Text('کارمند «$username» حذف شود؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('خیر')),
          FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('بله')),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.delete(username);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مدیریت کارمندان')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addEmployeeDialog,
        icon: const Icon(Icons.person_add_alt_1_outlined),
        label: const Text('افزودن'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'کارمندان برای ورود باید «نام کاربری + پین» داشته باشند.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_employees.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('هنوز کارمندی اضافه نشده است')))
          else
            for (final e in _employees) ...[
              Card(
                child: ListTile(
                  title: Text(e.fullName, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('نام کاربری: ${e.username}'),
                  trailing: IconButton(
                    tooltip: 'حذف',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deleteEmployee(e.username),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

