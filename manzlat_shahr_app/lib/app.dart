import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_controller.dart';
import 'features/auth/login_role_screen.dart';
import 'theme/app_theme.dart';

class ManzlatShahrAppBootstrap extends StatelessWidget {
  const ManzlatShahrAppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()..init()),
      ],
      child: const ManzlatShahrApp(),
    );
  }
}

class ManzlatShahrApp extends StatelessWidget {
  const ManzlatShahrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'منزلت شهر',
      theme: AppTheme.light(),
      supportedLocales: const [Locale('fa', 'IR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const LoginRoleScreen(),
    );
  }
}

