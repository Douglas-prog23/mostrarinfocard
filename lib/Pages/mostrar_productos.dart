import 'package:cardsinform/Pages/compra.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class ProductsListScreen extends StatefulWidget {
  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No hay productos disponibles.'),
            );
          }
//mostrar los datos de la base de datos
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {

              final product = snapshot.data!.docs[index].data();

              return ProductCard(
              
                imageUrl: product['image_url'],
                name: product['name'],
                price: product['price'].toString(),
                stock: product['stock'].toString(),
                descripcion: product['descripcion'],
                productId: snapshot.data!.docs[index].id,
              );
              
              
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  
  final String imageUrl;
  final String name;
  final String price;
  final String stock;
   final String descripcion;
   final String productId;
   

  ProductCard({
   
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.stock, 
    required this.descripcion,
    required this.productId,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
     var stars=null;

   // Método para actualizar un producto
  Future<void> updateProduct(String productId, String newName, double newPrice, int newStock) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).update({
        'name': newName,
        'price': newPrice,
        'stock': newStock,
      });
      print('Producto actualizado con éxito');
    } catch (e) {
      print('Error al actualizar el producto: $e');
    }
  }

  //Metodo para borrar productos

   Future<void> _deleteProduct() async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(widget.productId).delete();
      print('Producto eliminado con éxito');
    } catch (e) {
      print('Error al eliminar el producto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Widget iconList;
    return SizedBox(
          width:double.infinity,
          child: Card( //Aqui empieza el widget card////////////////////////
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width:5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 50,
            borderOnForeground:EditableText.debugDeterministicCursor,
            color: Color.fromARGB(255, 238, 238, 238),
            margin: EdgeInsets.all(16.0),
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              //se muestra la imagen se le da un estilo
              children: <Widget>[
                  
                Container(
                  height: MediaQuery.of(context).size.height * .4,
                  width:MediaQuery.of(context).size.width * 1,
                  margin:EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(blurRadius: 10.0, color: Colors.grey[100]!, offset:
                      Offset(0, 7))
                      ],
                   
                      image: DecorationImage(
                        
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.centerRight,
                        image: NetworkImage(this.widget.imageUrl),

                        )
                        ),
                        ),

                        //hasta aqui las imagenes

              SizedBox(width: 20,),
              
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: <Widget>[
                    

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.name,
                        style: Theme.of(context).textTheme.headline5,
                        ),
                    ),
                      
                      SizedBox(height: 8.0),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Price : ${widget.price}',style:TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                      ),

                      SizedBox(height: 8.0),


                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Stock : ${widget.stock}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                      ),

                      SizedBox(
                        width:double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            softWrap: true,
                            
                            textAlign:TextAlign.justify,
                          widget.descripcion,
                          style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 121, 120, 120),
                            ),
                                              
                          ),
                        ),
                      ),

                     SizedBox(height: 8.0), 

                     //Aqui van los iconos de el card
                     // DefaultTextStyle.merge() te permite crear un estilo de texto por defecto
        // que es heredado por sus hijos y todos los hijos subsecuentes.
        iconList = DefaultTextStyle.merge(
          child: Container(
            padding: EdgeInsets.all(20),
            child:const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
          Column(
            children: [
              Icon(Icons.kitchen, color: Color.fromARGB(255, 0, 0, 0)),
              Text('PREP:'),
              Text('25 min'),
            ],
          ),
          SizedBox(width: 60,),
          Column(
            children: [
              Icon(Icons.timer, color: const Color.fromARGB(255, 0, 0, 0)),
              Text('COOK:'),
              Text('1 hr'),
            ],
          ),
          SizedBox(width: 60,),
          Column(
            children: [
              Icon(Icons.restaurant, color: const Color.fromARGB(255, 0, 0, 0)),
              Text('FEEDS:'),
              Text('4-6'),
            ],
          ),
              ],
            ),
          ),
        ),

//Aqui comienzan los iconos de las estrellas que estan en el card

         Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              stars = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.green[500]),
            Icon(Icons.star, color: Colors.green[500]),
            Icon(Icons.star, color: Colors.green[500]),
            Icon(Icons.star, color: Colors.black),
            Icon(Icons.star, color: Colors.black),
          ],
        ),
        SizedBox(width: 70,),
              Text(
          '170 Reviews',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontFamily: 'Roboto',
            letterSpacing: 0.5,
            fontSize: 20,
          ),
              ),
            ],
          ),
        ),

         //-----------------------------Botones del card---------------------------
        
        Row(children:[
          Container(
            margin: EdgeInsets.only(left: 50),
            width: MediaQuery.of(context).size.width/3,
            child: IconButton(
            iconSize: 80,
            
            icon:Icon(Icons.shopping_cart,color:Colors.redAccent),
            onPressed:(){
             PurchaseDialog().showPurchaseDialog(context, widget.productId);
            }),
          ),

           Row(children:[
          Container(
            margin: EdgeInsets.only(left: 50),
            width: MediaQuery.of(context).size.width/3,
            child: IconButton(
            iconSize: 80,
            
            icon:Icon(Icons.delete,color:Colors.redAccent),
            onPressed:(){
             //eliminar producto
              _deleteProduct();
            }),
          ),
          Padding(padding:EdgeInsets.symmetric(horizontal:20))
          ]),
          Padding(padding:EdgeInsets.symmetric(horizontal:20))
          ]),

          
         
        
                    ],
                      )
              ],
          
             ),
             
             
            
              
            ),//Has aqui termina el card
            );

  }
}



                                  


    

      