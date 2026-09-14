import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/core/local_storage/app_cache_keys.dart';
import 'package:konoz/core/local_storage/secure_cache.dart';
import 'package:konoz/features/layout/presentation/enum/app_nav_item.dart';

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState()) {
    _loadTheme();
  }

  void _loadTheme() {
    final theme = AppCache.getData(
      key: AppCacheKeys.themeMode,
    );

    if (theme == 'dark') {
      emit(
        state.copyWith(
          themeMode: ThemeMode.dark,
        ),
      );
    } else if (theme == 'light') {
      emit(
        state.copyWith(
          themeMode: ThemeMode.light,
        ),
      );
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    await AppCache.setData(
      key: AppCacheKeys.themeMode,
      value: mode == ThemeMode.dark ? 'dark' : 'light',
    );

    emit(
      state.copyWith(
        themeMode: mode,
      ),
    );
  }
}