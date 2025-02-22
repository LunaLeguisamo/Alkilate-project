import 'package:alkilate/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:alkilate/services/services.dart';
import 'package:alkilate/views/login/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false; // Variable que indica si estamos en modo edición

  // Controladores de los campos de texto para almacenar los valores ingresados
  final TextEditingController _nameController =
      TextEditingController(text: 'New name');
  final TextEditingController _emailController =
      TextEditingController(text: 'newmail@example.com');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(
                message: 'Failed to load user data: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder<User>(
            future: FirestoreService().getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: ErrorMessage(message: snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                var user = snapshot.data!;
                return profileBuilder(user);
              } else {
                return const Text('No user found in Firestore. Check database');
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  Widget profileBuilder(user) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(children: [
              Hero(
                tag: 'profile',
                child: Image.asset(
                  'assets/images/profile-banner.png',
                  height: 126,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(31.5, 71, 0, 0),
                child: CircleAvatar(
                  radius: 48.5,
                  backgroundImage:
                      NetworkImage(user.photoURL), // Foto de perfil
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(31.5),
              child: Column(
                children: [
                  Wrap(
                    children: [
                      Text(
                        'Hello, ',
                        style: TextStyle(
                          fontSize: 39,
                          color: Color(0xFF7F7F7F),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '${user.name}',
                        style: TextStyle(
                          fontSize: 47,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Tres botones con imágenes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton('assets/images/My-listing.png', 'My Listing',
                    '/user-products'),
                _buildIconButton(
                    'assets/images/My-orders.png', 'My orders', '/user-orders'),
              ],
            ),
            // Botón "Actualizar Datos"
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing; // Cambia el estado de edición
                });
              },
              child: Text(_isEditing ? 'Cancelar' : 'Change Data'),
            ),
            SizedBox(height: 10),

            // Solo mostrar los campos de texto si estamos en modo de edición
            if (_isEditing) ...[
              AppFormField(
                controller: _nameController,
                label: 'Name',
                hint: 'Enter your name',
                enabled: _isEditing,
              ),
              SizedBox(height: 10),
              AppFormField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                enabled: _isEditing,
              ),
            ],

            // Botón para guardar cambios (solo visible si estamos editando)
            if (_isEditing) ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Lógica para guardar cambios, aquí podrías guardar la info
                  print('Name: ${_nameController.text}');
                  print('Email: ${_emailController.text}');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Save Changes'),
              ),
            ],
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget para crear un botón con imagen
  Widget _buildIconButton(String imagePath, String label, String route) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color.fromARGB(255, 137, 191, 235),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 50,
                height: 50,
              ),
              SizedBox(height: 5),
              Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}

class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.enabled,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
    );
  }
}
