import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../data/repositories/repositories.dart';
import '../../providers/providers.dart';

/// Central dependency injection for the app. Pass a custom [repository] in tests.
List<SingleChildWidget> buildAppProviders({VoucherRepository? repository}) {
  final voucherRepository = repository ?? const StaticVoucherRepository();

  return [
    Provider<VoucherRepository>.value(value: voucherRepository),
    ChangeNotifierProvider(
      create: (_) => MarketplaceProvider(repository: voucherRepository),
    ),
    ChangeNotifierProvider(
      create: (_) => OrderProvider(),
    ),
  ];
}
