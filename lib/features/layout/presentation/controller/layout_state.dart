part of 'layout_cubit.dart';

@immutable
class LayoutState extends Equatable {
  final AppNavItem selectedNavItem;

  const LayoutState({
    this.selectedNavItem = AppNavItem.home,
  });

  LayoutState copyWith({AppNavItem? selectedNavItem}) {
    return LayoutState(
      selectedNavItem: selectedNavItem ?? this.selectedNavItem,
    );
  }

  @override
  List<Object?> get props => [selectedNavItem];
}