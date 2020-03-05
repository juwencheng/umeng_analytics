import 'package:flutter/widgets.dart';
import 'package:umenganalytics/umenganalytics.dart';

class UmengAnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      Umenganalytics.onPageEnd(previousRoute.settings.name);
      Umenganalytics.onPageStart(route.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      Umenganalytics.onPageEnd(oldRoute.settings.name);
      Umenganalytics.onPageStart(newRoute.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      Umenganalytics.onPageEnd(route.settings.name);
      Umenganalytics.onPageStart(previousRoute.settings.name);
    }
  }
}
