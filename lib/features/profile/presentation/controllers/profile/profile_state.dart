part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, failure }

enum ProfileActionStatus { idle, loading, success, failure }

enum ProfileAction {
  updateProfile,
  addAddress,
  deleteAddress,
  setDefaultAddress,
}

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
  final ProfileActionStatus actionStatus;
  final ProfileAction? action;
  final AppFailure? actionFailure;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.failure,
    this.profile,
    this.actionStatus = ProfileActionStatus.idle,
    this.action,
    this.actionFailure,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    AppFailure? failure,
    ProfileModel? profile,
    ProfileActionStatus? actionStatus,
    ProfileAction? action,
    AppFailure? actionFailure,
  }) {
    return ProfileState(
      status: status ?? this.status,
      failure: failure,
      profile: profile ?? this.profile,
      actionStatus: actionStatus ?? this.actionStatus,
      action: action ?? this.action,
      actionFailure: actionFailure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    failure,
    profile,
    actionStatus,
    action,
    actionFailure,
  ];
}
