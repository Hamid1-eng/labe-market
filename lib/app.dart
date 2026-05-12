import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/colors.dart';
import 'core/constants/strings.dart';
import 'routes/app_routes.dart';
import 'providers/product_provider.dart';
import 'providers/auth_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      ),
    );
  }
}
