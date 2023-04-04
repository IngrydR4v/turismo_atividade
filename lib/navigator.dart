import 'package:flutter/material.dart';

import 'pages/adicionar/adicionar_view.dart';
import 'pages/principal/principal_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/principal':
      return MaterialPageRoute(builder: (context) => PrincipalView());
    case '/adicionarPontoTuristico':
      return MaterialPageRoute(
          builder: (context) =>
              AdicionarView(arguments: settings.arguments as Map));
    default:
      return MaterialPageRoute(
          maintainState: false, builder: (context) => PrincipalView());
  }
}
