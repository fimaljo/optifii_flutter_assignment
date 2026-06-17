import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/utils/price_calculator.dart';
import '../data/models/models.dart';

/// Checkout and order lifecycle state. Catalog lookups belong in [MarketplaceProvider].
class OrderProvider extends ChangeNotifier {
  final _uuid = const Uuid();

  CheckoutDraft? _checkoutDraft;
  final List<Order> _orders = [];

  CheckoutDraft? get checkoutDraft => _checkoutDraft;
  List<Order> get orders => List.unmodifiable(_orders);

  void startCheckout({
    required Brand brand,
    required double unitAmount,
    PurchaseMode mode = PurchaseMode.self,
    int quantity = 1,
  }) {
    _checkoutDraft = CheckoutDraft(
      brand: brand,
      unitAmount: unitAmount,
      mode: mode,
      quantity: quantity,
    );
    notifyListeners();
  }

  void updateCheckoutMode(PurchaseMode mode) {
    final draft = _checkoutDraft;
    if (draft == null) return;
    draft.mode = mode;
    if (mode == PurchaseMode.self) {
      draft.giftDetails = null;
    }
    notifyListeners();
  }

  void updateGiftDetails(GiftDetails details, GiftTheme theme) {
    final draft = _checkoutDraft;
    if (draft == null) return;
    draft.giftDetails = details;
    draft.selectedTheme = theme;
    notifyListeners();
  }

  void clearCheckout() {
    _checkoutDraft = null;
    notifyListeners();
  }

  Order? completePurchase() {
    final draft = _checkoutDraft;
    if (draft == null) return null;

    final breakdown = PriceCalculator.calculate(
      voucherValue: draft.voucherValue,
      discountPercent: draft.brand.discountPercent,
    );

    final now = DateTime.now();
    final credentials = VoucherCredentials(
      cardNumber: _generateCardNumber(),
      pin: _generatePin(),
      expiryDate: DateTime(
        now.year,
        now.month + draft.brand.validityMonths,
        now.day,
      ),
    );

    final order = Order(
      id: _uuid.v4(),
      brand: draft.brand,
      voucherValue: breakdown.voucherValue,
      discountPercent: breakdown.discountPercent,
      discountAmount: breakdown.discountAmount,
      finalPayable: breakdown.finalPayable,
      purchasedAt: now,
      mode: draft.mode,
      status: draft.mode == PurchaseMode.gift
          ? VoucherStatus.gifted
          : VoucherStatus.purchased,
      credentials: credentials,
      giftDetails: draft.giftDetails,
    );

    _orders.insert(0, order);
    _checkoutDraft = null;
    notifyListeners();
    return order;
  }

  void revealVoucher(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index == -1) return;

    _orders[index] = _orders[index].copyWith(
      isRevealed: true,
      status: VoucherStatus.revealed,
    );
    notifyListeners();
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Order> filterOrders({String? query, PurchaseMode? mode}) {
    return _orders.where((order) {
      final matchesQuery = query == null ||
          query.trim().isEmpty ||
          order.brand.name.toLowerCase().contains(query.toLowerCase());
      final matchesMode = mode == null || order.mode == mode;
      return matchesQuery && matchesMode;
    }).toList();
  }

  String _generateCardNumber() {
    final raw = _uuid.v4().replaceAll('-', '').substring(0, 16);
    return '${raw.substring(0, 4)}-${raw.substring(4, 8)}-${raw.substring(8, 12)}-${raw.substring(12, 16)}';
  }

  String _generatePin() {
    return (1000 + DateTime.now().millisecond % 9000).toString();
  }
}
