// import Chopper package and the app's models.
import 'package:chopper/chopper.dart';
import 'recipe_model.dart';
import 'model_response.dart';
import 'model_converter.dart';

// Generated file must be imported before it's created so the generator
// script knows what file it's supposed to create.
part 'recipe_service.chopper.dart';

const String apiKey = '<Your Key Here>';
const String apiId = '<Your Id here>';
// /search was removed from the URL so other APIs can be called
const String apiUrl = 'https://api.edamam.com';

// Tells the Chopper generator to build a part file.
// The part file will have .chopper in its filename and will hold the
// boilerplate code.
@ChopperApi()
// Abstract class because only the method signatures need to be defined.
// The generator script will take these definitions and generate the rest of the
// code.
abstract class RecipeService extends ChopperService {
  // Annotation that tells the generator this is a GET request with a path named
  // 'search'.
  // Other annotations like @post @put @delete can be used as well.
  @Get(path: 'search')

  // Returns a Future of the Response using APIRecipeQuery.
  // Abstract `Result` class will hold either the value or an error.
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
      // Uses Chopper's `@Query` annotation to specify the query parameter.
      // This method has no body, the generator script will create the body
      // using the query params.
      @Query('q') String query,
      @Query('from') int from,
      @Query('to') int to);

  static RecipeService create() {
    final client = ChopperClient(
      baseUrl: apiUrl,
      // Add interceptors. `HttpLoggingInterceptor` is part of Chopper and logs
      // all calls.
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      // Set converter as instance of `ModelConverter`.
      converter: ModelConverter(),
      // Use the built in `JsonConverter` to decode errors.
      errorConverter: const JsonConverter(),
      // Define services created when running the generator script.
      services: [
        _$RecipeService(),
      ],
    );
    // Return an instance of the generated service.
    return _$RecipeService(client);
  }
}

// Request interceptor that adds app ID and app key to the query params.
Request _addQuery(Request req) {
  // Creates a map from the existing request params.
  final params = Map<String, dynamic>.from(req.parameters);
  // Add app ID and app key to the map
  params['app_id'] = apiId;
  params['app_key'] = apiKey;
  // Returns a new copy of the `Request` with the newly added app params.
  return req.copyWith(parameters: params);
}
