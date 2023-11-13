import 'package:cardsinform/Pages/Crud.dart';
import 'package:flutter/material.dart';
import 'package:cardsinform/Pages/Crud.dart';


class PurchaseDialog {
  void showPurchaseDialog(BuildContext context, String productId) {
    int quantity = 1;

    
  //Dialogo para realizar la compra de un producto
  //aparee un dialogo para agregar un numero de compra

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Cantidad a Comprar'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Cantidad: $quantity'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Comprar'),
                  onPressed: () {
                    PurchaseOperations().purchaseProduct(productId, quantity);
                    Navigator.of(context).pop();
                    
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

//hasta aqui



  void purchaseProduct(BuildContext context, String productId, int quantity) {
    PurchaseOperations().purchaseProduct(productId, quantity).then((result) {
      if (result == 'ok') {
        // Mostrar un mensaje si no hay stock disponible
        showSnackBar(context, '¡Producto sin stock disponible!');
      } else {
        Navigator.of(context).pop(); // Cerrar el diálogo si la compra se realizó con éxito
      }
    });
  }

  Future<String> showSnackBar(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    return "ok"; // Podría devolver un valor para su uso si es necesario
  }
}