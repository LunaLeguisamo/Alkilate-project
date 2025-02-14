import 'package:alkilate/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/login/login.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});
  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final depositController = TextEditingController();
  final bankAccountController = TextEditingController();
  // final locationController = TextEditingController();
  // final picturesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return const ErrorMessage();
        } else if (snapshot.hasData) {
          return formBuilder(context);
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  Widget formBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: brandController,
              decoration: InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: depositController,
              decoration: InputDecoration(labelText: 'Deposit'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: bankAccountController,
              decoration: InputDecoration(labelText: 'Bank Account'),
            ),
            // TextField(
            //   controller: locationController,
            //   decoration: InputDecoration(labelText: 'Location'),
            // ),
            // TextField(
            //   controller: picturesController,
            //   decoration: InputDecoration(labelText: 'Pictures'),
            // ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    brandController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    depositController.text.isEmpty ||
                    bankAccountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                double? price;
                double? deposit;

                try {
                  price = double.parse(priceController.text);
                  deposit = double.parse(depositController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Please enter valid numbers for price and deposit')),
                  );
                  return;
                }

                final product = Product(
                  owner: AuthService().user!.uid,
                  name: nameController.text,
                  brand: brandController.text,
                  category: categoryController.text,
                  price: price,
                  deposit: deposit,
                  bankAccount: bankAccountController.text,
                );

                try {
                  await FirestoreService().postProduct(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product added successfully')),
                  );
                  Navigator.of(context).pushReplacementNamed('/');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add product: $e')),
                  );
                }
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
