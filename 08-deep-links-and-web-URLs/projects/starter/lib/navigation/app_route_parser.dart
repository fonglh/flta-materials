import 'package:flutter/material.dart';

import 'app_link.dart';

// RouteInformationParser takes a generic type, here we're using our AppLink
// type.
class AppRouteParser extends RouteInformationParser<AppLink> {
  // need to override this
  @override
  Future<AppLink> parseRouteInformation(
      RouteInformation routeInformation) async {
    // Take the route info and build an AppLink instance.
    final link = AppLink.fromLocation(routeInformation.location);
    return link;
  }

  // need to override this too
  @override
  RouteInformation restoreRouteInformation(AppLink appLink) {
    // Get back a URL string from the AppLink object accepted by the function.
    final location = appLink.toLocation();
    // Wrap it in RouteInformation to pass it along
    return RouteInformation(location: location);
  }
}
