import 'package:hive/hive.dart';

import 'boxes.dart';

class SettingsRepository {
  static const String _receiptFooterKey = 'receipt_footer_text';

  Box get _box => Hive.box(Boxes.settings);

  static Future<void> ensureOpen() async {
    if (!Hive.isBoxOpen(Boxes.settings)) {
      await Hive.openBox(Boxes.settings);
    }
  }

  Future<String> getReceiptFooterText() async {
    await ensureOpen();
    final v = _box.get(_receiptFooterKey);
    final text = (v is String) ? v : '';
    return text.isEmpty ? 'این رسید صرفاً پیش‌ثبت‌نام بوده و تعهدی برای بانک ایجاد نمی‌کند.' : text;
  }

  Future<void> setReceiptFooterText(String text) async {
    await ensureOpen();
    await _box.put(_receiptFooterKey, text.trim());
  }
}

