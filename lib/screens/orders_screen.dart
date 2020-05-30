import 'package:flutter/material.dart';
import 'package:learn_shop_app_4/providers/orders.dart' show Orders;
import 'package:learn_shop_app_4/widgets/app_drawer.dart';
import 'package:learn_shop_app_4/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (data.error != null) {
                return Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('An error occured'),
                      RaisedButton(
                        onPressed: () {
                          Provider.of<Orders>(context, listen: false)
                              .fetchAndSetOrders();
                        },
                        child: Text('Reload'),
                      )
                    ],
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<Orders>(context, listen: false)
                        .fetchAndSetOrders();
                  },
                  child: Consumer<Orders>(
                    builder: (ctx, orderData, _) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (_, i) => OrderItem(orderData.orders[i]),
                    ),
                  ),
                );
              }
            }
          }),
    );
  }
}
