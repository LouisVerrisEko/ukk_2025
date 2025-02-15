import 'models.dart';

void addSale(String customerId, List<Map<String, dynamic>> productDetails) {
  List<SaleDetail> saleDetails = [];
  double totalPrice = 0;

  for (var item in productDetails) {
    var products;
    Product product = products.firstWhere((p) => p.id == item['productId']);
    int quantity = item['quantity'];
    double detailTotal = product.price * quantity;
    saleDetails.add(SaleDetail(
      productId: product.id,
      quantity: quantity,
      totalPrice: detailTotal,
    ));
    totalPrice += detailTotal;
  }

  Sale sale = Sale(
    id: DateTime.now().toString(),
    customerId: customerId,
    date: DateTime.now(),
    details: saleDetails,
  );

}
