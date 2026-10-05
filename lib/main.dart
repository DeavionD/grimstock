import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme/grim_theme.dart';

void main() {
  runApp(const ProviderScope(child: GrimstockApp()));
}

class GrimstockApp extends StatefulWidget {
  const GrimstockApp({super.key});

  @override
  State<GrimstockApp> createState() => _GrimstockAppState();
}

class _GrimstockAppState extends State<GrimstockApp> {
  final _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Grimstock',
      debugShowCheckedModeBanner: false,
      theme: buildGrimTheme(),
      routerConfig: _router,
    );
  }
}
