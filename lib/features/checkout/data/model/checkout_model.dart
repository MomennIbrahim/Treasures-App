class PlacedOrderModel {
  final int orderId;
  final num total;

  const PlacedOrderModel({required this.orderId, required this.total});

  factory PlacedOrderModel.fromJson(Map<String, dynamic> json) {
    return PlacedOrderModel(
      orderId: int.tryParse('${json['order_id']}') ?? 0,
      total: json['total'] is num
          ? json['total'] as num
          : (num.tryParse('${json['total']}') ?? 0),
    );
  }
}