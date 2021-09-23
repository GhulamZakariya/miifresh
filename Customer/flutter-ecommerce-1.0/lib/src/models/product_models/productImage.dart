class ProductImages {
  String id;
  String productsId;
  String image;
  String htmlcontent;
  String sortOrder;

  ProductImages(
      {this.id, this.productsId, this.image, this.htmlcontent, this.sortOrder});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productsId = json['products_id'];
    image = json['image'];
    htmlcontent = json['htmlcontent'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['products_id'] = this.productsId;
    data['image'] = this.image;
    data['htmlcontent'] = this.htmlcontent;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}
