import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_screen.dart';
import 'auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _passwordOrPin = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _username.dispose();
    _passwordOrPin.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _busy = true);
    final auth = context.read<AuthController>();
    String? error;
    if (widget.role == UserRole.admin) {
      error = await auth.loginAdmin(username: _username.text, password: _passwordOrPin.text);
    } else {
      error = await auth.loginEmployee(username: _username.text, pin: _passwordOrPin.text);
    }
    setState(() => _busy = false);

    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == UserRole.admin;
    return Scaffold(
      appBar: AppBar(title: Text(isAdmin ? 'ورود مدیر' : 'ورود کارمند')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _username,
                        decoration: const InputDecoration(
                          labelText: 'نام کاربری',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'نام کاربری را وارد کنید' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordOrPin,
                        decoration: InputDecoration(
                          labelText: isAdmin ? 'رمز عبور' : 'پین',
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'این فیلد اجباری است' : null,
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _busy ? null : _submit,
                        child: Text(_busy ? 'در حال ورود...' : 'ورود'),
                      ),
                      if (isAdmin) ...[
                        const SizedBox(height: 10),
                        Text(
                          'حساب پیش‌فرض مدیر: admin / 1234',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'منزلت شهر • آفلاین',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

