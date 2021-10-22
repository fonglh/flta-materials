import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatelessWidget {
  // To mock server responses
  final mockService = MockFooderlichService();

  ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create FutureBuilder within widget's build
    return FutureBuilder(
      // getExploreData returns a future that returns an ExploreData instance.
      // That contains 2 lists, todayRecipes and friendPosts
      future: mockService.getExploreData(),
      // within builder, use snapshot to check the state of the Future
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        // Future is complete, can extract the data.
        if (snapshot.connectionState == ConnectionState.done) {
          // snapshot.data returns ExploreData, can extract todayRecipes to pass
          // to the ListView.
          final recipes = snapshot.data?.todayRecipes ?? [];

          return ListView(
            scrollDirection: Axis.vertical,
            children: [
              TodayRecipeListView(recipes: recipes),
              const SizedBox(height: 16),
              FriendPostListView(friendPosts: snapshot.data?.friendPosts ?? []),
            ],
          );
        } else {
          // The Future is still loading, show a spinner to let the user know
          // that something is happening
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
