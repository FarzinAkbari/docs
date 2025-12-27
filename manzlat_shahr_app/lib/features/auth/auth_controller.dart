import 'package:flutter/foundation.dart';

import '../employees/employee_repository.dart';

enum UserRole { employee, admin }

class AuthState {
  const AuthState({
    required this.isReady,
    required this.isLoggedIn,
    this.role,
    this.username,
  });

  final bool isReady;
  final bool isLoggedIn;
  final UserRole? role;
  final String? username;

  AuthState copyWith({
    bool? isReady,
    bool? isLoggedIn,
    UserRole? role,
    String? username,
  }) {
    return AuthState(
      isReady: isReady ?? this.isReady,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      username: username ?? this.username,
    );
  }
}

class AuthController extends ChangeNotifier {
  AuthState _state = const AuthState(isReady: false, isLoggedIn: false);
  AuthState get state => _state;

  final EmployeeRepository _employees = EmployeeRepository();

  Future<void> init() async {
    await EmployeeRepository.ensureOpen();
    _state = _state.copyWith(isReady: true);
    notifyListeners();
  }

  Future<String?> loginAdmin({required String username, required String password}) async {
    // نمونه اولیه (بعداً می‌شود با دیتابیس/رمزنگاری جایگزین کرد)
    if (username.trim() == 'admin' && password.trim() == '1234') {
      _state = AuthState(
        isReady: true,
        isLoggedIn: true,
        role: UserRole.admin,
        username: username.trim(),
      );
      notifyListeners();
      return null;
    }
    return 'نام کاربری یا رمز مدیر اشتباه است';
  }

  Future<String?> loginEmployee({required String username, required String pin}) async {
    final u = username.trim();
    final p = pin.trim();
    final emp = _employees.findByUsername(u);
    if (emp == null) return 'این کارمند وجود ندارد (از پنل مدیر اضافه کنید)';
    if (emp.pin != p) return 'پین کارمند اشتباه است';
    _state = AuthState(
      isReady: true,
      isLoggedIn: true,
      role: UserRole.employee,
      username: u,
    );
    notifyListeners();
    return null;
  }

  void logout() {
    _state = const AuthState(isReady: true, isLoggedIn: false);
    notifyListeners();
  }
}

