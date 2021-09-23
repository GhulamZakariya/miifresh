import 'attribute.dart';

class Product {
  String ordersProductsId;
  String ordersId;
  String productsId;
  Null productsModel;
  String productsName;
  String productsPrice;
  String finalPrice;
  String productsTax;
  String productsQuantity;
  String image;
  Null manufacturerName;
  String categoriesName;
  List<Attributes> attributes;

  Product(
      {this.ordersProductsId,
        this.ordersId,
        this.productsId,
        this.productsModel,
        this.productsName,
        this.productsPrice,
        this.finalPrice,
        this.productsTax,
        this.productsQuantity,
        this.image,
        this.manufacturerName,
        this.categoriesName,
        this.attributes});

  Product.fromJson(Map<String, dynamic> json) {
    ordersProductsId = json['orders_products_id'];
    ordersId = json['orders_id'];
    productsId = json['products_id'];
    productsModel = json['products_model'];
    productsName = json['products_name'];
    productsPrice = json['products_price'];
    finalPrice = json['final_price'];
    productsTax = json['products_tax'];
    productsQuantity = json['products_quantity'];
    image = json['image'];
    manufacturerName = json['manufacturer_name'];
    categoriesName = json['categories_name'];
    if (json['attributes'] != null) {
      attributes = new List<Attributes>();
      json['attributes'].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orders_products_id'] = this.ordersProductsId;
    data['orders_id'] = this.ordersId;
    data['products_id'] = this.productsId;
    data['products_model'] = this.productsModel;
    data['products_name'] = this.productsName;
    data['products_price'] = this.productsPrice;
    data['final_price'] = this.finalPrice;
    data['products_tax'] = this.productsTax;
    data['products_quantity'] = this.productsQuantity;
    data['image'] = this.image;
    data['manufacturer_name'] = this.manufacturerName;
    data['categories_name'] = this.categoriesName;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}