part of 'package_details_cubit.dart';

enum PackageDetailsStatus { initial, loading, success, failure }

enum PackageAddStatus { idle, loading, success, failure }

class PackageDetailsState extends Equatable {
  // تحميل الباكدج
  final PackageDetailsStatus status;
  final AppFailure? failure;
  final PackageDetailsModel? package;

  // إضافة منتجات الباكدج للسلة
  final PackageAddStatus addStatus;
  final AppFailure? addFailure;

  const PackageDetailsState({
    this.status = PackageDetailsStatus.initial,
    this.failure,
    this.package,
    this.addStatus = PackageAddStatus.idle,
    this.addFailure,
  });

  bool get isFailure => status == PackageDetailsStatus.failure;
  bool get isAdding => addStatus == PackageAddStatus.loading;

  // failure بيتصفّر عن قصد لو متبعتش
  PackageDetailsState copyWith({
    PackageDetailsStatus? status,
    AppFailure? failure,
    PackageDetailsModel? package,
    PackageAddStatus? addStatus,
    AppFailure? addFailure,
  }) => PackageDetailsState(
    status: status ?? this.status,
    failure: failure,
    package: package ?? this.package,
    addStatus: addStatus ?? this.addStatus,
    addFailure: addFailure,
  );

  @override
  List<Object?> get props =>
      [status, failure, package, addStatus, addFailure];
}
