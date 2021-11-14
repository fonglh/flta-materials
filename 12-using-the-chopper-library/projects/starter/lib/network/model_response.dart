// Classes here will be used to model the data fetched via HTTP using Chopper.

// Generic response class that will either hold a successful response or an
// error.
// Blueprint for a result with a generic type T.
abstract class Result<T> {}

// Hold a value when the response is successful. e.g. can hold JSON data.
class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

// Hold exceptions, model errors that occur during the http call.
// e.g. using the wrong credentials or fetching data without auth
class Error<T> extends Result<T> {
  final Exception exception;

  Error(this.exception);
}
