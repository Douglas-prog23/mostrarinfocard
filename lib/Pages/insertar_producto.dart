import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddProductScreen(),
    );
  }
}

class AddProductScreen extends StatefulWidget {
  String? id;

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _selectedImage = null;
  String _productName = '';
  String _productDescripcion = '';
  double _productPrice = 0.0;
  int _productStock = 0;

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadProduct() async {
    if (_productName.isEmpty || _productDescripcion.isEmpty || _productPrice <= 0 || _productStock < 0 || _selectedImage == null) {
      print('Por favor, completa todos los campos y selecciona una imagen.');
      return;
    }

    final storage = FirebaseStorage.instance;
    final Reference storageReference = storage.ref().child('product_images/${DateTime.now()}.jpg');

    try {
      await storageReference.putFile(_selectedImage!);
      final imageUrl = await storageReference.getDownloadURL();

      final productData = {
        'name': _productName,
        'price': _productPrice,
        'stock': _productStock,
        'descripcion': _productDescripcion,
        'image_url': imageUrl,
      };

      await FirebaseFirestore.instance.collection('products').add(productData);

      print('Producto guardado con éxito en Firestore.');

      // Restablece los campos después de guardar el producto.
      setState(() {
        _selectedImage = null;
        _productName = '';
        _productDescripcion = '';
        _productPrice = 0.0;
        _productStock = 0;
      });
    } catch (e) {
      print('Error al subir el producto: $e');
    }
  }

//codigo para agregar un producto a la base de datos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            
             _selectedImage != null
           ? Image.file(
                    _selectedImage!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                  height: 400,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                    ),
                    
                ),
           
           
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Seleccionar una imagen'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Nombre del Producto'),
              onChanged: (value) {
                setState(() {
                  _productName = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _productPrice = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _productStock = int.tryParse(value) ?? 0;
                });
              },
            ),
             TextField(
              decoration: InputDecoration(labelText: 'Descripcion del Producto'),
              onChanged: (value) {
                setState(() {
                  _productDescripcion = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadProduct,
              child: Text('Guardar Producto'),
            ),
          ],
        ),
      ),
    );
  }
}
