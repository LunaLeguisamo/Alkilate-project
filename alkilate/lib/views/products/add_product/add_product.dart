// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/login/login.dart';
import 'package:alkilate/shared/shared.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final depositController = TextEditingController();
  final bankAccountController = TextEditingController();

  List<File>? pickedFiles;
  bool isLoading = false; // Track loading state

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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                  ),
                  TextField(
                    controller: brandController,
                    decoration: const InputDecoration(labelText: 'Brand'),
                  ),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: depositController,
                    decoration: const InputDecoration(labelText: 'Deposit'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: bankAccountController,
                    decoration:
                        const InputDecoration(labelText: 'Bank Account'),
                  ),
                  const SizedBox(height: 20),
                  // File selection and display
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : selectFile, // Disable button while loading
                    child: const Text('Select Images'),
                  ),
                  if (pickedFiles != null)
                    Column(
                      children: [
                        const Text('Selected Files:'),
                        ...pickedFiles!.map((file) => Text(file.path)),
                      ],
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            // Disable button while loading
                            // Validate fields
                            if (nameController.text.isEmpty ||
                                brandController.text.isEmpty ||
                                categoryController.text.isEmpty ||
                                priceController.text.isEmpty ||
                                depositController.text.isEmpty ||
                                bankAccountController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please fill in all fields')),
                              );
                              return;
                            }

                            // Validate price and deposit
                            double? price;
                            double? deposit;
                            try {
                              price = double.parse(priceController.text);
                              deposit = double.parse(depositController.text);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please enter valid numbers for price and deposit'),
                                ),
                              );
                              return;
                            }

                            // Validate file selection
                            if (pickedFiles == null || pickedFiles!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please select at least one image')),
                              );
                              return;
                            }

                            // Start loading
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              // Upload files and get URLs
                              final imageUrls = await uploadFile();
                              if (imageUrls.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Failed to upload images')),
                                );
                                return;
                              }

                              // Create product
                              final product = Product(
                                owner: AuthService().user!.uid,
                                name: nameController.text,
                                brand: brandController.text,
                                category: categoryController.text,
                                price: price,
                                deposit: deposit,
                                bankAccount: bankAccountController.text,
                                pictures: imageUrls,
                              );

                              // Save product to Firestore
                              await FirestoreService()
                                  .addProductToUser(product);
                              await FirestoreService().postProduct(product);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Product added successfully')),
                              );
                              Navigator.of(context).pushReplacementNamed('/');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Failed to add product: $e')),
                              );
                            } finally {
                              // Stop loading
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
          // Loading overlay
          if (isLoading)
            const Center(
              child: LoadingScreen(), // Use your custom LoadingScreen widget
            ),
        ],
      ),
    );
  }

  // File selector
  Future<void> selectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    List<File> files =
        result.paths.whereType<String>().map((path) => File(path)).toList();

    setState(() {
      pickedFiles = files;
    });
  }

  // File uploader
  Future<List<String>> uploadFile() async {
    List<String> urls = [];
    if (pickedFiles != null) {
      var uuid = Uuid();
      final user = AuthService().user!;
      final route = '${user.uid}/${uuid.v4()}';

      for (var pickedFile in pickedFiles!) {
        try {
          final path = '$route/${pickedFile.uri.pathSegments.last}';
          final file = File(pickedFile.path);
          final ref = FirebaseStorage.instance.ref().child(path);

          // Upload the file and wait for it to complete
          await ref.putFile(file);

          // Get the download URL
          final downloadUrl = await ref.getDownloadURL();
          urls.add(downloadUrl);
        } catch (e) {
          print('Error uploading file: $e');
        }
      }
    }
    return urls;
  }
}
