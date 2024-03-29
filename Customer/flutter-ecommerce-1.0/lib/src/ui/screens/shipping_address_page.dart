import 'package:flutter/material.dart';
import 'package:flutter_app1/constants.dart';
import 'package:flutter_app1/src/api/responses/add_address_response.dart';
import 'package:flutter_app1/src/api/responses/countries_response.dart';
import 'package:flutter_app1/src/api/responses/zones_response.dart';
import 'package:flutter_app1/src/blocs/address/address_bloc.dart';
import 'package:flutter_app1/src/models/address/address.dart';
import 'package:flutter_app1/src/models/address/my_address.dart';
import 'package:flutter_app1/src/models/cart_entry.dart';
import 'package:flutter_app1/src/models/address/country.dart';
import 'package:flutter_app1/src/models/product_models/product.dart';
import 'package:flutter_app1/src/models/address/zone.dart';
import 'package:flutter_app1/src/repositories/address_repo.dart';
import 'package:flutter_app1/src/ui/screens/billing_address_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class ShippingAddress extends StatelessWidget {
  List<CartEntry> cartEntries;
  List<Product> cartProducts;

  ShippingAddress(this.cartEntries, this.cartProducts);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Shipping Address"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MyCustomForm(cartEntries, cartProducts),
          ],
        ),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  List<CartEntry> cartEntries;
  List<Product> cartProducts;

  MyCustomForm(this.cartEntries, this.cartProducts);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final _addressBloc = AddressBloc(RealAddressRepo());

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();

  double latitude, longitude;
  Country selectedCountry;
  Zone selectedZone;

  Country defaultCountry;
  Zone defaultZone;

  bool isChecked = false;
  MyAddress defaultAddress;

  @override
  void initState() {
    super.initState();

    _addressBloc.addressEventSink.add(GetCountries());

    _addressBloc.getDefaultAddressEventSink.add(GetDefaultAddress());

    _addressBloc.addAddressStream.listen((AddAddressResponse response) {
      if (response != null) {
        if (response.success == "1") {}
      }
    });

    _addressBloc.getDefaultAddressStream.listen((MyAddress address) {
      if (address != null) {
        defaultAddress = address;

        defaultCountry = Country();
        defaultCountry.countriesId = address.countriesId as String;
        defaultCountry.countriesName = address.countryName;

        defaultZone = Zone();
        defaultZone.zoneId = address.zoneId as String;
        defaultZone.zoneName = address.zoneName;
        defaultZone.zoneCode = address.zoneCode;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: StreamBuilder(
        stream: _addressBloc.getDefaultAddressStream,
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            MyAddress data = snapshot.data as MyAddress;
            return buildFormData(context, data);
          } else
            return buildFormData(context, null);
        },
      ),
    );
  }

  Widget buildFormData(BuildContext context, MyAddress address) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
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
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
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
                GestureDetector(
                  onTap: () {
                    print("AppConstants.PLACE_PICKER_API_KEY////////////////////////");
                    print(AppConstants.PLACE_PICKER_API_KEY);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlacePicker(
                          apiKey: AppConstants.PLACE_PICKER_API_KEY,
                          onPlacePicked: (result) {
                            print(result.geometry.location.lat.toString() +
                                "---" +
                                result.geometry.location.lng.toString());
                            setState(() {
                              latitude = result.geometry.location.lat;
                              longitude = result.geometry.location.lng;

                              _addressController.text = result.formattedAddress;
                            });
                            Navigator.of(context).pop();
                          },
                          initialPosition: LatLng(0.0, 0.0),
                          useCurrentLocation: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 14, bottom: 14, left: 8, right: 8),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      (latitude == null)
                          ? "Location"
                          : latitude.toString() + ", " + longitude.toString(),
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
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
                (isChecked)
                    ? Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 14, bottom: 14, left: 8, right: 8),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Text(
                              (defaultCountry == null)
                                  ? "Country"
                                  : defaultCountry.countriesName,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                        ],
                      )
                    : StreamBuilder(
                        stream: _addressBloc.countriesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData || snapshot.data != null) {
                            CountriesResponse response =
                                snapshot.data as CountriesResponse;
                            if (response.success == "1" &&
                                response.data.length > 0) {
                              return Column(
                                children: [
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    hint: Text("Country"),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(8.0),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    ),
                                    items: response.data.map((e) {
                                      return new DropdownMenuItem(
                                          value: e,
                                          child: Text(e.countriesName));
                                    }).toList(),
                                    onChanged: (value) {
                                      selectedCountry = value as Country;
                                      _addressBloc.addressEventSink.add(
                                          GetZones(
                                              selectedCountry.countriesId));
                                    },
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                ],
                              );
                            } else {
                              return _buildLoadingField("Country");
                            }
                          } else {
                            return _buildLoadingField("Country");
                          }
                        },
                      ),
                (isChecked)
                    ? Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 14, bottom: 14, left: 8, right: 8),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Text(
                              (defaultZone == null)
                                  ? "Zone"
                                  : defaultZone.zoneName,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                        ],
                      )
                    : StreamBuilder(
                        stream: _addressBloc.zonesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData || snapshot.data != null) {
                            ZonesResponse response =
                                snapshot.data as ZonesResponse;
                            if (response.success == "1" &&
                                response.data.length > 0) {
                              return Column(
                                children: [
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    hint: Text("Zone"),
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(8.0),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(8.0),
                                        borderSide: new BorderSide(),
                                      ),
                                    ),
                                    items: response.data.map((e) {
                                      return new DropdownMenuItem(
                                          value: e, child: Text(e.zoneName));
                                    }).toList(),
                                    onChanged: (value) {
                                      selectedZone = value as Zone;
                                    },
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                ],
                              );
                            } else {
                              return _buildLoadingField("Zone");
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
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
                  controller: _postalCodeController,
                  decoration: InputDecoration(
                    labelText: 'PostCode',
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
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
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
                if (address != null)
                  SwitchListTile(
                    title: Text("Default Shipping Address"),
                    contentPadding: EdgeInsets.all(0.0),
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        this.isChecked = value;
                        if (!isChecked) {
                          _firstNameController.clear();
                          _lastNameController.clear();
                          _addressController.clear();
                          _cityController.clear();
                          _postalCodeController.clear();
                          //_phoneController.clear();
                          selectedCountry = null;
                          selectedZone = null;

                          latitude = null;
                          longitude = null;

                          _addressBloc.addressEventSink.add(GetCountries());
                        } else {
                          _firstNameController.text = address.firstname;
                          _lastNameController.text = address.lastname;
                          _addressController.text = address.street;
                          _cityController.text = address.city;
                          _postalCodeController.text = address.postcode;
                          //_phoneController.text = "";
                          selectedCountry = defaultCountry;

                          selectedZone = defaultZone;

                          latitude =
                              double.tryParse(address.latitude.toString());
                          longitude =
                              double.tryParse(address.longitude.toString());
                        }
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: FlatButton(
            color: Colors.green[800],
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              if (_formKey.currentState.validate() &&
                  selectedCountry != null &&
                  selectedZone != null) {
                Address shippingAddress = Address();
                shippingAddress.deliveryFirstName = _firstNameController.text;
                shippingAddress.deliveryLastName = _lastNameController.text;
                shippingAddress.deliveryStreetAddress = _addressController.text;
                shippingAddress.deliveryCity = _cityController.text;
                shippingAddress.deliveryPostCode = _postalCodeController.text;
                shippingAddress.deliveryPhone = _phoneController.text;

                shippingAddress.deliveryZone = selectedZone;
                shippingAddress.deliveryCountry = selectedCountry;
                shippingAddress.deliveryCountryCode = "";
                shippingAddress.deliveryLat = latitude.toString();
                shippingAddress.deliveryLong = longitude.toString();

                _addressBloc.addAddressEventSink
                    .add(AddAddress(shippingAddress));

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BillingAddress(widget.cartEntries,
                            widget.cartProducts, shippingAddress)));
              }
            },
            child: Text(
              "Proceed",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLoadingField(String title) {
    return Column(
      children: [
        Stack(
          children: <Widget>[
            TextFormField(
              enabled: false,
              decoration: InputDecoration(
                labelText: title,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(8.0),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(8.0),
                  borderSide: new BorderSide(),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
