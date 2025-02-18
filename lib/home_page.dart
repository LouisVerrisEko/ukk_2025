import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Customer> customers = [
    Customer('Louis', 'Tugurejo', '081222333666'),
    Customer('Yesra', 'Kromengan', '081888333111'),
    Customer('Nopal', 'Karangkates', '081999555111'),
    Customer('Rangga', 'Karangrejo', '081666777999'),
  ];

  final List<Product> products = [
    Product('Sepatu Running Nineteen 910', 10, 100000),
    Product('Sepatu Running Nike Zoom Alphafly', 15, 150000),
    Product('Jam Running', 20, 50000),
    Product('Jersey Running', 30, 70000),
  ];

  final List<Sale> sales = [];

  String accountName = "Louis";

  // Keranjang Belanja
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  // Customer Management
  void _deleteCustomer(int index) {
    setState(() {
      customers.removeAt(index);
    });
  }

  void _editCustomer(Customer customer, int index) {
    final TextEditingController _nameController =
        TextEditingController(text: customer.name);
    final TextEditingController _addressController =
        TextEditingController(text: customer.address);
    final TextEditingController _phoneController =
        TextEditingController(text: customer.phoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Pelanggan"),
          content: Column(
            children: [
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nama Pelanggan")),
              TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: "Alamat")),
              TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Nomor Telepon")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  customers[index].name = _nameController.text;
                  customers[index].address = _addressController.text;
                  customers[index].phoneNumber = _phoneController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _addCustomer() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Pelanggan"),
          content: Column(
            children: [
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nama Pelanggan")),
              TextField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: "Alamat")),
              TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Nomor Telepon")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  customers.add(Customer(
                    _nameController.text,
                    _addressController.text,
                    _phoneController.text,
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text('Tambah'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  // Product Management
  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void _editProduct(Product product, int index) {
    final TextEditingController _nameController =
        TextEditingController(text: product.name);
    final TextEditingController _stockController =
        TextEditingController(text: product.stock.toString());
    final TextEditingController _priceController =
        TextEditingController(text: product.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Produk"),
          content: Column(
            children: [
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nama Produk")),
              TextField(
                  controller: _stockController,
                  decoration: InputDecoration(labelText: "Stok"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  products[index].name = _nameController.text;
                  products[index].stock = int.parse(_stockController.text);
                  products[index].price = double.parse(_priceController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _addProduct() {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _stockController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Produk"),
          content: Column(
            children: [
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nama Produk")),
              TextField(
                  controller: _stockController,
                  decoration: InputDecoration(labelText: "Stok"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  products.add(Product(
                    _nameController.text,
                    int.parse(_stockController.text),
                    double.parse(_priceController.text),
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text('Tambah'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  // Keranjang Belanja
  void _showProductDialog(Product product) {
    final TextEditingController _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Jumlah untuk ${product.name}'),
          content: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int quantity = int.parse(_quantityController.text);
                double totalProductPrice = product.price * quantity;
                setState(() {
                  cartItems.add({
                    'product': product,
                    'quantity': quantity,
                    'totalPrice': totalProductPrice,
                  });
                  totalAmount += totalProductPrice;
                });
                Navigator.of(context).pop();
              },
              child: Text('Tambahkan ke Keranjang'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _checkout(String customerId) {
    // Cek jika keranjang belanja tidak kosong
    if (cartItems.isNotEmpty) {
      double totalAmountBeforeCheckout = 0.0;
      List<Map<String, dynamic>> itemsToRemove = [];

      // Menghitung total harga seluruh keranjang belanja sebelum checkout
      for (var cartItem in cartItems) {
        Product product = cartItem['product'];
        int quantity = cartItem['quantity'];
        totalAmountBeforeCheckout += product.price * quantity;
      }

      // Membuat list untuk checkout satu per satu
      for (var cartItem in cartItems) {
        Product product = cartItem['product'];
        int quantity = cartItem['quantity'];

        // Hitung total harga produk berdasarkan quantity
        double totalProductPrice = product.price * quantity;

        // Cek apakah stok produk mencukupi
        if (product.stock >= quantity) {
          setState(() {
            // Mengurangi stok produk sesuai dengan jumlah yang dibeli
            product.stock -= quantity;

            // Pastikan stok tidak menjadi negatif
            if (product.stock < 0) {
              product.stock = 0;
            }

            // Menambahkan transaksi penjualan untuk setiap produk
            sales.add(Sale(customerId, [cartItem], totalProductPrice));
          });

          // Menyimpan item untuk dihapus setelah checkout
          itemsToRemove.add(cartItem);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.name} - Transaksi Berhasil')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Stok Tidak Cukup untuk ${product.name}')));
        }
      }

      // Hapus produk dari keranjang setelah checkout selesai
      for (var item in itemsToRemove) {
        cartItems.remove(item);
      }

      // Update totalAmount setelah seluruh checkout selesai
      setState(() {
        totalAmount = 0.0; // Reset totalAmount ke 0 setelah checkout selesai
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Keranjang Belanja Kosong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Penjualan'),
        backgroundColor: Colors.lightBlueAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.person), text: 'Pelanggan'),
            Tab(icon: Icon(Icons.shopping_bag), text: 'Produk'),
            Tab(icon: Icon(Icons.sell), text: 'Penjualan'),
            Tab(icon: Icon(Icons.details), text: 'Detail Penjualan'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    accountName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Pelanggan'),
              onTap: () {
                _tabController.index = 0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Produk'),
              onTap: () {
                _tabController.index = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.sell),
              title: Text('Penjualan'),
              onTap: () {
                _tabController.index = 2;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.details),
              title: Text('Detail Penjualan'),
              onTap: () {
                _tabController.index = 3;
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                // Implement logout logic here
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pelanggan Tab
          ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(customers[index].name),
                subtitle: Text(
                    'Alamat: ${customers[index].address}\nNomor Telepon: ${customers[index].phoneNumber}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editCustomer(customers[index], index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCustomer(index),
                    ),
                  ],
                ),
              );
            },
          ),
          // Produk Tab
          ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text(products[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stok: ${products[index].stock}'),
                    Text('Harga: ${products[index].price}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editProduct(products[index], index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteProduct(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () => _showProductDialog(products[index]),
                    ),
                  ],
                ),
              );
            },
          ),
          // Penjualan Tab
          ListView(
            children: [
              if (cartItems.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      title: Text(item['product'].name),
                      subtitle: Text(
                          'Jumlah: ${item['quantity']} | Total: Rp ${item['totalPrice']}'),
                    );
                  },
                ),
              if (cartItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Total: Rp $totalAmount',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              if (cartItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _checkout(accountName),
                    child: Text('Checkout'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent),
                  ),
                ),
            ],
          ),
          // Detail Penjualan Tab
          Center(child: Text('Detail Penjualan')),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _addProduct,
              child: Icon(Icons.add_shopping_cart),
            ),
            SizedBox(width: 10), // Spacer between buttons
            FloatingActionButton(
              onPressed: _addCustomer,
              child: Icon(Icons.person_add),
            ),
          ],
        ),
      ),
    );
  }
}

class Customer {
  String name;
  String address;
  String phoneNumber;

  Customer(this.name, this.address, this.phoneNumber);
}

class Product {
  String name;
  int stock;
  double price;

  Product(this.name, this.stock, this.price);
}

class Sale {
  String customerId;
  List<Map<String, dynamic>> cartItems;
  double totalAmount;

  Sale(this.customerId, this.cartItems, this.totalAmount);
}
