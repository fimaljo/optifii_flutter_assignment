import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/order_provider.dart';
import 'shared/widgets/figma_widgets.dart';

class OptifiiApp extends StatelessWidget {
  const OptifiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderProvider(),
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
