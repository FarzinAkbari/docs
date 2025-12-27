import 'loan_type.dart';

class LoanApplication {
  LoanApplication({
    required this.id,
    required this.type,
    required this.createdAtMillis,
    required this.applicantFullName,
    required this.nationalId,
    required this.phone,
    required this.city,
    required this.loanAmount,
    required this.monthlyIncome,
    required this.branchName,
    required this.notes,
  });

  final String id;
  final LoanType type;
  final int createdAtMillis;

  final String applicantFullName;
  final String nationalId;
  final String phone;
  final String city;

  final String loanAmount;
  final String monthlyIncome;
  final String branchName;
  final String notes;
}

