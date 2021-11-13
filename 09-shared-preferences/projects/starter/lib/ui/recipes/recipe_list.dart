import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_dropdown.dart';
import '../colors.dart';
import 'dart:convert';
import '../../network/recipe_model.dart';
import 'package:flutter/services.dart';
import '../recipe_card.dart';
import 'recipe_details.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  static const String prefSearchKey = 'previousSearches';

  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  List currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];
  APIRecipeQuery? _currentRecipes1 = null;

  @override
  void initState() {
    super.initState();
    loadRecipes();
    getPreviousSearches();
    searchTextController = TextEditingController(text: '');
    _scrollController
      ..addListener(() {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (hasMore &&
              currentEndPosition < currentCount &&
              !loading &&
              !inErrorState) {
            setState(() {
              loading = true;
              currentStartPosition = currentEndPosition;
              currentEndPosition =
                  min(currentStartPosition + pageCount, currentCount);
            });
          }
        }
      });
  }

  Future loadRecipes() async {
    // Load from json in the assets directory.
    final jsonString = await rootBundle.loadString('assets/recipes1.json');
    setState(() {
      // Use built in json decoder to convert the string to a Map, then uses
      // generated fromJson function to make an instance of APIRecipeQuery.
      _currentRecipes1 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void savePreviousSearches() async {
    // Uses await to wait for an instance of SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if a preference for the saved list already exists.
    if (prefs.containsKey(prefSearchKey)) {
      final searches = prefs.getStringList(prefSearchKey);

      // Check that the saved list is not null, init an empty list if it's null
      if (searches != null) {
        previousSearches = searches;
      } else {
        previousSearches = <String>[];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildSearchCard(),
            _buildRecipeLoader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            // Replace
            IconButton(
              icon: const Icon(Icons.search),
              // Handle the tap event.
              onPressed: () {
                // Use the current search text to start a search
                startSearch(searchTextController.text);
                // Hide the keyboard by using the FocusScope class
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
            ),
            const SizedBox(
              width: 6.0,
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                      // TextField for the search queries
                      child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                    autofocus: false,
                    // Closes the keyboard when the user presses the Done button
                    textInputAction: TextInputAction.done,
                    // Save the search when the user has finished entering text
                    onSubmitted: (value) {
                      if (!previousSearches.contains(value)) {
                        previousSearches.add(value);
                        savePreviousSearches();
                      }
                    },
                    controller: searchTextController,
                  )),
                  // PopupMenuButton to show previous searches
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    // Start a new search when the user selects an item from
                    // a previous search.
                    onSelected: (String value) {
                      searchTextController.text = value;
                      startSearch(searchTextController.text);
                    },
                    itemBuilder: (BuildContext context) {
                      // Build list of CustomDropdownMenuItems to display
                      // previous searches.
                      return previousSearches
                          .map<CustomDropdownMenuItem<String>>((String value) {
                        return CustomDropdownMenuItem<String>(
                          text: value,
                          value: value,
                          callback: () {
                            setState(() {
                              // if X icon is pressed, remove the search from
                              // the previous searches and close the pop-up menu
                              previousSearches.remove(value);
                              Navigator.pop(context);
                            });
                          },
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startSearch(String value) {
    // Tells system to redraw widgets by calling setState.
    setState(() {
      // Clear current search list and reset counters.
      currentSearchList.clear();
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = true;
      value = value.trim();

      // Check that search text isn't already in the list of previous searches
      if (!previousSearches.contains(value)) {
        // Add to, and save the list
        previousSearches.add(value);
        savePreviousSearches();
      }
    });
  }

  Widget _buildRecipeLoader(BuildContext context) {
    // Null checks
    if (_currentRecipes1 == null || _currentRecipes1?.hits == null) {
      return Container();
    }
    // Show a loading indicator while waiting for the recipes
    return Center(
      // If not null, builds a recipe card with the 1st item in the list
      child: _buildRecipeCard(context, _currentRecipes1!.hits, 0),
    );
  }
}

Widget _buildRecipeCard(
    BuildContext topLevelContext, List<APIHits> hits, int index) {
  // Find recipe at given index
  final recipe = hits[index].recipe;
  return GestureDetector(
    onTap: () {
      Navigator.push(topLevelContext, MaterialPageRoute(
        builder: (context) {
          return const RecipeDetails();
        },
      ));
    },
    // Shows a nice card below the search field
    child: recipeStringCard(recipe.image, recipe.label),
  );
}
