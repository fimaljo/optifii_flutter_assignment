import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/repositories.dart';
import 'shared/widgets/figma_widgets.dart';

class OptifiiApp extends StatelessWidget {
  const OptifiiApp({super.key, this.repository});

  /// Optional override for tests or future environment-specific repositories.
  final VoucherRepository? repository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildAppProviders(repository: repository),
      child: MaterialApp.router(
        title: 'Optifii Rewards',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return AppGradientBackground(
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
