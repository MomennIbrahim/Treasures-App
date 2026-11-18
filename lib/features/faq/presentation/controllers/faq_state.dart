part of 'faq_cubit.dart';

enum FaqStatus { initial, loading, success, failure }

extension FaqStatusX on FaqState {
  bool get isInitial => status == FaqStatus.initial;
  bool get isLoading => status == FaqStatus.loading;
  bool get isSuccess => status == FaqStatus.success;
  bool get isFailure => status == FaqStatus.failure;
  bool get isEmpty => isSuccess && faqs.isEmpty;
}

class FaqState {
  final FaqStatus status;
  final List<FaqModel> faqs;
  final AppFailure? failure;

  const FaqState({
    this.status = FaqStatus.initial,
    this.faqs = const [],
    this.failure,
  });

  // failure بيتصفّر عن قصد لو متبعتش
  FaqState copyWith({
    FaqStatus? status,
    List<FaqModel>? faqs,
    AppFailure? failure,
  }) {
    return FaqState(
      status: status ?? this.status,
      faqs: faqs ?? this.faqs,
      failure: failure,
    );
  }
}
