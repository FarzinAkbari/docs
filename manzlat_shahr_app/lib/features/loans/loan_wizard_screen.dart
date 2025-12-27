import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'loan_application.dart';
import 'loan_type.dart';
import 'receipt_screen.dart';

class LoanWizardScreen extends StatefulWidget {
  const LoanWizardScreen({super.key, required this.type});

  final LoanType type;

  @override
  State<LoanWizardScreen> createState() => _LoanWizardScreenState();
}

class _LoanWizardScreenState extends State<LoanWizardScreen> {
  int _step = 0;

  final _form1 = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();
  final _form3 = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _nationalId = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _loanAmount = TextEditingController();
  final _monthlyIncome = TextEditingController();
  final _branch = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _nationalId.dispose();
    _phone.dispose();
    _city.dispose();
    _loanAmount.dispose();
    _monthlyIncome.dispose();
    _branch.dispose();
    _notes.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    if (_step == 0) return _form1.currentState!.validate();
    if (_step == 1) return _form2.currentState!.validate();
    if (_step == 2) return _form3.currentState!.validate();
    return true;
  }

  void _next() {
    if (!_validateCurrentStep()) return;
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step--);
  }

  void _finish() {
    final application = LoanApplication(
      id: const Uuid().v4(),
      type: widget.type,
      createdAtMillis: DateTime.now().millisecondsSinceEpoch,
      applicantFullName: _fullName.text.trim(),
      nationalId: _nationalId.text.trim(),
      phone: _phone.text.trim(),
      city: _city.text.trim(),
      loanAmount: _loanAmount.text.trim(),
      monthlyIncome: _monthlyIncome.text.trim(),
      branchName: _branch.text.trim(),
      notes: _notes.text.trim(),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ReceiptScreen(application: application)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('فرم ${widget.type.title}')),
      body: Stepper(
        currentStep: _step,
        onStepContinue: _next,
        onStepCancel: _back,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                FilledButton(
                  onPressed: details.onStepContinue,
                  child: Text(_step == 3 ? 'ثبت و صدور رسید' : 'ادامه'),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: _step == 0 ? null : details.onStepCancel,
                  child: const Text('قبلی'),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('اطلاعات هویتی'),
            isActive: _step >= 0,
            state: _step > 0 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _form1,
              child: Column(
                children: [
                  TextFormField(
                    controller: _fullName,
                    decoration: const InputDecoration(labelText: 'نام و نام خانوادگی'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'اجباری' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nationalId,
                    decoration: const InputDecoration(labelText: 'کد ملی'),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().length < 10) ? 'کد ملی نامعتبر' : null,
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('اطلاعات تماس'),
            isActive: _step >= 1,
            state: _step > 1 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _form2,
              child: Column(
                children: [
                  TextFormField(
                    controller: _phone,
                    decoration: const InputDecoration(labelText: 'شماره موبایل'),
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().length < 10) ? 'شماره نامعتبر' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(labelText: 'شهر'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'اجباری' : null,
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('جزئیات وام'),
            isActive: _step >= 2,
            state: _step > 2 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _form3,
              child: Column(
                children: [
                  TextFormField(
                    controller: _loanAmount,
                    decoration: const InputDecoration(labelText: 'مبلغ وام (ریال)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'اجباری' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _monthlyIncome,
                    decoration: const InputDecoration(labelText: 'درآمد ماهانه (ریال)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'اجباری' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _branch,
                    decoration: const InputDecoration(labelText: 'نام شعبه'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'اجباری' : null,
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('تأیید نهایی'),
            isActive: _step >= 3,
            state: _step == 3 ? StepState.indexed : StepState.complete,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('نوع وام: ${widget.type.title}', style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text('نام متقاضی: ${_fullName.text.trim()}'),
                        Text('کد ملی: ${_nationalId.text.trim()}'),
                        Text('موبایل: ${_phone.text.trim()}'),
                        Text('شهر: ${_city.text.trim()}'),
                        const Divider(height: 18),
                        Text('مبلغ وام: ${_loanAmount.text.trim()}'),
                        Text('درآمد ماهانه: ${_monthlyIncome.text.trim()}'),
                        Text('شعبه: ${_branch.text.trim()}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notes,
                  decoration: const InputDecoration(
                    labelText: 'توضیحات (اختیاری)',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

