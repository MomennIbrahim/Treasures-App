part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

extension ProfileStateX on ProfileState {
  bool get isInitial => status == ProfileStatus.initial;
  bool get isLoading => status == ProfileStatus.loading;
  bool get isSuccess => status == ProfileStatus.success;
  bool get isFailure => status == ProfileStatus.failure;
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final AppFailure? failure;
  final ProfileModel? profile;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.failure,
    this.profile,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    AppFailure? failure,
    ProfileModel? profile,
  }) {
    return ProfileState(
      status: status ?? this.status,
      failure: failure,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [status, failure, profile];
}
