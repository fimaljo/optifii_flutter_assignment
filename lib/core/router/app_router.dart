import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:optifii_flutter_assignment/features/search/presentation/pages/category_result_page.dart';

import '../../features/gift/presentation/pages/gift_details_page.dart';
import '../../features/history/presentation/pages/order_history_page.dart';
import '../../features/home/presentation/pages/rewards_marketplace_page.dart';
import '../../features/order/presentation/pages/order_summary_page.dart';
import '../../features/order/presentation/pages/payment_page.dart';
import '../../features/order/presentation/pages/payment_success_page.dart';
import '../../features/order/presentation/pages/post_purchase_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/voucher/presentation/pages/voucher_details_page.dart';
import '../../shared/widgets/figma_widgets.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RewardsMarketplacePage(),
      ),

      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),

      GoRoute(
        path: '/category/:categoryId',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;

          return CategoryResultsPage(
            categoryId: categoryId,
          );
        },
      ),

      GoRoute(
        path: '/voucher/:brandId',
        builder: (context, state) {
          final brandId = state.pathParameters['brandId']!;
          return VoucherDetailsPage(
            brandId: brandId,
          );
        },
      ),

      GoRoute(
        path: '/gift-details',
        builder: (context, state) => const GiftDetailsPage(),
      ),

      GoRoute(
        path: '/order-summary',
        builder: (context, state) => const OrderSummaryPage(),
      ),

      GoRoute(
        path: '/payment',
        builder: (context, state) => const PaymentPage(),
      ),

      GoRoute(
        path: '/payment-success/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;

          return PaymentSuccessPage(
            orderId: orderId,
          );
        },
      ),

      GoRoute(
        path: '/voucher-view/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;

          return PostPurchasePage(
            orderId: orderId,
          );
        },
      ),

      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderHistoryPage(),
      ),

      GoRoute(
        path: '/orders/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;

          return OrderDetailPage(
            orderId: orderId,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => DarkScaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.uri}',
        ),
      ),
    ),
  );
}