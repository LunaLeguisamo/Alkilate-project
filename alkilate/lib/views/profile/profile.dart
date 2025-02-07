import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false; // Variable que indica si estamos en modo edición

  // Controladores de los campos de texto para almacenar los valores ingresados
  final TextEditingController _nameController = TextEditingController(text: 'New name');
  final TextEditingController _emailController = TextEditingController(text: 'newmail@example.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 137, 191, 235),
        title: Text('Profile'),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage('assets/images/image3.png'), // Foto de perfil
            radius: 20,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Fila con la foto de perfil a la izquierda y el nombre centrado
            Row(
              children: [
                // Foto de perfil a la izquierda
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('assets/images/image3.png'), // Foto de perfil
                ),
                SizedBox(width: 20),
                
                // Nombre centrado
                Expanded(
                  child: Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Correo electrónico
            Text(
              'mymail@gmail.com',
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 37, 136, 216)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

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

            // Tres botones con imágenes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton('assets/images/image3.png', 'My Listing'),
                _buildIconButton('assets/images/image2.png', 'Pending'),
                _buildIconButton('assets/images/image1.png', 'My orders'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget para crear un botón con imagen
  Widget _buildIconButton(String imagePath, String label) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Acción cuando el botón es presionado
            print('$label pressed');
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
                imagePath, // Asegúrate de tener las imágenes en la carpeta assets
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
