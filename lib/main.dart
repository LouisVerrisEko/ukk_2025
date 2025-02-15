import 'package:flutter/material.dart';
import 'models.dart';
import 'sales_service.dart';

void main() {
  runApp(MyApp());
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
    Customer('Louis'),
    Customer('Yesra'),
    Customer('Nopal'),
    Customer('Rangga'),
  ];

  final List<Product> products = [
    Product('Sepatu Running Nineteen 910'),
    Product('Sepatu Running Nike Zoom Alphafly'),
    Product('Jam Running'),
    Product('Jersey Running'),
  ];

  final List<Sale> sales = [];

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

  void _editCustomer(Customer customer, int index) {
    final TextEditingController _customerController =
        TextEditingController(text: customer.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Pelanggan"),
          content: TextField(
            controller: _customerController,
            decoration: InputDecoration(labelText: "Nama Pelanggan"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  customers[index].name = _customerController.text;
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

  void _editProduct(Product product, int index) {
    final TextEditingController _productController =
        TextEditingController(text: product.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Produk"),
          content: TextField(
            controller: _productController,
            decoration: InputDecoration(labelText: "Nama Produk"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  products[index].name = _productController.text;
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

  void _editSale(Sale sale, int saleIndex) {
    final TextEditingController _productController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Detail Penjualan"),
          content: Column(
            children: sale.items.map((item) {
              _productController.text = item['productId'];
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _productController,
                      decoration: InputDecoration(labelText: "Produk ID"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () {
                      setState(() {
                        item['productId'] = _productController.text;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Penjualan'),
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
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editCustomer(customers[index], index),
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
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editProduct(products[index], index),
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
                  onPressed: () => _editSale(sales[index], index),
                ),
              );
            },
          ),
          // Detail Penjualan Tab
          Center(child: Text('Detail Penjualan')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addSale('1', [
            {'productId': '1', 'quantity': 1},
            {'productId': '2', 'quantity': 2},
          ]);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Customer {
  String name;

  Customer(this.name);
}

class Product {
  String name;

  Product(this.name);
}

class Sale {
  final String customerId;
  final List<Map<String, dynamic>> items;

  Sale(this.customerId, this.items);
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

  void _openEmailApp() {
  }

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
                    onPressed:
                        _openEmailApp,
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
                        _isPasswordVisible =
                            !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText:
                    !_isPasswordVisible, 
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
