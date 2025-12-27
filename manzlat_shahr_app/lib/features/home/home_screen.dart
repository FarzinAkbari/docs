import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_controller.dart';
import '../employees/employee_management_screen.dart';
import '../loans/loan_type.dart';
import '../loans/loan_wizard_screen.dart';
import '../auth/login_role_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final role = auth.state.role;
    final username = auth.state.username ?? '';
    final isAdmin = role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('منزلت شهر'),
        actions: [
          IconButton(
            tooltip: 'خروج',
            onPressed: () {
              auth.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginRoleScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'خوش آمدید',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isAdmin ? 'مدیر: $username' : 'کارمند: $username',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.group_add_outlined),
              label: const Text('مدیریت کارمندان (افزودن/حذف)'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EmployeeManagementScreen()),
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'انتخاب نوع وام',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          for (final type in LoanType.values) ...[
            _LoanCard(
              type: type,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => LoanWizardScreen(type: type)),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          Text(
            'پس از تکمیل فرم، رسید پیش‌ثبت‌نام قابل چاپ صادر می‌شود.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  const _LoanCard({required this.type, required this.onTap});
  final LoanType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.account_balance_wallet_outlined, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(type.subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left),
            ],
          ),
        ),
      ),
    );
  }
}

