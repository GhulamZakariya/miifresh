import 'dart:ui';

import 'package:braintree_payment/braintree_payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/app_data.dart';
import 'package:flutter_app1/src/api/api_provider.dart';
import 'package:flutter_app1/src/api/responses/att_to_order_response.dart';
import 'package:flutter_app1/src/blocs/checkout/checkout_bloc.dart';
import 'package:flutter_app1/src/blocs/checkout/checkout_event.dart';
import 'package:flutter_app1/src/blocs/checkout/checkout_state.dart';
import 'package:flutter_app1/src/blocs/add_to_order/order_bloc.dart';
import 'package:flutter_app1/src/blocs/add_to_order/order_event.dart';
import 'package:flutter_app1/src/blocs/add_to_order/order_state.dart';
import 'package:flutter_app1/src/models/address/address.dart';
import 'package:flutter_app1/src/models/cart_entry.dart';
import 'package:flutter_app1/src/models/checkout/post_order.dart';
import 'package:flutter_app1/src/models/checkout/post_product.dart';
import 'package:flutter_app1/src/models/checkout/post_product_attribute.dart';
import 'package:flutter_app1/src/models/payment_methods/payment_method.dart';
import 'package:flutter_app1/src/models/product_models/product.dart';
import 'package:flutter_app1/src/models/product_models/product_attributes.dart';
import 'package:flutter_app1/src/models/shipping_methods/shipping_service.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter_app1/src/ui/screens/thankyou_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:hive/hive.dart';

class Checkout extends StatefulWidget {
  List<CartEntry> cartEntries;
  List<Product> cartProducts;
  Address shippingAddress;
  Address billingAddress;
  String shippingTax;
  ShippingService shippingService;

  Checkout(this.cartEntries, this.cartProducts, this.shippingAddress,
      this.billingAddress, this.shippingTax, this.shippingService);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  PaymentMethodObj selectedPaymentMethod = PaymentMethodObj();

  OrderBloc orderBloc;

  double subtotalPrice = 0.0;
  double discountPrice = 0.0;
  double totalPrice = 0.0;

  Box _box;

  String paymentMethodNonce = "";
  String brainTreeTokenizationKeys = "";

