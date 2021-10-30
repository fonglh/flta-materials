import 'dart:async';
import 'package:flutter/material.dart';

// Constants for each tab the user taps
class FooderlichTab {
  static const int explore = 0;
  static const int recipes = 1;
  static const int toBuy = 2;
}

class AppStateManager extends ChangeNotifier {
  // Checks if app is initialized
  bool _initialized = false;
  // Checks if user has logged in
  bool _loggedIn = false;
  // Checks if user has completed the onboarding flow
  bool _onboardingComplete = false;
  // Tracks which tab the user is on
  int _selectedTab = FooderlichTab.explore;

  // Getters for each property.
  // These properties cannot be changed outside AppStateManager.
  // This is important for the unidirectional flow architecture.
  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  int get getSelectedTab => _selectedTab;

  // The following functions all set some values that aren't publicly exposed
  // and then notify listeners.
  // This is the essence of the unidirectional data flow architecture that's
  // being implemented.

  void initializeApp() {
    // Sets delay timer for 2000ms before executing the closure.
    // This sets how long the app screen will display after starting the app
    Timer(const Duration(milliseconds: 2000), () {
      _initialized = true;
      notifyListeners();
    });
  }

  void login(String username, String password) {
    // Just a mock. In a real app, this would be an API call to login.
    _loggedIn = true;
    notifyListeners();
  }

  // Notifies listeners that the user has completed the onboarding guide.
  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void goToTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  // Helper function that goes straight to the recipes tab
  void goToRecipes() {
    _selectedTab = FooderlichTab.recipes;
    notifyListeners();
  }

  // Resets all app state properties, re-inits the app, notifies all listeners
  // of state change.
  void logout() {
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = FooderlichTab.explore;

    initializeApp();
    notifyListeners();
  }
}
