import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/search/data/repo/search_repo.dart';

part 'search_state.dart';

class SearchCubit extends SafeCubit<SearchState> {
  final SearchRepo _repo;
  SearchCubit(this._repo) : super(const SearchState());

  Timer? _debounce;
  int _requestId = 0; // للبحث الكامل
  int _suggestId = 0; // للاقتراحات

  Future<void> loadTrending() async {
    final res = await _repo.getTrending();
    res.fold((_) {}, (terms) => emit(state.copyWith(trending: terms)));
  }

  /// اقتراحات أثناء الكتابة (debounce 300ms، حد أدنى حرفين)
  void onQueryChanged(String raw) {
    _debounce?.cancel();
    final q = raw.trim();
    final id = ++_suggestId; // أي رد قديم يتجاهل

    if (q.isEmpty) {
      emit(
        state.copyWith(
          typing: q,
          suggestions: const [],
          suggestionsLoading: false,
        ),
      );
      return;
    }

    emit(state.copyWith(typing: q, suggestionsLoading: true));
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final list = await _repo.getSuggestions(q);
      if (id != _suggestId || isClosed) return;
      emit(state.copyWith(suggestions: list, suggestionsLoading: false));
    });
  }

  /// البحث الكامل: من الـ submit أو اقتراح أو chip
  Future<void> searchNow(String raw) async {
    _debounce?.cancel();
    _suggestId++; // يلغي أي اقتراحات متأخرة
    final q = raw.trim();
    if (q.isEmpty) return;

    emit(
      state.copyWith(
        query: q,
        products: const [],
        status: SearchStatus.loading,
        suggestionsLoading: false,
      ),
    );
    await _search(q);

    // بنسجل بس لو البحث نجح وفيه نتايج (والسيرفر بيتأكد برضه)
    if (!isClosed &&
        state.status == SearchStatus.success &&
        state.products.isNotEmpty) {
      _repo.logSearch(q); // fire and forget
    }
  }

  Future<void> retry() => searchNow(state.query);

  Future<void> _search(String q) async {
    final id = ++_requestId;
    final res = await _repo.searchProducts(q);
    if (id != _requestId || isClosed) return; // رد قديم
    res.fold(
      (f) => emit(state.copyWith(status: SearchStatus.failure, failure: f)),
      (list) =>
          emit(state.copyWith(status: SearchStatus.success, products: list)),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
