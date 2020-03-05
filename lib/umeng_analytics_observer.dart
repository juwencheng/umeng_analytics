import 'package:flutter/widgets.dart';
import 'package:umenganalytics/umenganalytics.dart';

class UmengAnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      onPageEnd(previousRoute);
      onPageStart(route);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      onPageEnd(oldRoute);
      onPageStart(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      onPageEnd(route);
      onPageStart(previousRoute);
    }
  }
  
  void onPageEnd(Route route) {
    if (route != null && route.settings != null) {
      Umenganalytics.onPageEnd(route.settings.name);
    }
  }
  
  void onPageStart(Route route) {
    if (route != null && route.settings != null) {
      Umenganalytics.onPageStart(route.settings.name);
    }
  }
}
