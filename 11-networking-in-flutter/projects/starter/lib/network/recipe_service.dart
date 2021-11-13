import 'package:http/http.dart';

const String apiKey = '<Your Key>';
const String apiId = '<your ID>';
const String apiUrl = 'https://api.edamam.com/search';

class RecipeService {
  // Returns a `Future`, async function
  Future getData(String url) async {
    print('Calling url: $url');
    // `response` doesn't have a value until await completes.
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
    }
  }

  // `from` and `to` allow specific pages of the query to be fetched.
  Future<dynamic> getRecipes(String query, int from, int to) async {
    // `final` creates a non changing variable.
    final recipeData = await getData(
        '$apiUrl?app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
    // This method doesn't handle errors, will be handled in Chapter 12 with
    // the Chopper library.
    return recipeData;
  }
}