  @override
  void initState() {
    super.initState();
    // ignore: close_sinks
    final checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    checkoutBloc.add(GetPaymentMethods());
    orderBloc = BlocProvider.of<OrderBloc>(context);
    _box = Hive.box("my_cartBox");
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    buildProductsList(widget.cartProducts, widget.cartEntries),
                    buildBillingAddressCard(widget.billingAddress),
                    buildShippingAddressCard(widget.shippingAddress),
                    buildShippingMethodCard(widget.shippingService),
                    buildPaymentMethodsCard(),
                    buildPriceList(),
                    BlocConsumer<OrderBloc, OrderState>(
                      builder: (BuildContext context, state) {
                        return Container();
                      },
                      listener: (BuildContext context, state) {
                        if (state is PlaceOrderInitial) {
                        } else if (state is PlaceOrderLoading) {
                          showLoaderDialog(context);
                        } else if (state is PlaceOrderLoaded) {
                          AddToOrderResponse addToOrderResponse =
                              state.addToOrderResponse;
                          if (addToOrderResponse.success == "1") {
                            for (int i = widget.cartEntries.length;
                                i > 0;
                                i--) {
                              _box.deleteAt(i - 1);
                            }
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ThankYou()));
                          } else {
                            if (addToOrderResponse.products_id != null) {
                              Navigator.pop(context);
                              int count = 0;
                              Navigator.popUntil(context, (route) {
                                return count++ == 3;
                              });
                              Navigator.pop(
                                  context, addToOrderResponse.message);
                            }
                          }
                        } else if (state is PlaceOrderError) {
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                    child: FlatButton(
                        color: Colors.red[800],
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          int count = 0;
                          Navigator.popUntil(context, (route) {
                            return count++ == 4;
                          });
                        })),
                Expanded(
                    child: FlatButton(
                        color: (selectedPaymentMethod.name != null)
                            ? Colors.green[800]
                            : Colors.grey,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          print("pressed///////////////////////////////////////////////////////");
                          if (selectedPaymentMethod.name != null){
                            placeOrderNow()

                            ;}else{
                            var snackBar = SnackBar(content: Text('Select payment method'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        child: Text(
                          "Place Order",
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBillingAddressCard(Address billingAddress) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Billing Address:"),
            SizedBox(
              height: 8.0,
            ),
            Text(
              billingAddress.deliveryFirstName +
                  " " +
                  billingAddress.deliveryLastName,
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              billingAddress.deliveryStreetAddress +
                  ", " +
                  billingAddress.deliveryCity,
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              billingAddress.deliveryPhone,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShippingAddressCard(Address shippingAddress) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Shipping Address:"),
            SizedBox(
              height: 8.0,
            ),
            Text(
              shippingAddress.deliveryFirstName +
                  " " +
                  shippingAddress.deliveryLastName,
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              shippingAddress.deliveryStreetAddress +
                  ", " +
                  shippingAddress.deliveryCity,
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              shippingAddress.deliveryPhone,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShippingMethodCard(ShippingService shippingService) {
    return Card(
      margin: EdgeInsets.all(4.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Shipping Method:"),
            SizedBox(
              height: 8.0,
            ),
            Text(
              shippingService.shippingMethod,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodsCard() {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, state) {
        if (state is PaymentMethodsInitial) {
          return buildLoading();
        } else if (state is PaymentMethodsLoading) {
          return buildLoading();
        } else if (state is PaymentMethodsLoaded) {
          _setupPaymentMethods(
              _getFilteredPaymentMethods(state.paymentMethodsResponse.data));
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: RadioListBuilder(
                        _getFilteredPaymentMethods(
                            state.paymentMethodsResponse.data),
                        _onPaymentMethodSelected),
                  );
                },
              );
            },
            child: Card(
              margin: EdgeInsets.all(4.0),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("PaymentMethods"),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            selectedPaymentMethod.name == null
                                ? "Select payment method"
                                : selectedPaymentMethod.name,
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          );
        } else if (state is PaymentMethodsError) {
          return buildLoading();
        } else {
          return buildLoading();
        }
      },
    );
  }

  Widget buildProductsList(List<Product> products, List list) {
    subtotalPrice = 0.0;
    discountPrice = 0.0;
    totalPrice = 0.0;

    for (int i = 0; i < products.length; i++) {
      Product product = products[i];
      CartEntry cartEntry = list[i];
      int isDiscount =
          _calculateDiscount(product.productsPrice, product.discountPrice);

      List<ProductAttribute> cartProductAttributes =
          new List<ProductAttribute>();
      json.decode(cartEntry.attributes).forEach((v) {
        cartProductAttributes.add(new ProductAttribute.fromJson(v));
      });

      if (products[i].productsId != null) {
        double attrsPrice = 0.0;
        cartProductAttributes.forEach((element) {
          attrsPrice += double.parse(element.values[0].price.toString());
        });
        subtotalPrice +=
            ((double.parse(product.productsPrice.toString()) + attrsPrice) *
                cartEntry.quantity);
        if (isDiscount != null && isDiscount != 0) {
          discountPrice += (double.parse(product.productsPrice.toString()) -
                  double.parse(product.discountPrice.toString())) *
              cartEntry.quantity;
        }
        totalPrice += (((isDiscount != null && isDiscount != 0)
                ? double.parse(product.discountPrice.toString())
                : double.parse(product.productsPrice.toString()) + attrsPrice) *
            cartEntry.quantity);
      }
    }

    totalPrice += (double.parse(widget.shippingTax) +
        double.parse(widget.shippingService.rate.toString()));

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        CartEntry cartEntry = list[index];
        Product product = products[index];
        if (product.productsId == null) return Container();
        int discount =
            _calculateDiscount(product.productsPrice, product.discountPrice);

        List<ProductAttribute> cartProductAttributes =
            new List<ProductAttribute>();
        json.decode(cartEntry.attributes).forEach((v) {
          cartProductAttributes.add(new ProductAttribute.fromJson(v));
        });

        double attrsPrice = 0.0;
        cartProductAttributes.forEach((element) {
          attrsPrice += double.parse(element.values[0].price.toString());
        });

        return Card(
          margin: EdgeInsets.all(4),
          child: Row(children: [
            Container(
              width: 120,
              height: 120,
              child: CachedNetworkImage(
                imageUrl: ApiProvider.imageBaseUrl + product.productsImage,
                fit: BoxFit.contain,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.productsName),
                            if (product.categories.length > 0)
                              Text(
                                product.categories[0].categoriesName,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                          ]),
                      Divider(
                        color: Colors.grey,
                      ),
                      Row(children: [
                        Expanded(
                            child: Text(
                          "Price",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        )),
                        (discount != null && discount != 0)
                            ? Row(
                                children: [
                                  Text(
                                    "\$" +
                                        double.parse(product.productsPrice
                                                .toString())
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  SizedBox(width: 4),
                                  Text("\$" +
                                      double.parse(
                                              product.discountPrice.toString())
                                          .toStringAsFixed(2)),
                                ],
                              )
                            : Text("\$" +
                                double.parse(product.productsPrice.toString())
                                    .toStringAsFixed(2)),
                      ]),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartProductAttributes.length,
                        itemBuilder: (context, index) {
                          return Row(children: [
                            Expanded(
                                child: Text(
                              cartProductAttributes[index].option.name,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            )),
                            Text(
                              cartProductAttributes[index].values[0].value,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(cartProductAttributes[index]
                                    .values[0]
                                    .pricePrefix +
                                "\$" +
                                double.parse(cartProductAttributes[index]
                                        .values[0]
                                        .price
                                        .toString())
                                    .toStringAsFixed(2)),
                          ]);
                        },
                      ),
                      Row(children: [
                        Expanded(
                            child: Text(
                          "Quantity",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        )),
                        Text("x " + product.customerBasketQuantity.toString()),
                      ]),
                      Divider(
                        color: Colors.grey,
                      ),
                      Row(children: [
                        Expanded(
                            child: Text(
                          "Total Price",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        )),
                        (discount != null && discount != 0)
                            ? Row(
                                children: [
                                  Text(
                                    "\$" +
                                        ((double.parse(product.productsPrice
                                                        .toString()) +
                                                    attrsPrice) *
                                                cartEntry.quantity)
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "\$" +
                                        ((double.parse(product.discountPrice
                                                        .toString()) +
                                                    attrsPrice) *
                                                cartEntry.quantity)
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ],
                              )
                            : Text(
                                "\$" +
                                    ((double.parse(product.productsPrice
                                                    .toString()) +
                                                attrsPrice) *
                                            cartEntry.quantity)
                                        .toStringAsFixed(2),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                      ])
                    ]),
              ),
            )
          ]),
        );
      },
    );
  }

  void _onPaymentMethodSelected(PaymentMethodObj paymentMethod) {
    setState(() {
      this.selectedPaymentMethod = paymentMethod;
    });

    if (selectedPaymentMethod.method == "braintree_card") {
      brainTreeTokenizationKeys = selectedPaymentMethod.publicKey;
      payWithBraintree();
    }
    if (selectedPaymentMethod.method == "stripe") {
      FullScreenDialog _myDialog = new FullScreenDialog(_onStripeDetailsAdded);
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => _myDialog,
            fullscreenDialog: true,
          ));
    }
  }

  void payWithBraintree() async {
    BraintreePayment braintreePayment = new BraintreePayment();
    var data = await braintreePayment.showDropIn(
        nonce: brainTreeTokenizationKeys, amount: "2.0", enableGooglePay: true, nameRequired:true, googleMerchantId: "955xt546rmxhn7zs", inSandbox: true);
    print("Response of the payment $data['paymentNonce']");
    paymentMethodNonce = data['paymentNonce'];
    placeOrderNow();
  }


  void _onStripeDetailsAdded(
      String cardNumber, String cardExpiryMonth, String cardExpiryYear) {
    final CreditCard testCard = CreditCard(
      number: cardNumber,
      expMonth: int.tryParse(cardExpiryMonth),
      expYear: int.tryParse(cardExpiryYear),
    );

    StripePayment.createTokenWithCard(
      testCard,
    ).then((token) {
      print('Received ${token.tokenId}');
      paymentMethodNonce = token.tokenId;
      placeOrderNow();
      //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
    }).catchError(setError);
  }

  void _showStripeCardDialog(PaymentMethodObj stripe) {
    AlertDialog alert = AlertDialog(
      content: new Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Card Number',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(8.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(8.0),
                borderSide: new BorderSide(),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Expiry Date',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(8.0),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(8.0),
                borderSide: new BorderSide(),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          FlatButton(onPressed: () {}, child: Text("Submit"))
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void setError(dynamic error) {
    print(error.toString());
  }

  void placeOrderNow() {
    PostOrder postOrder = PostOrder();
    print("AppData.user////////////////////////////////////////////////////////");
    print(AppData.user);
    //postOrder.guest_status = "1";
    postOrder.customers_id = AppData.user.id.toString();
    postOrder.customers_name =
        AppData.user.firstName + " " + AppData.user.lastName;
    postOrder.customers_telephone = AppData.user.phone;
    postOrder.email = AppData.user.email;
    print("widget.shippingAddress////////////////////////////////////////////////////////");
    print(widget.shippingAddress);
    postOrder.delivery_firstname = widget.shippingAddress.deliveryFirstName;
    postOrder.delivery_lastname = widget.shippingAddress.deliveryLastName;
    postOrder.delivery_street_address =
        widget.shippingAddress.deliveryStreetAddress;
    postOrder.delivery_postcode = widget.shippingAddress.deliveryPostCode;
    postOrder.delivery_phone = widget.shippingAddress.deliveryPhone;
    postOrder.delivery_suburb = "";
    postOrder.delivery_city = widget.shippingAddress.deliveryCity;
    postOrder.delivery_zone = widget.shippingAddress.deliveryZone.zoneName;
    postOrder.delivery_state = widget.shippingAddress.deliveryZone.zoneName;
    postOrder.delivery_country =
        widget.shippingAddress.deliveryCountry.countriesName;
    postOrder.delivery_country_id =
        widget.shippingAddress.deliveryCountry.countriesId.toString();
    postOrder.delivery_zone_id =
        widget.shippingAddress.deliveryZone.zoneId.toString();
    postOrder.delivery_time = "";
    postOrder.delivery_cost = widget.shippingService.rate.toString();
    postOrder.packing_charge_tax = "0.0";

    postOrder.latitude = "";
    postOrder.longitude = "";
    print("widget.billingAddress////////////////////////////////////////////////////////");
    print(widget.billingAddress);
    postOrder.billing_firstname = widget.billingAddress.deliveryFirstName;
    postOrder.billing_lastname = widget.billingAddress.deliveryLastName;
    postOrder.billing_street_address =
        widget.billingAddress.deliveryStreetAddress;
    postOrder.billing_postcode = widget.billingAddress.deliveryPostCode;
    postOrder.billing_phone = widget.billingAddress.deliveryPhone;
    postOrder.billing_suburb = "";
    postOrder.billing_city = widget.billingAddress.deliveryCity;
    postOrder.billing_zone = widget.billingAddress.deliveryZone.zoneName;
    postOrder.billing_state = widget.billingAddress.deliveryZone.zoneName;
    postOrder.billing_country =
        widget.billingAddress.deliveryCountry.countriesName;
    postOrder.billing_country_id =
        widget.billingAddress.deliveryCountry.countriesId.toString();
    postOrder.billing_zone_id =
        widget.billingAddress.deliveryZone.zoneId.toString();

    postOrder.language_id = "1";
    postOrder.tax_zone_id =
        widget.shippingAddress.deliveryZone.zoneId.toString();
    postOrder.total_tax = widget.shippingTax;
    postOrder.shipping_cost = widget.shippingService.rate;
    postOrder.shipping_method = widget.shippingService.shippingMethod;

    postOrder.comments = "";

    postOrder.is_coupon_applied = "0";
    postOrder.coupon_amount = "";
    //postOrder.coupons = "";

    postOrder.nonce = paymentMethodNonce;
    postOrder.payment_method = selectedPaymentMethod.paymentMethod;

    postOrder.productsTotal = subtotalPrice;
    postOrder.totalPrice = totalPrice;
    postOrder.products =
        getPostProductList(widget.cartProducts, widget.cartEntries);

    postOrder.transaction_id = "";

    postOrder.currency_code = "USD";
    print("postOrder////////////////////////////////////////////////////////");
    print(postOrder);
    orderBloc.add(PlaceOrder(postOrder));

  }

  List<PostProduct> getPostProductList(
      List<Product> cartProducts, List<CartEntry> cartEntries) {
    List<PostProduct> postProducts = new List<PostProduct>();

    for (int i = 0; i < cartProducts.length; i++) {
      PostProduct postProduct = PostProduct();

      CartEntry tempCartEntry = cartEntries[i];
      Product tempCartProduct = cartProducts[i];

      int discount = _calculateDiscount(
          tempCartProduct.productsPrice, tempCartProduct.discountPrice);

      List<ProductAttribute> cartProductAttributes =
          new List<ProductAttribute>();
      json.decode(tempCartEntry.attributes).forEach((v) {
        cartProductAttributes.add(new ProductAttribute.fromJson(v));
      });

      double attrsPrice = 0.0;
      cartProductAttributes.forEach((element) {
        attrsPrice += double.parse(element.values[0].price.toString());
      });

      postProduct.products_id = tempCartProduct.productsId.toString();
      postProduct.products_name = tempCartProduct.productsName;
      postProduct.model = tempCartProduct.productsModel;
      postProduct.image = tempCartProduct.productsImage;
      postProduct.weight = tempCartProduct.productsWeight;
      postProduct.unit = tempCartProduct.productsWeightUnit;
      postProduct.manufacture = tempCartProduct.manufacturerName;
      postProduct.categories = tempCartProduct.categories;
      postProduct.price = (discount != null && discount != 0)
          ? tempCartProduct.discountPrice
          : tempCartProduct.productsPrice;
      postProduct.final_price =
          ((double.parse(postProduct.price.toString()) + attrsPrice));
      postProduct.subtotal =
          ((double.parse(tempCartProduct.productsPrice.toString()) +
                  attrsPrice) *
              tempCartEntry.quantity);
      postProduct.total = (double.parse(postProduct.final_price.toString()) *
          tempCartEntry.quantity);
      postProduct.customers_basket_quantity = tempCartEntry.quantity.toString();

      postProduct.on_sale = (discount != null && discount != 0);

      postProduct.attributes =
          getPostProductAttributes(tempCartEntry.attributes);
      postProducts.add(postProduct);
    }
    return postProducts;
  }

  List<PostProductAttribute> getPostProductAttributes(String attributes) {
    List<PostProductAttribute> postProductAttributes =
        List<PostProductAttribute>();

    if (attributes != null) {
      List<ProductAttribute> cartProductAttributes =
          new List<ProductAttribute>();
      json.decode(attributes).forEach((v) {
        cartProductAttributes.add(new ProductAttribute.fromJson(v));
      });
      cartProductAttributes.forEach((v) {
        PostProductAttribute tempAttr = new PostProductAttribute();
        tempAttr.attribute_id = v.values[0].productsAttributesId.toString();
        tempAttr.products_options_id = v.option.id.toString();
        tempAttr.products_options = v.option.name;
        tempAttr.products_options_values_id = v.values[0].id.toString();
        tempAttr.products_options_values = v.values[0].value;
        tempAttr.options_values_price = v.values[0].price;
        tempAttr.price_prefix = v.values[0].pricePrefix;
        tempAttr.name = v.values[0].value +
            " " +
            v.values[0].pricePrefix +
            v.values[0].price.toString();
        postProductAttributes.add(tempAttr);
      });
    }
    return postProductAttributes;
  }

  Widget buildPriceList() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Text("Subtotal"),
            Expanded(child: SizedBox()),
            Text("\$" + subtotalPrice.toStringAsFixed(2)),
          ]),
          SizedBox(
            height: 4,
          ),
          Row(children: [
            Text("Discount"),
            Expanded(child: SizedBox()),
            Text("\$" + discountPrice.toStringAsFixed(2)),
          ]),
          SizedBox(
            height: 4,
          ),
          Row(children: [
            Text("Tax"),
            Expanded(child: SizedBox()),
            Text("\$" + double.parse(widget.shippingTax).toStringAsFixed(2)),
          ]),
          SizedBox(
            height: 4,
          ),
          Row(children: [
            Text("Packing Changes"),
            Expanded(child: SizedBox()),
            Text("\$0.00"),
          ]),
          SizedBox(
            height: 4,
          ),
          Row(children: [
            Text("Shipping Charges"),
            Expanded(child: SizedBox()),
            Text("\$" +
                double.parse(widget.shippingService.rate.toString())
                    .toStringAsFixed(2)),
          ]),
          SizedBox(
            height: 4,
          ),
          Row(children: [
            Text("Total"),
            Expanded(child: SizedBox()),
            Text(
              "\$" + totalPrice.toStringAsFixed(2),
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor),
            ),
          ]),
        ],
      ),
    );
  }

  void _setupPaymentMethods(List<PaymentMethodObj> paymentMethods) {
    for (int i = 0; i < paymentMethods.length; i++) {
      if (paymentMethods[i].method == "braintree_card") {
        brainTreeTokenizationKeys = selectedPaymentMethod.publicKey;
      }
      if (paymentMethods[i].method == "stripe") {
        StripePayment.setOptions(
            StripeOptions(publishableKey: paymentMethods[i].publicKey));
      }
    }
  }

  List<PaymentMethodObj> _getFilteredPaymentMethods(
      List<PaymentMethodObj> data) {
    List<PaymentMethodObj> filteredPaymentMethods = List<PaymentMethodObj>();

    for (int i = 0; i < data.length; i++) {
      if (data[i].method == "braintree_card" ||
          data[i].method == "stripe" ||
          data[i].method == "cod") {
        filteredPaymentMethods.add(data[i]);
      }
    }

    return filteredPaymentMethods;
  }
}

