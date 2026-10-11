part of 'search_cubit.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  // نتايج البحث الكامل
  final SearchStatus status;
  final AppFailure? failure;
  final String query;
  final List<ProductItemModel> products;

  // Trending
  final List<String> trending;

  // الاقتراحات أثناء الكتابة
  final String typing;
  final List<String> suggestions;
  final bool suggestionsLoading;

  const SearchState({
    this.status = SearchStatus.initial,
    this.failure,
    this.query = '',
    this.products = const [],
    this.trending = const [],
    this.typing = '',
    this.suggestions = const [],
    this.suggestionsLoading = false,
  });

  bool get isLoading => status == SearchStatus.loading;
  bool get isFailure => status == SearchStatus.failure;
  bool get isTyping => typing.trim().isNotEmpty;

  // failure بيتصفّر عن قصد
  SearchState copyWith({
    SearchStatus? status,
    AppFailure? failure,
    String? query,
    List<ProductItemModel>? products,
    List<String>? trending,
    String? typing,
    List<String>? suggestions,
    bool? suggestionsLoading,
  }) => SearchState(
    status: status ?? this.status,
    failure: failure,
    query: query ?? this.query,
    products: products ?? this.products,
    trending: trending ?? this.trending,
    typing: typing ?? this.typing,
    suggestions: suggestions ?? this.suggestions,
    suggestionsLoading: suggestionsLoading ?? this.suggestionsLoading,
  );

  @override
  List<Object?> get props => [
    status,
    failure,
    query,
    products,
    trending,
    typing,
    suggestions,
    suggestionsLoading,
  ];
}
