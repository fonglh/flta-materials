import 'package:flutter/material.dart';

// Manages the tab index that the user taps
class TabManager extends ChangeNotifier {
  // Tracks which tab the user taps
  int selectedTab = 0;

  // Modifies the current tab index
  void goToTab(index) {
    selectedTab = index;
    // Notify all widgets listening to this state
    notifyListeners();
  }

  // Specific function that sets selectedTab to the Recipes tab at index 1
  void goToRecipes() {
    selectedTab = 1;
    // Notifies all widgets listening to TabManager that Recipes is the selected
    // tab
    notifyListeners();
  }
}