Widget buildLoading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

int _calculateDiscount(productsPrice, discountPrice) {
  if (discountPrice == null) discountPrice = productsPrice;
  double discount = (productsPrice - discountPrice) / productsPrice * 100;
  return num.parse(discount.toStringAsFixed(0));
}

class RadioListBuilder extends StatefulWidget {
  final List<PaymentMethodObj> paymentMethods;
  final void Function(PaymentMethodObj paymentMethod) onPaymentMethodSelected;

  const RadioListBuilder(this.paymentMethods, this.onPaymentMethodSelected);

  @override
  RadioListBuilderState createState() {
    return RadioListBuilderState();
  }
}

class RadioListBuilderState extends State<RadioListBuilder> {
  int value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return RadioListTile(
          value: index,
          groupValue: value,
          onChanged: (ind) => setState(() {
            value = ind;
            Navigator.pop(context);
            widget.onPaymentMethodSelected(widget.paymentMethods[index]);
          }),
          title: Text(widget.paymentMethods[index].name),
        );
      },
      itemCount: widget.paymentMethods.length,
    );
  }
}

class FullScreenDialog extends StatefulWidget {
  String _stripeCardNumber = "";
  String _stripeExpiryMonth = "";
  String _stripeExpiryYear = "";

  Function(String cardNumber, String cardExpiryMonth, String cardExpiryYear)
      _onStripeDetailsAdded;

