import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:machine_test7/models/cat_models.dart';
import 'package:machine_test7/views/view_items_page.dart';

class CatagoriesPage extends StatelessWidget {
  const CatagoriesPage({super.key});

  Future<Catagories> getData() async {
    Response res = await get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php"));

    if (res.statusCode == 200) {
      var body = Catagories.fromJson(jsonDecode(res.body));
      return body;
    } else {
      return throw Exception("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        title: const Text("Catagories"),
        centerTitle: true,
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
              itemCount: snapshot.data!.categories!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.categories![index];

                return Card(
                  surfaceTintColor: Colors.white,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ViewItemsPage(catName: data.strCategory!);
                        },
                      ));
                    },
                    leading: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(data.strCategoryThumb!)),
                    title: Text(data.strCategory!),
                  ),
                );
              },
            );
          } else {
            return const Text("error");
          }
        },
      ),
    );
  }
}
