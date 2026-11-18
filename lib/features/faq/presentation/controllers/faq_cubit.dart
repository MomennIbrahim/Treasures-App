import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/faq/data/model/faq_model.dart';
import 'package:konoz/features/faq/data/repo/faq_repo.dart';

part 'faq_state.dart';

class FaqCubit extends SafeCubit<FaqState> {
  final FaqRepo _repo;
  FaqCubit(this._repo) : super(const FaqState());

  Future<void> getFaqs() async {
    if (state.isLoading) return;
    emit(state.copyWith(status: FaqStatus.loading));

    final result = await _repo.getFaqs();
    result.fold(
      (f) => emit(state.copyWith(status: FaqStatus.failure, failure: f)),
      (faqs) => emit(state.copyWith(status: FaqStatus.success, faqs: faqs)),
    );
  }
}
