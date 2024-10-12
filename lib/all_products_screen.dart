import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_1/models/products.dart';
import 'package:flutter_riverpod_1/providers/products_future_provider.dart';

class AllProductsScreen extends ConsumerWidget {
  AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Products>> products =
        ref.watch(productsFutureProvider);
    final AsyncValue<List<dynamic>> categoryList =
        ref.watch(categoryListFutureProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart))
        ],
        title: Text('All Products'),
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          Container(
            height:30,
            child: categoryList.when(
                data: (data) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: Center(child: Text(data[index],style: TextStyle(
                            fontWeight: FontWeight.w500
                          ),)),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: data.length);
                },
                error: (error, _) {
                  return Text("No data");
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          Expanded(
            child: products.when(data: (data) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: data[index].images != null
                          ? Container(
                              child: Image.network(data[index].images?[0]))
                          : SizedBox(),
                      title: Text(data[index].title.toString()),
                      subtitle: Text(data[index].description.toString()),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: data.length);
            }, error: (error, stk) {
              return Center(
                child: Text('Error: $error'),
              );
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
