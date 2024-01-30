import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:machine_test7/models/view_models.dart';
import 'package:machine_test7/views/cart_view.dart';
import 'package:provider/provider.dart';

import '../controller/cart_controller.dart';

class ViewItemsPage extends StatelessWidget {
  const ViewItemsPage({super.key, required this.catName});

  final String catName;

  Future<ViewPageModel> getData() async {
    Response res = await get(Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$catName"));

    if (res.statusCode == 200) {
      var body = ViewPageModel.fromJson(jsonDecode(res.body));
      return body;
    } else {
      return throw Exception("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        title: Text(catName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const CartViewPage();
                  },
                ));
              },
              icon: const Icon(Icons.shop)),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.meals!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.meals![index];
                return Card(
                    surfaceTintColor: Colors.white,
                    child: ListTile(
                        leading: Image(
                          image: CachedNetworkImageProvider(data.strMealThumb!),
                        ),
                        title: Text(data.strMeal!),
                        trailing: Consumer<CartController>(
                          builder: (context, value, child) {
                            return IconButton(
                                onPressed: () {
                                  value.addList(value: {
                                    "image": data.strMealThumb,
                                    "name": data.strMeal
                                  });
                                },
                                icon: const Icon(Icons.add));
                          },
                        )));
              },
            );
          } else {
            return const Text("no data found");
          }
        },
      ),
    );
  }
}
