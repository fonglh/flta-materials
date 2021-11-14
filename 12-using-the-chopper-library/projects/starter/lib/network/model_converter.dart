import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'model_response.dart';
import 'recipe_model.dart';

// Use ModelConverter to implement Chopper's `Converter` abstract class.
class ModelConverter implements Converter {
  // Takes a request and returns a new request.
  @override
  Request convertRequest(Request request) {
    // Add "application/json" header using constant `jsonHeaders` from Chopper.
    final req = applyHeader(
      request,
      contentTypeKey,
      jsonHeaders,
      override: false,
    );

    return encodeJson(req);
  }

  Request encodeJson(Request request) {
    // Extract contentType from request headers.
    final contentType = request.headers[contentTypeKey];
    // Confirm it's "application/json".
    if (contentType != null && contentType.contains(jsonHeaders)) {
      // Make a copy with a JSON encoded body.
      return request.copyWith(body: json.encode(request.body));
    }
    return request;
  }

  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    final contentType = response.headers[contentTypeKey];
    var body = response.body;
    // Check that this is JSON and UTF decode to a string.
    if (contentType != null && contentType.contains(jsonHeaders)) {
      body = utf8.decode(response.bodyBytes);
    }
    try {
      // JSON decode from string to map.
      final mapData = json.decode(body);
      // Server returns a `status` field when there's an error.
      if (mapData['status'] != null) {
        return response.copyWith<BodyType>(
            body: Error(Exception(mapData['status'])) as BodyType);
      }
      // Convert the map to the model class.
      final recipeQuery = APIRecipeQuery.fromJson(mapData);
      // Return successful response that wraps `recipeQuery`.
      return response.copyWith<BodyType>(
          body: Success(recipeQuery) as BodyType);
    } catch (e) {
      // Wrap response with generic instance of Error.
      chopperLogger.warning(e);
      return response.copyWith<BodyType>(
          body: Error(e as Exception) as BodyType);
    }
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    // Calls `decodeJson` defined above.
    return decodeJson<BodyType, InnerType>(response);
  }
}
