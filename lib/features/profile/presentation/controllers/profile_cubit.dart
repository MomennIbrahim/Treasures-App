import 'package:equatable/equatable.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends SafeCubit<ProfileState> {
  final ProfileRepo repo;
  ProfileCubit(this.repo) : super(const ProfileState());

  Future<void> getProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await repo.getProfile();
    result.fold(
      (f) => emit(state.copyWith(status: ProfileStatus.failure, failure: f)),
      (p) => emit(state.copyWith(status: ProfileStatus.success, profile: p)),
    );
  }
}
