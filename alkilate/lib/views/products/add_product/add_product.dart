// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  // Controllers and state variables
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final depositController = TextEditingController();
  final bankAccountController = TextEditingController();
  final timeController = TextEditingController();

  List<File>? pickedFiles;
  bool isLoading = false;
  DateTimeRange? _selectedDateRange; // Added for date range selection

  // Predefined categories and times
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Furniture',
    'Books',
    'Sports',
    'Other',
  ];

  final List<String> times = [
    '/Hour',
    '/Day',
    '/Use',
  ];

  LatLng? _selectedLocation;

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                    child: const Text(
                      'Publish your own product or service',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      nameController, 'Write the product or service name'),
                  const SizedBox(height: 20),
                  // Date Range Selector
                  _buildDateRangeSelector(),
                  const SizedBox(height: 20),
                  LocationPickerWidget(
                    onLocationSelected: (LatLng location) {
                      print('Selected location: $location');
                      _selectedLocation =
                          location; // Save the location to state
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                      descriptionController, 'Write the description',
                      maxLines: 4),
                  const SizedBox(height: 20),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 20),
                  _buildPriceAndTimeRow(),
                  const SizedBox(height: 20),
                  _buildTextField(depositController, 'Deposit',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _buildTextField(bankAccountController, 'Bank Account'),
                  const SizedBox(height: 20),
                  _buildFilePicker(),
                  const SizedBox(height: 20),
                  _buildAddProductButton(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          if (isLoading) const LoadingScreen(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F1B1B1B),
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 11),
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: commonInputDecoration(labelText),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        InkWell(
          onTap: _showDateRangePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F1B1B1B),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDateRange == null
                      ? 'Select a date range'
                      : '${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 11,
                    color: _selectedDateRange == null
                        ? Color(0xff7F7F7F)
                        : Colors.black,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xff7F7F7F),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(Duration(days: 7)),
          ),
    );

    if (pickedDateRange != null && pickedDateRange != _selectedDateRange) {
      setState(() {
        _selectedDateRange = pickedDateRange;
      });
    }
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F1B1B1B),
            blurRadius: 4,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: categoryController.text.isEmpty ? null : categoryController.text,
        decoration: commonInputDecoration('Select a category'),
        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xff7F7F7F),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            categoryController.text = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildPriceAndTimeRow() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(priceController, 'Define the price',
              keyboardType: TextInputType.number),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F1B1B1B),
                  blurRadius: 4,
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: timeController.text.isEmpty ? null : timeController.text,
              decoration: commonInputDecoration('Time'),
              items: times.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff7F7F7F),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  timeController.text = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Column(
      children: [
        InkWell(
          onTap: isLoading ? null : selectFile,
          child: Image.asset('assets/images/upload.png'),
        ),
        if (pickedFiles != null)
          SizedBox(
            height:
                200, // Set a fixed height or use a dynamic height based on the number of items
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: pickedFiles!.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.file(pickedFiles![index], fit: BoxFit.cover),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            pickedFiles!.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAddProductButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : () => _addProduct(context),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2375D8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 5.5, horizontal: 142.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          textStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      child: const Text('Add Product'),
    );
  }

  Future<void> _addProduct(BuildContext context) async {
    if (!_validateFields(context)) return;

    setState(() {
      isLoading = true;
    });

    try {
      final imageUrls = await uploadFile();
      if (imageUrls.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload images')),
        );
        return;
      }

      final product = Product(
        owner: AuthService().user!.uid,
        name: nameController.text,
        description: descriptionController.text,
        category: categoryController.text,
        price: double.parse(priceController.text),
        time: timeController.text,
        deposit: double.parse(depositController.text),
        bankAccount: bankAccountController.text,
        pictures: imageUrls,
        location: _selectedLocation ?? LatLng(0, 0),
        disponibleFrom: _selectedDateRange!.start, // Add start date
        disponibleTo: _selectedDateRange!.end, // Add end date
      );

      await FirestoreService().addProductToUser(product);
      await FirestoreService().postProduct(product);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully')),
      );
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _validateFields(BuildContext context) {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        categoryController.text.isEmpty ||
        priceController.text.isEmpty ||
        depositController.text.isEmpty ||
        bankAccountController.text.isEmpty ||
        _selectedDateRange == null) {
      // Validate date range selection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return false;
    }

    try {
      double.parse(priceController.text);
      double.parse(depositController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter valid numbers for price and deposit')),
      );
      return false;
    }

    if (pickedFiles == null || pickedFiles!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return false;
    }

    return true;
  }

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

          await ref.putFile(file);
          final downloadUrl = await ref.getDownloadURL();
          urls.add(downloadUrl);
        } catch (e) {
          print('Error uploading file: $e');
        }
      }
    }
    return urls;
  }

  InputDecoration commonInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: InputBorder.none,
      filled: true,
      fillColor: Color(0xFFFFFFFF),
      labelStyle: const TextStyle(
        color: Color(0xff7F7F7F),
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: BorderSide.none,
      ),
    );
  }
}
