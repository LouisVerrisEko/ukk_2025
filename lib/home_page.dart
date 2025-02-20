import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map> customers = [];
  List<Map> products = [];

  final List<Sale> sales = [];

  String accountName = "Louis";

  // Keranjang Belanja
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0.0;
  void fetchProduk() async {
    var result = await Supabase.instance.client.from("produk").select().order("ProdukID", ascending: true);
    setState(() {
      products = result;
    });
  }

  void fetchPelanggan() async {
    var result = await Supabase.instance.client.from("pelanggan").select().order("PelangganID", ascending: true);
    setState(() {
      customers = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    fetchProduk();
    _tabController = TabController(length: 4, vsync: this);
  }

  // Customer Management
  void _deleteCustomer(int id) async {
    await Supabase.instance.client
        .from("pelanggan")
        .delete()
        .eq("PelangganID", id);
    fetchPelanggan();
  }

  void _editCustomer(Map customer, int id) {
    final TextEditingController nameController =
        TextEditingController(text: customer["NamaPelanggan"]);
    final TextEditingController addressController =
        TextEditingController(text: customer["Alamat"]);
    final TextEditingController phoneController =
        TextEditingController(text: customer["NomorTelepon"]);
    final formPelanggan = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Pelanggan"),
          content: Form(
            key: formPelanggan,
            child: Column(
              children: [
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Nama Pelanggan")),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Alamat tidak boleh kosong";
                      }
                      return null;
                    },
                    controller: addressController,
                    decoration: InputDecoration(labelText: "Alamat")),
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nomor telepon tidak boleh kosong";
                      }
                      return null;
                    },
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Nomor Telepon")),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formPelanggan.currentState!.validate()) {
                  await Supabase.instance.client.from("pelanggan").update({
                    "NamaPelanggan": nameController.text,
                    "NomorTelepon": phoneController.text,
                    "Alamat": addressController.text
                  }).eq("PelangganID", id);
                  fetchPelanggan();
                  Navigator.of(context).pop();
                }
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
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final formPelanggan = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tambah Pelanggan"),
          content: Form(
            key: formPelanggan,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Nama Pelanggan"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Alamat"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Alamat tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: "Nomor Telepon"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nomor telepon tidak boleh kosong";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formPelanggan.currentState!.validate()) {
                  await Supabase.instance.client.from("pelanggan").insert([
                    {
                      "NamaPelanggan": nameController.text,
                      "Alamat": addressController.text,
                      "NomorTelepon": phoneController.text
                    }
                  ]);
                  fetchPelanggan();
                  Navigator.of(context).pop();
                }
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
  void _deleteProduct(int id) async {
    await Supabase.instance.client.from("produk").delete().eq("ProdukID", id);
    fetchProduk();
    // setState(() {
    //   products.removeAt(index);
    // });
  }

  void _editProduct(Map product, int id) {
    final TextEditingController nameController =
        TextEditingController(text: product["NamaProduk"]);
    final TextEditingController stockController =
        TextEditingController(text: product["Stok"].toString());
    final TextEditingController priceController =
        TextEditingController(text: product["Harga"].toString());
    final formProduk = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Produk"),
          content: Form(
            key: formProduk,
            child: Column(
              children: [
                TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Nama Produk"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama produk tidak boleh kosong";
                      }
                      return null;
                    }),
                TextFormField(
                    controller: stockController,
                    decoration: InputDecoration(labelText: "Stok"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Stok produk tidak boleh kosong";
                      }
                      return null;
                    }),
                TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: "Harga"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Harga produk tidak boleh kosong";
                      }
                      return null;
                    }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (formProduk.currentState!.validate()) {
                  await Supabase.instance.client.from("produk").update({
                    "NamaProduk": nameController.text,
                    "Stok": stockController.text,
                    "Harga": priceController.text
                  }).eq("ProdukID", id);
                  fetchProduk();
                  Navigator.of(context).pop();
                }
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
    final TextEditingController nameController = TextEditingController();
    final TextEditingController stockController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var fromProduk = GlobalKey<FormState>();
        return AlertDialog(
          title: Text("Tambah Produk"),
          content: Form(
            key: fromProduk,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Nama Produk"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama produk tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: stockController,
                    decoration: InputDecoration(labelText: "Stok"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Stok produk tidak boleh kosong";
                      }
                      return null;
                    }),
                TextFormField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: "Harga"),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Harga produk tidak boleh kosong";
                      }
                      return null;
                    }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (fromProduk.currentState!.validate()) {
                  await Supabase.instance.client.from("produk").insert([
                    {
                      "NamaProduk": nameController.text,
                      "Stok": stockController.text,
                      "Harga": priceController.text
                    }
                  ]);
                  fetchProduk();
                  Navigator.of(context).pop();
                }
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
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Jumlah untuk ${product.name}'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Jumlah',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int quantity = int.parse(quantityController.text);
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
          tabs: const [
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
                title: Text(customers[index]["NamaPelanggan"]),
                subtitle: Text(
                    'Alamat: ${customers[index]["Alamat"]}\nNomor Telepon: ${customers[index]["NomorTelepon"]}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editCustomer(customers[index], customers[index]["PelangganID"]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          _deleteCustomer(customers[index]["PelangganID"]),
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
                title: Text(products[index]["NamaProduk"]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Stok: ${products[index]["Stok"]}'),
                    Text('Harga: ${products[index]["Harga"]}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editProduct(
                          products[index], products[index]["ProdukID"]),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          _deleteProduct(products[index]["ProdukID"]),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_shopping_cart),
                      onPressed: () => _showProductDialog(products[index][""]),
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent),
                    child: Text('Checkout'),
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
