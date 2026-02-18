import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failure.dart';

abstract class BaseUseCase<T, Parameters> {
  Future<Either<Failure, T>> call(Parameters parameters);
}

class NoParameters extends Equatable {
  const NoParameters();

  @override
  List<Object> get props => [];
}

class PageParameters extends Equatable {
  final String page;

  const PageParameters({
    required this.page,
  });

  @override
  List<Object> get props => [
        page,
      ];
}
