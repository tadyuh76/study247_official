sealed class Result<S, F extends Exception> {
  const Result();
}

final class Success<S, F extends Exception> extends Result<S, F> {
  final S value;
  const Success(this.value);
}

final class Failure<S, F extends Exception> extends Result<S, F> {
  final F failure;
  const Failure(this.failure);
}
