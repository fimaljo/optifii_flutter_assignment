import 'package:flutter_test/flutter_test.dart';

import 'package:optifii_flutter_assignment/core/utils/price_calculator.dart';

void main() {
  group('PriceCalculator', () {
    test('calculates discount and final payable correctly', () {
      final breakdown = PriceCalculator.calculate(
        voucherValue: 1000,
        discountPercent: 10,
      );

      expect(breakdown.voucherValue, 1000);
      expect(breakdown.discountAmount, 100);
      expect(breakdown.finalPayable, 900);
    });

    test('handles zero discount', () {
      final breakdown = PriceCalculator.calculate(
        voucherValue: 500,
        discountPercent: 0,
      );

      expect(breakdown.discountAmount, 0);
      expect(breakdown.finalPayable, 500);
    });
  });
}
