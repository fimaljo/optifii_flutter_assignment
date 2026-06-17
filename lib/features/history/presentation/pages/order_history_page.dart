import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../data/models/models.dart';
import '../../../../providers/order_provider.dart';
import '../../../../shared/widgets/figma_widgets.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/brand_image.dart';
import '../../../../shared/widgets/common_widgets.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final _searchController = TextEditingController();
  String _query = '';
  PurchaseMode? _filterMode;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().filterOrders(
          query: _query,
          mode: _filterMode,
        );

    return DarkScaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: AppSearchBar(
              hintText: 'Search transactions',
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _filterMode == null,
                  onSelected: (_) => setState(() => _filterMode = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Self'),
                  selected: _filterMode == PurchaseMode.self,
                  onSelected: (_) => setState(() => _filterMode = PurchaseMode.self),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Gifted'),
                  selected: _filterMode == PurchaseMode.gift,
                  onSelected: (_) => setState(() => _filterMode = PurchaseMode.gift),
                ),
              ],
            ),
          ),
          Expanded(
            child: orders.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.receipt_long_outlined,
                    title: 'No orders yet',
                    subtitle: _query.isNotEmpty || _filterMode != null
                        ? 'No transactions match your search or filter.'
                        : 'Your purchased vouchers will appear here.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return _OrderHistoryTile(
                        order: order,
                        onTap: () => context.push('/orders/${order.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _OrderHistoryTile extends StatelessWidget {
  const _OrderHistoryTile({
    required this.order,
    required this.onTap,
  });

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              BrandAvatar(brand: order.brand, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.brand.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy · hh:mm a').format(order.purchasedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      order.mode == PurchaseMode.gift ? 'Gifted' : 'Self purchase',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(order.finalPayable),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final order = context.watch<OrderProvider>().getOrderById(orderId);

    if (order == null) {
      return DarkScaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Order not found')),
      );
    }

    return DarkScaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DetailCard(
            title: 'Voucher Info',
            children: [
              _DetailRow(label: 'Brand', value: order.brand.name),
              _DetailRow(
                label: 'Voucher value',
                value: CurrencyFormatter.format(order.voucherValue),
              ),
              _DetailRow(
                label: 'Discount',
                value: CurrencyFormatter.format(order.discountAmount),
              ),
              _DetailRow(
                label: 'Paid',
                value: CurrencyFormatter.format(order.finalPayable),
              ),
              _DetailRow(
                label: 'Date',
                value: DateFormat('dd MMM yyyy, hh:mm a').format(order.purchasedAt),
              ),
              _DetailRow(
                label: 'Status',
                value: _statusLabel(order.status),
              ),
            ],
          ),
          if (order.giftDetails != null) ...[
            const SizedBox(height: 12),
            _DetailCard(
              title: 'Receiver Details',
              children: [
                _DetailRow(label: 'Name', value: order.giftDetails!.receiverName),
                _DetailRow(label: 'Phone', value: order.giftDetails!.phone),
                _DetailRow(label: 'Email', value: order.giftDetails!.email),
                if (order.giftDetails!.message.isNotEmpty)
                  _DetailRow(label: 'Message', value: order.giftDetails!.message),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _DetailCard(
            title: 'Card Details',
            children: [
              _DetailRow(
                label: 'Card Number',
                value: order.isRevealed
                    ? order.credentials.cardNumber
                    : 'Tap View Voucher to reveal',
              ),
              _DetailRow(
                label: 'PIN',
                value: order.isRevealed ? order.credentials.pin : '****',
              ),
              _DetailRow(
                label: 'Expiry',
                value: DateFormat('dd MMM yyyy').format(order.credentials.expiryDate),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ExpandableTerms(title: 'Terms & Conditions', items: order.brand.termsAndConditions),
          const SizedBox(height: 12),
          _ExpandableTerms(title: 'How to Redeem', items: order.brand.howToRedeem),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/voucher-view/$orderId'),
              child: const Text('View Voucher'),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(VoucherStatus status) {
    return switch (status) {
      VoucherStatus.purchased => 'Purchased',
      VoucherStatus.gifted => 'Gifted',
      VoucherStatus.revealed => 'Revealed',
    };
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _ExpandableTerms extends StatelessWidget {
  const _ExpandableTerms({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(title, style: Theme.of(context).textTheme.titleMedium),
          children: items
              .map(
                (item) => ListTile(
                  leading: const Icon(Icons.circle, size: 6),
                  title: Text(item, style: Theme.of(context).textTheme.bodyMedium),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
