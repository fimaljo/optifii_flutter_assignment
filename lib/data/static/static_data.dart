import '../../core/constants/asset_paths.dart';
import '../models/models.dart';

abstract final class StaticData {
  static const categories = <Category>[
    Category(id: 'quick_commerce', name: 'Quick Commerce', iconName: 'bolt'),
    Category(id: 'entertainment', name: 'Entertainment', iconName: 'movie'),
    Category(id: 'fashion', name: 'Fashion', iconName: 'checkroom'),
    Category(id: 'electronics', name: 'Electronics', iconName: 'devices'),
    Category(id: 'food', name: 'Food & Dining', iconName: 'restaurant'),
    Category(id: 'travel', name: 'Travel', iconName: 'flight'),
    Category(id: 'grocery', name: 'Grocery', iconName: 'local_grocery_store'),
  ];

  /// Home carousel banners — image files live in `assets/banners/`.
  static const promoBanners = <PromoBanner>[
    PromoBanner(
      id: 'makemytrip',
      imageAsset: 'assets/banners/makemytrip.png',
      title: 'Up To 1500 OFF',
      subtitle: 'On First Flight Booking',
    ),
  ];

  static const brands = <Brand>[
    Brand(
      id: 'flipkart',
      name: 'Flipkart',
      categoryId: 'quick_commerce',
      logoAsset: 'assets/brands/flipkart.png',
      discountPercent: 6,
      startingPrice: 500,
      validityMonths: 6,
      isTrending: true,
      isPopular: true,
      description:
          'Shop electronics, fashion, home essentials and more with Flipkart gift vouchers.',
      termsAndConditions: [
        'Voucher is valid for 6 months from date of purchase.',
        'Cannot be exchanged for cash or combined with other offers.',
        'Valid only on Flipkart app and website.',
        'Partial redemption is not allowed.',
      ],
      howToRedeem: [
        'Go to Flipkart app or website.',
        'Add items to cart and proceed to checkout.',
        'Select "Gift Card" as payment method.',
        'Enter card number and PIN to redeem.',
      ],
    ),
    Brand(
      id: 'amazon',
      name: 'Amazon',
      categoryId: 'quick_commerce',
      logoAsset: 'assets/brands/amazon.png',
      discountPercent: 6,
      startingPrice: 500,
      validityMonths: 12,
      isTrending: true,
      isPopular: true,
      description:
          'Redeem on millions of products across Amazon India marketplace.',
      termsAndConditions: [
        'Valid for 12 months from purchase date.',
        'Non-refundable and non-transferable after activation.',
        'Applicable on Amazon.in only.',
      ],
      howToRedeem: [
        'Visit Amazon.in and sign in.',
        'Go to "Your Account" > "Gift Cards".',
        'Click "Add a Gift Card" and enter details.',
        'Balance will be applied at checkout.',
      ],
    ),
    Brand(
      id: 'swiggy',
      name: 'Swiggy',
      categoryId: 'food',
      logoAsset: 'assets/brands/swiggy.png',
      discountPercent: 6,
      startingPrice: 250,
      validityMonths: 3,
      isTrending: true,
      isPopular: true,
      description: 'Order food from your favourite restaurants with Swiggy vouchers.',
      termsAndConditions: [
        'Valid for 3 months from purchase.',
        'Usable on Swiggy food delivery only.',
        'Not applicable on Swiggy Instamart or Genie.',
      ],
      howToRedeem: [
        'Open Swiggy app.',
        'Go to Account > Swiggy Money / Gift Cards.',
        'Enter voucher code and PIN.',
        'Use balance while placing order.',
      ],
    ),
    Brand(
      id: 'zomato',
      name: 'Zomato',
      categoryId: 'food',
      discountPercent: 6,
      startingPrice: 300,
      validityMonths: 6,
      isPopular: true,
      description: 'Enjoy dining and food delivery with Zomato gift vouchers.',
      termsAndConditions: [
        'Valid for 6 months.',
        'Applicable on Zomato Gold and food orders.',
        'Cannot be clubbed with other promotional offers.',
      ],
      howToRedeem: [
        'Open Zomato app.',
        'Navigate to Profile > Payments > Zomato Credits.',
        'Add gift voucher using code and PIN.',
      ],
    ),
    Brand(
      id: 'myntra',
      name: 'Myntra',
      categoryId: 'fashion',
      logoAsset: 'assets/brands/myntra.png',
      discountPercent: 6,
      startingPrice: 500,
      validityMonths: 6,
      isTrending: true,
      description: 'Shop the latest fashion trends with Myntra gift cards.',
      termsAndConditions: [
        'Valid for 6 months on Myntra app and website.',
        'Not valid on third-party seller products marked excluded.',
      ],
      howToRedeem: [
        'Visit Myntra app or myntra.com.',
        'Go to My Account > Gift Card.',
        'Enter card number and PIN to add balance.',
      ],
    ),
    Brand(
      id: 'nykaa',
      name: 'Nykaa',
      categoryId: 'fashion',
      discountPercent: 6,
      startingPrice: 500,
      validityMonths: 6,
      isPopular: true,
      description: 'Beauty, wellness and personal care vouchers from Nykaa.',
      termsAndConditions: [
        'Valid for 6 months on Nykaa platform.',
        'Not applicable on certain luxury brands.',
      ],
      howToRedeem: [
        'Open Nykaa app or website.',
        'Go to My Account > Gift Card.',
        'Redeem using card number and PIN.',
      ],
    ),
    Brand(
      id: 'bigbasket',
      name: 'BigBasket',
      categoryId: 'grocery',
      discountPercent: 6,
      startingPrice: 500,
      validityMonths: 6,
      isPopular: true,
      description: 'Grocery and daily essentials delivery with BigBasket vouchers.',
      termsAndConditions: [
        'Valid for 6 months on BigBasket orders.',
        'Not applicable on tobacco and alcohol products.',
      ],
      howToRedeem: [
        'Open BigBasket app.',
        'Go to My Account > BBWallet / Gift Cards.',
        'Add voucher using provided credentials.',
      ],
    ),
    Brand(
      id: 'dominos',
      name: "Domino's",
      categoryId: 'food',
      discountPercent: 6,
      startingPrice: 200,
      validityMonths: 3,
      description: "Pizza lovers rejoice — redeem at Domino's outlets and online.",
      termsAndConditions: [
        'Valid for 3 months.',
        'Usable on Domino\'s app, website and outlets.',
        'Not valid with other combo offers.',
      ],
      howToRedeem: [
        'Order via Domino\'s app or website.',
        'At checkout, select Gift Card payment.',
        'Enter card number and PIN.',
      ],
    ),
    Brand(
      id: 'lifestyle',
      name: 'Lifestyle',
      categoryId: 'fashion',
      discountPercent: 6,
      startingPrice: 500,
      validityMonths: 6,
      isTrending: true,
      isPopular: true,
      description: 'Shop fashion, home and beauty at Lifestyle stores across India.',
      termsAndConditions: [
        'Valid for 6 months from purchase date.',
        'Redeemable at Lifestyle stores and online.',
        'Cannot be exchanged for cash.',
      ],
      howToRedeem: [
        'Visit Lifestyle store or website.',
        'Select items and proceed to checkout.',
        'Apply gift voucher code at payment.',
      ],
    ),
  ];

  /// Resolve logo path: explicit [Brand.logoAsset] or default `assets/brands/{id}.png`.
  static String logoPathFor(Brand brand) =>
      brand.logoAsset ?? AppAssets.brandLogo(brand.id);
}
