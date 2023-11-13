import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PurchaseOperations {
  // Método para realizar la compra de un producto
  // metodo compra producto
  Future<String> purchaseProduct(String productId, int quantity) async {
    try {
      final productRef = FirebaseFirestore.instance.collection('products').doc(productId);

      final productDoc = await productRef.get();
      
      if (productDoc.exists) {
        final currentStock = productDoc.data()?['stock'];

        if (currentStock >= quantity) {
          final newStock = currentStock - quantity;
          await productRef.update({'stock': newStock});

          print('Compra realizada con éxito. Nuevo stock: $newStock');
        } else {
         print('No hay suficiente stock de este producto');
          return "no";
        }
      } else {
        print('El producto no existe');
      }
    } catch (e) {
      print('Error al realizar la compra: $e');
    }
    return "ok";
  }

//metodo para eliminar un producto de la base de datos

FirebaseFirestore db = FirebaseFirestore.instance;
Future<void> deleteproduct(String id) async{
  await db.collection('products').doc(id).delete();

}

}
