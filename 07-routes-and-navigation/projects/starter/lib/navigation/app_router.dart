import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/screens.dart';

// This is a declarative approach. Instead of telling navigator what to do with
// push and pop, tell it when state is x, render y pages.

// Extends RouterDelegate. System tells the router to build and config
// a navigator widget.
class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  // GlobalKey is unique across the app.
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // Router listens to app state changes to configure the navigator's
  // list of pages.
  final AppStateManager appStateManager;
  // Listen to user's state when item is created or edited.
  final GroceryManager groceryManager;
  // Listen to the user's profile state.
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  // Must remove the listeners when disposing the router or an exception will
  // be thrown.
  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  // Required by RouterDelegate to configure the navigator and pages.
  @override
  Widget build(BuildContext context) {
    return Navigator(
      // navigatorKey is required to retrieve the current navigator
      key: navigatorKey,
      onPopPage:
          _handlePopPage, // called every time a page is popped from the stack
      // Stack of pages that defines the navigation stack.
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn && !appStateManager.isOnboardingComplete)
          OnboardingScreen.page(),
        // TODO: Add Home
        // TODO: Create new item
        // TODO: Select GroceryItemScreen
        // TODO: Add Profile Screen
        // TODO: Add WebView Screen
      ],
    );
  }

  bool _handlePopPage(
      // Current Route, which contains info like RouteSettings to retrieve the
      // route's name and arguments.
      Route<dynamic> route,
      // Value returned when the route completes. e.g. value that dialog returns
      result) {
    // Check if current route pop succeeded
    if (!route.didPop(result)) {
      // Failed, so return false
      return false;
    }

    // If pop succeeded, check the different routes and trigger appropriate
    // state changes.
    // TODO: Handle Onboarding and splash
    // TODO: Handle state when user closes grocery item screen
    // TODO: Handle state when user closes profile screen
    // TODO: Handle state when user closes WebView screen
    // 6
    return true;
  }

  // Set to null since we're not supporting flutter web apps yet.
  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
