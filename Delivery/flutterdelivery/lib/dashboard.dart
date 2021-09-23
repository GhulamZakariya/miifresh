import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutterdelivery/app_data.dart';
import 'package:flutterdelivery/bloc/orders/orders_bloc.dart';
import 'package:flutterdelivery/models/order.dart';
import 'package:flutterdelivery/repositories/order_status_repo.dart';

import 'bloc/change_order_status/order_status_bloc.dart';
import 'order_details.dart';

class Dashboard extends StatefulWidget {
  final Function(Widget nextScreen) _nextToDetailPage;

  Dashboard(this._nextToDetailPage);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
   OrdersBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<OrdersBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (AppData.isOnline) bloc.add(GetOrders(AppData.user.password));
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: AppData.isOnline
          ? BlocConsumer<OrdersBloc, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoaded) {
                  print(state.ordersResponse.data);
                  updateData(state.ordersResponse.data);
                  return buildList(AppData.dashboardOrders);
                } else if(state is OrderError){
                  return not_Data(state.error);
                }
                else {
                  return buildLoading();
                }
              },
              listener: (context, state) {},
            )
          : Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Center(
                child: Text(
                  "Not Online",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              )),
    );
  }

  Widget buildCard(BuildContext context, Order order) {
    return Container(
      margin: EdgeInsets.all(2.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.customersName,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(
                        "Status:",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Text(
                          order.ordersStatus,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: " Call to Customer",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Placed On:",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Text(
                          order.datePurchased.split(" ")[0],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.black12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Order id"),
                    Text("#" + order.ordersId.toString()),
                  ],
                ),
                Container(
                  height: 60,
                  width: 1,
                  color: Colors.black12,
                ),
                Column(
                  children: [
                    Text("Amount"),
                    Text(order.currency + order.orderPrice),
                  ],
                ),
                Container(
                  height: 60,
                  width: 1,
                  color: Colors.black12,
                ),
                Column(
                  children: [
                    Text("Payment Type"),
                    Text(order.paymentMethod == "Cash on Delivery"
                        ? "COD"
                        : order.paymentMethod),
                  ],
                ),
              ],
            ),
            Container(
              height: 1,
              width: double.maxFinite,
              color: Colors.black12,
            ),
            Padding(
              padding: EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.place,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: order.customersStreetAddress,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.navigation,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  print("pressed//////////////////////////////////////////////");
                  widget._nextToDetailPage(BlocProvider(
                      create: (BuildContext context) =>
                          OrderStatusBloc(RealOrderStatusRepo()),
                      child: OrderDetails(order, false)));
                },
                child: Text("Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
   Widget not_Data(String message) {
     return Center(
       child: Text(message),
     );
   }

  Widget buildList(List<Order> orders) {
    if (orders.isEmpty)
      return Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: Center(
            child: Text(
              "Empty!",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
          ));
    return Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return buildCard(context, orders[index]);
          },
        ));
  }

  void updateData(List<Order> data) {
    AppData.dashboardOrders = [];
    AppData.historyOrders = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i].ordersStatusId == 2 || data[i].ordersStatusId == 3) {
        AppData.historyOrders.add(data[i]);
        print(AppData.historyOrders);
      } else {
        AppData.dashboardOrders.add(data[i]);
        print(AppData.dashboardOrders);
      }
    }
  }
}
