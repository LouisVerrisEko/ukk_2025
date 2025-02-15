class Customer {
  final String id;
  final String name;

  Customer({required this.id, required this.name});
}

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class Sale {
  final String id;
  final String customerId;
  final DateTime date;
  final List<SaleDetail> details;

  Sale(
      {required this.id,
      required this.customerId,
      required this.date,
      required this.details});
}

class SaleDetail {
  final String productId;
  final int quantity;
  final double totalPrice;

  SaleDetail(
      {required this.productId,
      required this.quantity,
      required this.totalPrice});
}
