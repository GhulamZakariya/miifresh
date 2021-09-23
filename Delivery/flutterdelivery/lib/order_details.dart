import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterdelivery/app_data.dart';
import 'package:flutterdelivery/bloc/change_order_status/order_status_bloc.dart';
import 'package:flutterdelivery/models/order.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class OrderDetails extends StatefulWidget {
  Order order;
  bool isFromHistory = false;

  OrderDetails(this.order, this.isFromHistory);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderStatusBloc _orderStatusBloc;

  @override
  void initState() {
    super.initState();

    _orderStatusBloc = BlocProvider.of<OrderStatusBloc>(context);
    _orderStatusBloc.listen((state) {
      if (state is OrderStatusLoaded) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: Column(
                    children: [
                      buildOrderDetailsCard(),
                      buildBillingAddressCard(),
                      buildDeliveryAddressCard(),
                      buildShippingMethodCard(),
                      buildSubtotalCard(),
                      buildPaymentMethodCard(),
                      buildCustomerCommentCard(),
                      buildAdminCommentCard(),
                    ],
                  ),
                ),
              ),
            ),
            if (!widget.isFromHistory)
              if (widget.order.ordersStatusId == AppData.DISPATCHED)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Text("Order is Dispatched")),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    showAlertDialog(context, false);
                                  },
                                  child: Text("Cancel"))),
                          SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    showAlertDialog(context, true);
                                  },
                                  child: Text("Deliver")))
                        ],
                      ),
                    ],
                  ),
                ),
          ],
        ));
  }

  Widget buildOrderDetailsCard() {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Order Details:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "No. of Products",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.data.length.toString()),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Total Price",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.currency +
                    "" +
                    widget.order.orderPrice.toString()),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Order Status",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.ordersStatus),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Order Date",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.datePurchased.split(" ")[0]),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Order Time",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.datePurchased.split(" ")[1]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBillingAddressCard() {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.0, top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Billing Address:",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                InkWell(
                  child: Center(
                      child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.navigation,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: " Navigate",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  )),
                  onTap: () {
                    if(widget.order.deliveryLongitude != null && widget.order.deliveryLatitude != null)
                    MapsLauncher.launchCoordinates(
                        double.tryParse(widget.order.deliveryLatitude),
                        double.tryParse(widget.order.deliveryLongitude),
                        'Google Headquarters are here');
                  },
                ),
                SizedBox(
                  width: 5.0,
                ),
                InkWell(
                  child: Center(
                      child: Container(
                    padding: EdgeInsets.all(5.0),
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
                            text: " Contact",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  )),
                  onTap: () {
                    launch("tel://" + widget.order.billingPhone);
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Name",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(widget.order.billingName),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Company",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text("None"),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Phone",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(widget.order.billingPhone),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Email",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(widget.order.email),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Address",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.order.billingPostcode +
                            "\n" +
                            widget.order.billingCity +
                            "\n" +
                            widget.order.billingCountry +
                            "\n" +
                            widget.order.billingStreetAddress,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeliveryAddressCard() {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.0, top: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Shipping Address:",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                InkWell(
                  child: Center(
                      child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.navigation,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: " Navigate",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  )),
                  onTap: () {
                    if(widget.order.deliveryLongitude != null && widget.order.deliveryLatitude != null)
                    MapsLauncher.launchCoordinates(
                        double.tryParse(widget.order.deliveryLatitude),
                        double.tryParse(widget.order.deliveryLongitude),
                        'Google Headquarters are here');
                  },
                ),
                SizedBox(
                  width: 5.0,
                ),
                InkWell(
                  child: Center(
                      child: Container(
                    padding: EdgeInsets.all(5.0),
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
                            text: " Contact",
                            style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  )),
                  onTap: () {
                    launch("tel://" + widget.order.deliveryPhone);
                  },
                ),
                SizedBox(
                  width: 12.0,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Name",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(widget.order.deliveryName),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Company",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text("None"),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Phone",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(widget.order.deliveryPhone),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Email",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(widget.order.email),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "Address",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.order.deliveryPostcode +
                            "\n" +
                            widget.order.deliveryCity +
                            "\n" +
                            widget.order.deliveryCountry +
                            "\n" +
                            widget.order.deliveryStreetAddress,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildShippingMethodCard() {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Shipping Method:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.order.shippingMethod,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.currency + widget.order.shippingCost),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubtotalCard() {
    double temp_total = double.tryParse(widget.order.orderPrice);
    double temp_shipping = double.tryParse(widget.order.shippingCost);
    double temp_tax = double.tryParse(widget.order.totalTax);
    double temp_subtotal = temp_total - temp_tax - temp_shipping;

    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Subtotal:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Subtotal",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.currency + "" + temp_subtotal.toString()),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Tax",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.currency + "" + temp_tax.toString()),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Shipping",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.currency + "" + temp_shipping.toString()),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Discount",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text("\$0.00"),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Total",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Text(widget.order.currency + "" + widget.order.orderPrice),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodCard() {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Payment Method:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Cash on Delivert",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomerCommentCard() {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Customer Comment:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Detailed Comment",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdminCommentCard() {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Admin Comment:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Detailed Comment",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, bool isDeliver) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
        _orderStatusBloc.add(ChangeOrderStatus(
            widget.order.ordersId.toString(),
            isDeliver
                ? AppData.DELIVERED.toString()
                : AppData.CANCEL.toString(),
            "",
            AppData.user.password));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(isDeliver ? "Order Delivered?" : "Order Canceled?"),
      content: Text(isDeliver
          ? "Are you sure you want to make order delivered?"
          : "Are you sure you want to cancel the order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
