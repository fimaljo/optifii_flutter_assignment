class PriceBreakdown {
  const PriceBreakdown({
    required this.voucherValue,
    required this.discountPercent,
    required this.discountAmount,
    required this.finalPayable,
  });

  final double voucherValue;
  final double discountPercent;
  final double discountAmount;
  final double finalPayable;

  double get savings => discountAmount;
}

abstract final class PriceCalculator {
  static PriceBreakdown calculate({
    required double voucherValue,
    required double discountPercent,
  }) {
    final discountAmount = voucherValue * (discountPercent / 100);
    final finalPayable = voucherValue - discountAmount;

    return PriceBreakdown(
      voucherValue: voucherValue,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      finalPayable: finalPayable,
    );
  }
}
