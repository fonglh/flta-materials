class AppLink {
  // Constants for each URL path.
  static const String kHomePath = '/home';
  static const String kOnboardingPath = '/onboarding';
  static const String kLoginPath = '/login';
  static const String kProfilePath = '/profile';
  static const String kItemPath = '/item';
  // Constants for each supported query param.
  static const String kTabParam = 'tab';
  static const String kIdParam = 'id';
  // Stores the path of the URL.
  String? location;
  // Store the tab to redirect the user to.
  int? currentTab;
  // Store the id of the item to view.
  String? itemId;
  // Initialize the app link with the location and the 2 query params.
  AppLink({
    this.location,
    this.currentTab,
    this.itemId,
  });

  // Transforms a simple string into an app state represented by AppLink
  static AppLink fromLocation(String? location) {
    // Handle percent-encoding.
    location = Uri.decodeFull(location ?? '');
    // Parse for query param keys and key-value pairs.
    final uri = Uri.parse(location);
    final params = uri.queryParameters;

    // Extraction currentTab and itemId only happens if the query params exist.
    final currentTab = int.tryParse(params[AppLink.kTabParam] ?? '');
    final itemId = params[AppLink.kIdParam];

    final link = AppLink(
      location: uri.path,
      currentTab: currentTab,
      itemId: itemId,
    );
    return link;
  }

  // The converse transformation, from AppLink to a String.
  String toLocation() {
    // Internal function that formats query param key-value pairs into string.
    String addKeyValPair({
      required String key,
      String? value,
    }) =>
        value == null ? '' : '${key}=$value&';
    // Go through each defined path
    switch (location) {
      case kLoginPath:
        return kLoginPath;
      case kOnboardingPath:
        return kOnboardingPath;
      case kProfilePath:
        return kProfilePath;
      // Return the correct string path and append item Id if there's any.
      case kItemPath:
        var loc = '$kItemPath?';
        loc += addKeyValPair(
          key: kIdParam,
          value: itemId,
        );
        return Uri.encodeFull(loc);
      // Direct to home if path is invalid, append tab as query param if any.
      default:
        var loc = '$kHomePath?';
        loc += addKeyValPair(
          key: kTabParam,
          value: currentTab.toString(),
        );
        return Uri.encodeFull(loc);
    }
  }
}
