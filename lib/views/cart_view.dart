import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:machine_test7/controller/cart_controller.dart';
import 'package:provider/provider.dart';

class CartViewPage extends StatelessWidget {
  const CartViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final obj = Provider.of<CartController>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Carts"),
          centerTitle: true,
        ),
        body: obj.carts.isNotEmpty
            ? ListView.builder(
                itemCount: obj.carts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(obj.carts[index]['image']),
                    ),
                    title: Text(obj.carts[index]['name']),
                    trailing: IconButton(
                        onPressed: () {
                          obj.deleteItem(index: index);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  );
                },
              )
            : const Center(
                child: Text("Your cart is empty"),
              ));
  }
}
