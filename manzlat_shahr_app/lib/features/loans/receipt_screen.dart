import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../services/storage/settings_repository.dart';
import 'loan_application.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key, required this.application});

  final LoanApplication application;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final SettingsRepository _settings = SettingsRepository();
  final TextEditingController _footer = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final text = await _settings.getReceiptFooterText();
    _footer.text = text;
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _footer.dispose();
    super.dispose();
  }

  Future<void> _saveFooter() async {
    if (_saving) return;
    setState(() => _saving = true);
    await _settings.setReceiptFooterText(_footer.text);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('متن رسید ذخیره شد')));
  }

  Future<Uint8List> _buildPdf(PdfPageFormat format) async {
    final app = widget.application;
    final created = DateTime.fromMillisecondsSinceEpoch(app.createdAtMillis);
    final dateStr = DateFormat('yyyy/MM/dd  HH:mm').format(created);

    final doc = pw.Document();

    // نکته: برای نمایش صحیح فارسی در PDF باید فونت TTF فارسی به assets اضافه شود.
    // فعلاً خروجی ساده است (نمونه اولیه).
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (_) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(18),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Manzlat Shahr - Pre-Registration Receipt', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 6),
                pw.Text('Loan type: ${app.type.title}'),
                pw.Text('Receipt ID: ${app.id}'),
                pw.Text('Date: $dateStr'),
                pw.Divider(),
                pw.Text('Applicant: ${app.applicantFullName}'),
                pw.Text('National ID: ${app.nationalId}'),
                pw.Text('Phone: ${app.phone}'),
                pw.Text('City: ${app.city}'),
                pw.SizedBox(height: 8),
                pw.Text('Loan amount: ${app.loanAmount}'),
                pw.Text('Monthly income: ${app.monthlyIncome}'),
                pw.Text('Branch: ${app.branchName}'),
                if (app.notes.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text('Notes: ${app.notes}'),
                ],
                pw.Spacer(),
                pw.Divider(),
                pw.Text(_footer.text, style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
    return doc.save();
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.application;
    final created = DateTime.fromMillisecondsSinceEpoch(app.createdAtMillis);
    final dateStr = DateFormat('yyyy/MM/dd  HH:mm').format(created);

    return Scaffold(
      appBar: AppBar(title: const Text('رسید پیش‌ثبت‌نام')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'منزلت شهر • رسید پیش‌ثبت‌نام',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        _row('شناسه رسید', app.id),
                        _row('تاریخ', dateStr),
                        _row('نوع وام', app.type.title),
                        const Divider(height: 22),
                        _row('نام متقاضی', app.applicantFullName),
                        _row('کد ملی', app.nationalId),
                        _row('موبایل', app.phone),
                        _row('شهر', app.city),
                        const Divider(height: 22),
                        _row('مبلغ وام', app.loanAmount),
                        _row('درآمد ماهانه', app.monthlyIncome),
                        _row('شعبه', app.branchName),
                        if (app.notes.trim().isNotEmpty) ...[
                          const Divider(height: 22),
                          _row('توضیحات', app.notes),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('متن رسید (قابل تغییر)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _footer,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'متن دلخواه شما برای پایین رسید...',
                          ),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          onPressed: _saving ? null : _saveFooter,
                          icon: const Icon(Icons.save_outlined),
                          label: Text(_saving ? 'در حال ذخیره...' : 'ذخیره متن'),
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          onPressed: () async {
                            await Printing.layoutPdf(onLayout: _buildPdf);
                          },
                          icon: const Icon(Icons.print_outlined),
                          label: const Text('چاپ / خروجی PDF'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'نکته: برای چاپ PDF با حروف فارسی، در مرحله بعد فونت فارسی (TTF) به پروژه اضافه می‌کنیم.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(k, style: const TextStyle(color: Colors.black54))),
          Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

