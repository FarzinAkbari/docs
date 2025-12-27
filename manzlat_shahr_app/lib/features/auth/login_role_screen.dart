import 'package:flutter/material.dart';

import 'auth_controller.dart';
import 'login_screen.dart';

class LoginRoleScreen extends StatelessWidget {
  const LoginRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('منزلت شهر')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'ورود به سامانه',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'لطفاً نوع ورود را انتخاب کنید',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              title: 'ورود کارمندان',
              subtitle: 'ثبت پیش‌درخواست وام',
              icon: Icons.badge_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(role: UserRole.employee),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _RoleCard(
              title: 'ورود مدیران',
              subtitle: 'مدیریت کارمندان + ثبت وام',
              icon: Icons.admin_panel_settings_outlined,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(role: UserRole.admin),
                  ),
                );
              },
            ),
            const Spacer(),
            Text(
              'آفلاین • نسخه نمونه اولیه',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54)),
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

