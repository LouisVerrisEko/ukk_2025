import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Masukkan email yang valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  void _openEmailApp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.email),
                    onPressed: _openEmailApp,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: _validatePassword,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Isi Email Dan Password Terlebih Dahulu')),
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Penjualan',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

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

  String accountName = "Louis"; // Example account name

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void addSale(String customerId, List<Map<String, dynamic>> items) {
    setState(() {
      sales.add(Sale(customerId, items));
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void _editProduct(Product product, int index) {
    final TextEditingController _productController =
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
                controller: _productController,
                decoration: InputDecoration(labelText: "Nama Produk"),
              ),
              TextField(
                controller: _stockController,
                decoration: InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  products[index].name = _productController.text;
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
    final TextEditingController _productController = TextEditingController();
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
                controller: _productController,
                decoration: InputDecoration(labelText: "Nama Produk"),
              ),
              TextField(
                controller: _stockController,
                decoration: InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  products.add(Product(
                    _productController.text,
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

  void _editCustomer(Customer customer, int index) {
    final TextEditingController _customerController =
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
                controller: _customerController,
                decoration: InputDecoration(labelText: "Nama Pelanggan"),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Alamat"),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Nomor Telepon"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  customers[index].name = _customerController.text;
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

  void _deleteCustomer(int index) {
    setState(() {
      customers.removeAt(index);
    });
  }

  // Add method to add new customer
  void _addCustomer() {
    final TextEditingController _customerController = TextEditingController();
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
                controller: _customerController,
                decoration: InputDecoration(labelText: "Nama Pelanggan"),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Alamat"),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Nomor Telepon"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  customers.add(Customer(
                    _customerController.text,
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
                  ],
                ),
              );
            },
          ),
          // Penjualan Tab
          ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.sell),
                title: Text('Pelanggan ID: ${sales[index].customerId}'),
                subtitle: Text(
                    'Produk: ${sales[index].items.map((item) => item['productId']).join(', ')}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {},
                ),
              );
            },
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
  final String customerId;
  final List<Map<String, dynamic>> items;

  Sale(this.customerId, this.items);
}
