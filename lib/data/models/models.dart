class Category {
  const Category({
    required this.id,
    required this.name,
    required this.iconName,
  });

  final String id;
  final String name;
  final String iconName;
}

class Brand {
  const Brand({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.discountPercent,
    required this.startingPrice,
    required this.validityMonths,
    required this.description,
    required this.termsAndConditions,
    required this.howToRedeem,
    this.isTrending = false,
    this.isPopular = false,
  });

  final String id;
  final String name;
  final String categoryId;
  final double discountPercent;
  final double startingPrice;
  final int validityMonths;
  final String description;
  final List<String> termsAndConditions;
  final List<String> howToRedeem;
  final bool isTrending;
  final bool isPopular;
}

enum PurchaseMode { self, gift }

enum GiftTheme { classic, celebration, minimal, festive }

enum VoucherStatus { purchased, gifted, revealed }

class GiftDetails {
  const GiftDetails({
    required this.receiverName,
    required this.phone,
    required this.email,
    required this.message,
    required this.theme,
  });

  final String receiverName;
  final String phone;
  final String email;
  final String message;
  final GiftTheme theme;
}

class VoucherCredentials {
  const VoucherCredentials({
    required this.cardNumber,
    required this.pin,
    required this.expiryDate,
  });

  final String cardNumber;
  final String pin;
  final DateTime expiryDate;
}

class Order {
  const Order({
    required this.id,
    required this.brand,
    required this.voucherValue,
    required this.discountPercent,
    required this.discountAmount,
    required this.finalPayable,
    required this.purchasedAt,
    required this.mode,
    required this.status,
    required this.credentials,
    this.giftDetails,
    this.isRevealed = false,
  });

  final String id;
  final Brand brand;
  final double voucherValue;
  final double discountPercent;
  final double discountAmount;
  final double finalPayable;
  final DateTime purchasedAt;
  final PurchaseMode mode;
  final VoucherStatus status;
  final VoucherCredentials credentials;
  final GiftDetails? giftDetails;
  final bool isRevealed;

  Order copyWith({
    VoucherStatus? status,
    bool? isRevealed,
  }) {
    return Order(
      id: id,
      brand: brand,
      voucherValue: voucherValue,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      finalPayable: finalPayable,
      purchasedAt: purchasedAt,
      mode: mode,
      status: status ?? this.status,
      credentials: credentials,
      giftDetails: giftDetails,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }
}

class CheckoutDraft {
  CheckoutDraft({
    required this.brand,
    required this.voucherValue,
    required this.mode,
    this.giftDetails,
    this.selectedTheme = GiftTheme.classic,
  });

  final Brand brand;
  final double voucherValue;
  PurchaseMode mode;
  GiftDetails? giftDetails;
  GiftTheme selectedTheme;

  double get discountPercent => brand.discountPercent;

  double get discountAmount => voucherValue * (discountPercent / 100);

  double get finalPayable => voucherValue - discountAmount;
}
