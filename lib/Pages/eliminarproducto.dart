import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//metodo para eliminar un producto de la base de datos

Future<void> deleteproduct(String id) async{
  await db.collection('products').doc(id).delete();

}

