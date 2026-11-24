import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/pagination/paged_list.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';

part 'best_selling_state.dart';

class BestSellingCubit extends SafeCubit<BestSellingState> {
  final HomeRepo _homeRepo;

  BestSellingCubit(this._homeRepo) : super(const BestSellingState());

  int _requestId = 0;

  /// أول صفحة. لو فيه منتجات معروضة بالفعل بيعمل refresh هادي من غير skeleton.
  Future<void> getBestSelling() async {
    final id = ++_requestId; // أي loadMore شغال يتجاهل

    if (state.list.isEmpty) {
      emit(state.copyWith(status: BestSellingStatus.loading));
    }

    final result = await _homeRepo.getBestSelling();
    if (id != _requestId || isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BestSellingStatus.failure,
          failure: failure,
          // نفضّي علامات التحميل (لو كان فيه loadMore اتلغى)
          list: PagedList(items: state.list.items, meta: state.list.meta),
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: BestSellingStatus.success,
          list: const PagedList<ProductItemModel>().first(page),
        ),
      ),
    );
  }

  /// الصفحة التالية. بتتنادى أوتوماتيك من الـ scroll فلازم تتحمي من التكرار.
  /// [retry] = true لما اليوزر يدوس إعادة بعد فشل صفحة.
  Future<void> loadMore({bool retry = false}) async {
    final list = state.list;
    if (!state.isSuccess || list.isLoadingMore || !list.hasMore) return;
    if (list.loadMoreFailure != null && !retry) return;

    final id = _requestId;
    emit(state.copyWith(list: list.loadingMore()));

    final result = await _homeRepo.getBestSelling(page: list.nextPage);
    if (id != _requestId || isClosed) return;

    result.fold(
      (failure) =>
          emit(state.copyWith(list: state.list.loadMoreFailed(failure))),
      (page) => emit(state.copyWith(list: state.list.appended(page))),
    );
  }
}