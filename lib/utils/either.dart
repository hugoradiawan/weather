import 'package:equatable/equatable.dart';
import 'package:weather/utils/typedefs.dart';

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

class Failure extends Equatable {
  final String message;
  final int internalCode;
  final int? code, randomValue;

  const Failure(this.message, this.internalCode, {this.code, this.randomValue});

  @override
  List<Object?> get props => [
        message,
        internalCode,
        code,
        randomValue,
      ];

  JSON toJson() => {
        'msg': message,
        'iCode': internalCode,
        'c': code,
        'r': randomValue,
      };

  static Failure? fromJson(JSON? json) => json == null
      ? null
      : Failure(
          json['msg'],
          json['iCode'],
          code: json['c'],
          randomValue: json['r'],
        );
}
