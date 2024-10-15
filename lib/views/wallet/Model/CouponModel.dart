class CouponModel {
  String? id;
  String? code;
  String? title;
  String? amountDeducted;
  int? minOrderAmount;

  CouponModel(
      {
        required this.id,
        required this.code,
        required this.title,
        required this.amountDeducted,
        required this.minOrderAmount
      });

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    code = json['code'];
    title = json['title'];
    amountDeducted = json['value'];
    minOrderAmount = json['min_order_amt'];
    }
}