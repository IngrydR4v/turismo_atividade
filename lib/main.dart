import 'package:flutter/material.dart';
import 'navigator.dart' as navigator;
import 'pages/principal/principal_view.dart';

void main() {
  // key da navegação
  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // para gerar as rotas de navegação do app
      onGenerateRoute: navigator.generateRoute,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        // utilizar o tema do material3
        useMaterial3: true,
        // tema dos cards
        cardTheme: const CardTheme(
          elevation: 0,
          surfaceTintColor: Colors.white,
          color: Colors.white,
        ),
      ),
      // tela principal do app
      home: const PrincipalView(),
    ),
  );
}
