import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:konoz/features/layout/presentation/enum/app_nav_item.dart';
 
part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(const LayoutState());

  void changeNavItem(AppNavItem item) {
    if (state.selectedNavItem == item) return;
    emit(state.copyWith(selectedNavItem: item));
  }
}