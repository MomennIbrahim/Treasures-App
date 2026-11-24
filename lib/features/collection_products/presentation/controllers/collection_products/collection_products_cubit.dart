import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/pagination/paged_list.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';

part 'collection_products_state.dart';

class CollectionProductsCubit extends SafeCubit<CollectionProductsState> {
  final CollectionProductsRepo _repo;
  CollectionProductsCubit(this._repo) : super(const CollectionProductsState());

  /// كاش لكل كولكشن بصفحاته اللي اتحمّلت (الرجوع لتاب زاره قبل كده فوري)
  final Map<String, PagedList<ProductItemModel>> _cache = {};
  int _requestId = 0;

  /// id = '' (فاضي) يعني All. غير كده هو id المجموعة النصي زي "oud".
  Future<void> selectCollection(String id, {bool force = false}) async {
    if (!force &&
        id == state.selectedCollectionId &&
        (state.isSuccess || state.isLoading)) {
      return;
    }

    final reqId = ++_requestId; // أي رد قديم (حتى loadMore) يتجاهل

    final cached = _cache[id];
    if (!force && cached != null) {
      emit(
        state.copyWith(
          selectedCollectionId: id,
          status: CollectionProductsStatus.success,
          list: cached,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        selectedCollectionId: id,
        status: CollectionProductsStatus.loading,
        list: const PagedList(),
      ),
    );

    final res = await _repo.getCollectionProducts(
      collectionId: id.isEmpty ? null : id,
    );
    if (reqId != _requestId || isClosed) return;

    res.fold(
      (f) => emit(
        state.copyWith(status: CollectionProductsStatus.failure, failure: f),
      ),
      (page) {
        final list = const PagedList<ProductItemModel>().first(page);
        _cache[id] = list;
        emit(
          state.copyWith(status: CollectionProductsStatus.success, list: list),
        );
      },
    );
  }

  /// الصفحة التالية. بتتنادى أوتوماتيك من الـ scroll، فلازم تتحمي من التكرار.
  /// [retry] = true لما اليوزر يدوس "حاول تاني" بعد فشل صفحة.
  Future<void> loadMore({bool retry = false}) async {
    final list = state.list;
    if (!state.isSuccess || list.isLoadingMore || !list.hasMore) return;
    // بعد فشل صفحة مبنكرّرش لوحدنا مع كل scroll، اليوزر هو اللي يعيد
    if (list.loadMoreFailure != null && !retry) return;

    final id = state.selectedCollectionId;
    final reqId = _requestId; // لو التاب اتغير أثناء التحميل نتجاهل الرد

    emit(state.copyWith(list: list.loadingMore()));

    final res = await _repo.getCollectionProducts(
      collectionId: id.isEmpty ? null : id,
      page: list.nextPage,
    );
    if (reqId != _requestId || isClosed) return;

    res.fold(
      (f) => emit(state.copyWith(list: state.list.loadMoreFailed(f))),
      (page) {
        final updated = state.list.appended(page);
        _cache[id] = updated;
        emit(state.copyWith(list: updated));
      },
    );
  }

  Future<void> retry() =>
      selectCollection(state.selectedCollectionId, force: true);
}