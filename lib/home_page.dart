//nama pembeli
//Total
//Tanggal

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/struk.dart';
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
  List<Map<String, dynamic>> products = [];

  List<Map> sales = [];

  String accountName = "Louis";

  // Keranjang Belanja
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0.0;
  void fetchProduk() async {
    var result = await Supabase.instance.client
        .from("produk")
        .select()
        .order("ProdukID", ascending: true);
    setState(() {
      products = result;
    });
  }

  void fetchPelanggan() async {
    var result = await Supabase.instance.client
        .from("pelanggan")
        .select()
        .order("PelangganID", ascending: true);
    setState(() {
      customers = result;
    });
  }

  void fetchSales() async {
    var result = await Supabase.instance.client
        .from("penjualan")
        .select("*, pelanggan(*), detailpenjualan(*, produk(*))");
    setState(() {
      sales = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    fetchProduk();
    fetchSales();
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
  void _showProductDialog(Map<String, dynamic> product) {
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Jumlah untuk ${product["NamaProduk"]}'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Jumlah',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int quantity = int.parse(quantityController.text);
                int totalProductPrice = (product["Harga"] * quantity) as int;
                product["JumlahProduk"] = quantity;
                product["Subtotal"] = totalProductPrice;
                setState(() {
                  cartItems.add(product);
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

  _checkout(int customerId) async {
    var penjualan = await Supabase.instance.client.from("penjualan").insert([
      {"TotalHarga": totalAmount, "PelangganID": customerId}
    ]).select();
    // Cek jika keranjang belanja tidak kosong
    if (cartItems.isNotEmpty) {
      double totalAmountBeforeCheckout = 0.0;
      List<Map<String, dynamic>> itemsToRemove = [];

      List detailSales = [];
      // Menghitung total harga seluruh keranjang belanja sebelum checkout
      for (var cartItem in cartItems) {
        detailSales.add({
          "PenjualanID": penjualan[0]["PenjualanID"],
          "ProdukID": cartItem["ProdukID"],
          "JumlahProduk": cartItem["JumlahProduk"],
          "Subtotal": cartItem["Subtotal"]
        });
      }

      await Supabase.instance.client
          .from("detailpenjualan")
          .insert(detailSales);

      for (var cartItem in cartItems) {
        cartItem["Stok"] -= cartItem["JumlahProduk"];
        cartItem.remove("Subtotal");
        cartItem.remove("JumlahProduk");
      }
      await Supabase.instance.client.from("produk").upsert(cartItems);
      fetchSales();
      return true;
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
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
                      onPressed: () => _editCustomer(
                          customers[index], customers[index]["PelangganID"]),
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
                      title: Text(item["NamaProduk"]),
                      subtitle: Text(
                          'Jumlah: ${item['JumlahProduk']} | Total: Rp ${item['Subtotal']}'),
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
                    onPressed: () {
                      var pelangganCtrl = SingleValueDropDownController();

                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropDownTextField(
                                      controller: pelangganCtrl,
                                      dropDownList: [
                                        ...List.generate(customers.length,
                                            (index) {
                                          return DropDownValueModel(
                                              name: customers[index]
                                                  ["NamaPelanggan"],
                                              value: customers[index]
                                                  ["PelangganID"]);
                                        })
                                      ]),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      var result = await _checkout(
                                          pelangganCtrl.dropDownValue!.value);
                                      if (result == true) {
                                        setState(() {
                                          cartItems.clear();
                                          totalAmount = 0;
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: Text("Checkout"),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.lightBlueAccent),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent),
                    child: Text('Pilih pembeli'),
                  ),
                ),
            ],
          ),
          ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text(sales[index]["pelanggan"]["NamaPelanggan"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Harga: ${sales[index]["TotalHarga"]}'),
                      Text(
                          'Tanggal penjualan: ${sales[index]["TanggalPenjualan"]}'),
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    struk(penjualan: sales[index])));
                      },
                      icon: Icon(Icons.print)));
            },
          ),
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