  FullScreenDialog(this._onStripeDetailsAdded);

  @override
  FullScreenDialogState createState() => new FullScreenDialogState();
}

class FullScreenDialogState extends State<FullScreenDialog> {
  TextEditingController _cardNumberController = new TextEditingController();
  TextEditingController _cardExpiryMonthController =
      new TextEditingController();

  TextEditingController _cardExpiryYearController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Stripe Card."),
        ),
        body: new Padding(
          child: new ListView(
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              new TextField(
                controller: _cardNumberController,
                maxLength: 16,
                decoration:
                    new InputDecoration.collapsed(hintText: 'Card Number'),
              ),
              SizedBox(
                height: 16.0,
              ),
              new TextField(
                decoration:
                    new InputDecoration.collapsed(hintText: 'Expiry Month'),
                maxLength: 2,
                controller: _cardExpiryMonthController,
              ),
              SizedBox(
                height: 16.0,
              ),
              new TextField(
                decoration:
                    new InputDecoration.collapsed(hintText: 'Expiry Year'),
                maxLength: 2,
                controller: _cardExpiryYearController,
              ),
              SizedBox(
                height: 16.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                      child: new RaisedButton(
                    onPressed: () {
                      widget._stripeExpiryYear = _cardExpiryYearController.text;
                      widget._stripeExpiryMonth =
                          _cardExpiryMonthController.text;
                      widget._stripeCardNumber = _cardNumberController.text;
                      widget._onStripeDetailsAdded(
                          _cardNumberController.text,
                          _cardExpiryMonthController.text,
                          _cardExpiryYearController.text);
                      Navigator.pop(context);
                    },
                    child: new Text("Place Order"),
                  ))
                ],
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ));
  }
}
