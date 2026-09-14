part of 'collections_cubit.dart';

enum CollectionsStatus {
  initial,
  loading,
  success,
  failure,
}

extension CollectionsStatusX on CollectionsState {
  bool get isInitial => status == CollectionsStatus.initial;
  bool get isLoading => status == CollectionsStatus.loading;
  bool get isSuccess => status == CollectionsStatus.success;
  bool get isFailure => status == CollectionsStatus.failure;
}

@immutable
class CollectionsState extends Equatable {
  final CollectionsStatus status;
  final List<CollectionsModel> collections;
  final AppFailure? failure;

  const CollectionsState({
    this.status = CollectionsStatus.initial,
    this.collections = const [],
    this.failure,
  });

  CollectionsState copyWith({
    CollectionsStatus? status,
    List<CollectionsModel>? collections,
    AppFailure? failure,
    bool clearFailure = false,
  }) {
    return CollectionsState(
      status: status ?? this.status,
      collections: collections ?? this.collections,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        collections,
        failure,
      ];
}