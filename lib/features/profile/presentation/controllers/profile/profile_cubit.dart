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

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final profile = state.profile;
    if (profile == null) return;

    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.loading,
        action: ProfileAction.updateProfile,
      ),
    );
    final result = await repo.updateProfile(name: name, email: email);
    result.fold(
      (f) => emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          actionFailure: f,
        ),
      ),
      (_) => emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.success,
          profile: profile.copyWith(name: name, email: email),
        ),
      ),
    );
  }

  Future<void> addAddress({
    required String title,
    required String fullAddress,
    required double lat,
    required double lng,
  }) async {
    final profile = state.profile;
    if (profile == null) return;

    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.loading,
        action: ProfileAction.addAddress,
      ),
    );
    final result = await repo.addAddress(
      title: title,
      fullAddress: fullAddress,
      lat: lat,
      lng: lng,
      isDefault: profile.addresses.isEmpty,
    );
    result.fold(
      (f) => emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          actionFailure: f,
        ),
      ),
      (address) => emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.success,
          profile: profile.copyWith(addresses: [...profile.addresses, address]),
        ),
      ),
    );
  }

  Future<void> deleteAddress(int id) async {
    final profile = state.profile;
    if (profile == null) return;

    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.loading,
        action: ProfileAction.deleteAddress,
      ),
    );

    final result = await repo.deleteAddress(id: id);
    result.fold(
      (f) => emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          actionFailure: f,
        ),
      ),
      (_) {
        final deleted = profile.addresses.firstWhere((a) => a.id == id);
        var remaining = profile.addresses.where((a) => a.id != id).toList();

        // لو المحذوف كان الافتراضي، أول عنوان متبقي بيبقى الافتراضي
        if (deleted.isDefault && remaining.isNotEmpty) {
          remaining = [
            remaining.first.copyWith(isDefault: true),
            ...remaining.skip(1),
          ];
        }

        emit(
          state.copyWith(
            actionStatus: ProfileActionStatus.success,
            profile: profile.copyWith(addresses: remaining),
          ),
        );
      },
    );
  }

  Future<void> setDefaultAddress(int id) async {
    final profile = state.profile;
    if (profile == null) return;

    emit(
      state.copyWith(
        actionStatus: ProfileActionStatus.loading,
        action: ProfileAction.setDefaultAddress,
      ),
    );

    final result = await repo.setDefaultAddress(id: id);
    result.fold(
      (f) => emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          actionFailure: f,
        ),
      ),
      (_) {
        final updated =
            profile.addresses
                .map((a) => a.copyWith(isDefault: a.id == id))
                .toList()
              // الافتراضي يطلع أول القايمة
              ..sort((a, b) => (b.isDefault ? 1 : 0) - (a.isDefault ? 1 : 0));

        emit(
          state.copyWith(
            actionStatus: ProfileActionStatus.success,
            profile: profile.copyWith(addresses: updated),
          ),
        );
      },
    );
  }
}
