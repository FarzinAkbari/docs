enum LoanType {
  quick('وام فوری', 'مناسب درخواست‌های سریع'),
  marriage('وام ازدواج', 'تسهیلات ویژه ازدواج'),
  housing('وام مسکن', 'تسهیلات خرید/رهن/ساخت');

  const LoanType(this.title, this.subtitle);
  final String title;
  final String subtitle;
}

