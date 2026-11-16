import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:konoz/core/constance/app_keys.dart';
import 'package:konoz/core/cubits/safe_cubit.dart';
import 'package:konoz/core/error/app_failure.dart';
import 'package:konoz/core/local_storage/session_storage.dart';
import 'package:konoz/features/profile/data/model/profile_model.dart';
import 'package:konoz/features/profile/data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends SafeCubit<ProfileState> {
  final ProfileRepo _repo;
  ProfileCubit(this._repo) : super(const ProfileState());

  bool get _hasToken => AppConstance.userToken != null;

  /// [silent] = true: تحديث هادي من غير skeleton (لو فيه بيانات قديمة)
  /// [force] = true: يجيب من السيرفر حتى لو البيانات متحمّلة بالفعل
  Future<void> getProfile({bool silent = false, bool force = false}) async {
    if (!_hasToken) {
      emit(const ProfileState(status: ProfileStatus.guest));
      return;
    }
    if (state.isLoading) return;
    if (state.isSuccess && state.profile != null && !force) return;

    final showLoading = !silent || state.profile == null;
    if (showLoading) emit(state.copyWith(status: ProfileStatus.loading));

    final res = await _repo.getProfile();

    await res.fold(
      (failure) async {
        // التوكن منتهي: الجلسة خلصت
        if (failure is RemoteServerFailure && failure.statusCode == 401) {
          await SessionStorage.clear();
          emit(const ProfileState(status: ProfileStatus.guest));
          return;
        }
        if (showLoading) {
          emit(state.copyWith(status: ProfileStatus.failure, failure: failure));
        } else {
          // تحديث هادي فشل: نرجّع الحالة لـ success بالبيانات القديمة
          emit(state.copyWith(status: ProfileStatus.success));
        }
      },
      (profile) async =>
          emit(state.copyWith(status: ProfileStatus.success, profile: profile)),
    );
  }

  Future<void> updateProfile({required String name}) => _run(
    ProfileAction.updateProfile,
    () => _repo.updateProfile(name: name),
    onSuccess: () => state.profile?.copyWith(name: name),
  );

  Future<void> updatePhone(String phone) => _run(
    ProfileAction.updatePhone,
    () => _repo.updatePhone(phone: phone),
    onSuccess: () => state.profile?.copyWith(phone: phone),
  );

  Future<void> addAddress({
    required String title,
    required String fullAddress,
    required double lat,
    required double lng,
  }) => _run(ProfileAction.addAddress, () async {
    final res = await _repo.addAddress(
      title: title,
      fullAddress: fullAddress,
      lat: lat,
      lng: lng,
      // أول عنوان بيبقى الافتراضي
      isDefault: (state.profile?.addresses ?? const []).isEmpty,
    );
    return res.map((_) => unit);
  }, reload: true);

  Future<void> deleteAddress(int id) => _run(
    ProfileAction.deleteAddress,
    () => _repo.deleteAddress(id: id),
    reload: true, // السيرفر ممكن يغيّر الافتراضي بعد الحذف
  );

  Future<void> setDefaultAddress(int id) => _run(
    ProfileAction.setDefaultAddress,
    () => _repo.setDefaultAddress(id: id),
    // تحديث فوري، وبعدها reload عشان نزامن الترتيب (الافتراضي الأول)
    onSuccess: () => state.profile?.copyWith(
      addresses: [
        for (final a in state.profile!.addresses)
          a.copyWith(isDefault: a.id == id),
      ],
    ),
    reload: true,
  );

  Future<void> _run(
    ProfileAction action,
    Future<Either<AppFailure, Unit>> Function() call, {
    ProfileModel? Function()? onSuccess,
    bool reload = false,
  }) async {
    if (state.isActionLoading) return;
    emit(
      state.copyWith(actionStatus: ProfileActionStatus.loading, action: action),
    );

    final res = await call();

    res.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ProfileActionStatus.failure,
          action: action,
          actionFailure: failure,
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            actionStatus: ProfileActionStatus.success,
            action: action,
            profile: onSuccess?.call(),
          ),
        );
        // force: لازم، وإلا getProfile بتخرج فورًا لأن البروفايل متحمّل
        if (reload) getProfile(silent: true, force: true);
      },
    );
  }

  /// عند الـ logout: بيرجّع حالة الضيف (مختلفة عن initial فبتعمل emit فعلًا)
  void clear() => emit(const ProfileState(status: ProfileStatus.guest));
}