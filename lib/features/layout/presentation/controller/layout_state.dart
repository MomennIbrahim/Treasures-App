part of 'layout_cubit.dart';

@immutable
class LayoutState extends Equatable {
  final AppNavItem selectedNavItem;
  final ThemeMode themeMode;

  const LayoutState({
    this.selectedNavItem = AppNavItem.home,
    this.themeMode = ThemeMode.light,
  });

  LayoutState copyWith({AppNavItem? selectedNavItem, ThemeMode? themeMode}) {
    return LayoutState(
      selectedNavItem: selectedNavItem ?? this.selectedNavItem,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [selectedNavItem, themeMode];
}
