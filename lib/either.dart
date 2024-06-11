class Either<F, S> {
  final F? fail;
  final S? success;

  Either.left(this.fail) : success = null;
  Either.right(this.success) : fail = null;

  bool get isFail => fail != null;
  bool get isSuccess => success != null;

  F getFail() {
    if (fail == null) throw Exception('No left value');
    return fail!;
  }

  S getSuccess() {
    if (success == null) throw Exception('No right value');
    return success!;
  }

  void fold(Function(F) onFail, Function(S) onSuccess) {
    if (isFail) {
      onFail(getFail());
    } else {
      onSuccess(getSuccess());
    }
  }
}

class Success<L, R> extends Either<L, R> {
  Success(R super.right) : super.right();
}

class Fail<L, R> extends Either<L, R> {
  Fail(L super.left) : super.left();
}

class Failure {
  final String message;
  final int code;

  Failure(this.message, this.code);
}
