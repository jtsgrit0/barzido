import 'package:flutter/material.dart';

import '../features/pub_map/presentation/pages/pub_detail_page.dart';
import '../features/pub_map/presentation/pages/pub_map_page.dart';

class AppRouter {
  static const pubMap = '/';
  static const pubDetail = '/pub-detail';

  static Route<void> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) {
        switch (settings.name) {
          case pubDetail:
            final pubId = settings.arguments! as String;
            return PubDetailPage(pubId: pubId);
          case pubMap:
          default:
            return const PubMapPage();
        }
      },
    );
  }
}
