import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../network/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors.dart';
import '../recipe_card.dart';
import '../widgets/custom_dropdown.dart';
import 'recipe_details.dart';
import '../../network/recipe_service.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  static const String prefSearchKey = 'previousSearches';

  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();

  List<APIHits> currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];

  @override
  void initState() {
    super.initState();
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

  Future<APIRecipeQuery> getRecipeData(String query, int from, int to) async {
    final recipeJson = await RecipeService().getRecipes(query, from, to);
    final recipeMap = json.decode(recipeJson);
    // Create APIRecipeQuery object using the json parsing code from Chapter 10.
    return APIRecipeQuery.fromJson(recipeMap);
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void savePreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefSearchKey)) {
      final searches = prefs.getStringList(prefSearchKey);
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
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                startSearch(searchTextController.text);
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
                      child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                    autofocus: false,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      if (!previousSearches.contains(value)) {
                        previousSearches.add(value);
                        savePreviousSearches();
                      }
                    },
                    controller: searchTextController,
                  )),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    onSelected: (String value) {
                      searchTextController.text = value;
                      startSearch(searchTextController.text);
                    },
                    itemBuilder: (BuildContext context) {
                      return previousSearches
                          .map<CustomDropdownMenuItem<String>>((String value) {
                        return CustomDropdownMenuItem<String>(
                          text: value,
                          value: value,
                          callback: () {
                            setState(() {
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
    setState(() {
      currentSearchList.clear();
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = true;
      value = value.trim();
      if (!previousSearches.contains(value)) {
        previousSearches.add(value);
        savePreviousSearches();
      }
    });
  }

  Widget _buildRecipeLoader(BuildContext context) {
    // Enforce at least 3 chars in the search term
    if (searchTextController.text.length < 3) {
      return Container();
    }
    // Determines the current state of the Future that APIRecipeQuery returns.
    // It then builds a widget that displays async data while it's loading.
    return FutureBuilder<APIRecipeQuery>(
      future: getRecipeData(searchTextController.text.trim(),
          currentStartPosition, currentEndPosition),
      // Returns a widget
      builder: (context, snapshot) {
        // if done, can update UI with results or an error
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(),
                  textAlign: TextAlign.center, textScaleFactor: 1.3),
            );
          }

          // Process query results and add `query.hits` to `currentSearchList`.
          loading = false;
          final query = snapshot.data;
          inErrorState = false;
          if (query != null) {
            currentCount = query.count;
            hasMore = query.more;
            currentSearchList.addAll(query.hits);
            // if not at the end of the data, set currentEndPosition to the
            // current location.
            if (query.to < currentEndPosition) {
              currentEndPosition = query.to;
            }
          }
          return _buildRecipeList(context, currentSearchList);
        }
        // snapshot.connectionState is not done
        else {
          if (currentCount == 0) {
            // Show a loading indicator while waiting for the recipes
            return const Center(child: CircularProgressIndicator());
          } else {
            // else just show the current recipes
            return _buildRecipeList(context, currentSearchList);
          }
        }
      },
    );
  }

  Widget _buildRecipeList(BuildContext recipeListContext, List<APIHits> hits) {
    // Get the device's screen size. Item height is fixed, create 2 columns of
    // cards with each column being half the screen width.
    final size = MediaQuery.of(context).size;
    const itemHeight = 310;
    final itemWidth = size.width / 2;
    // Widget that's flexible in width and height
    return Flexible(
      child: GridView.builder(
        // Created in initState(), to detect when scrolling gets to about
        // 70% of the way to the bottom of the list.
        controller: _scrollController,
        // 6
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemCount: hits.length,
        // Uses _buildRecipeCard to create a card for each recipe.
        itemBuilder: (BuildContext context, int index) {
          return _buildRecipeCard(recipeListContext, hits, index);
        },
      ),
    );
  }

  Widget _buildRecipeCard(
      BuildContext topLevelContext, List<APIHits> hits, int index) {
    final recipe = hits[index].recipe;
    return GestureDetector(
      onTap: () {
        Navigator.push(topLevelContext, MaterialPageRoute(
          builder: (context) {
            return const RecipeDetails();
          },
        ));
      },
      child: recipeCard(recipe),
    );
  }
}
