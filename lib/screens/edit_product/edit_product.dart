import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/toast_message.dart';

class EditProductScreen extends StatelessWidget {
  ProductModel model;
  EditProductScreen({required this.model});

  var productbarcodeController_text = TextEditingController();
  var productNameController_text = TextEditingController();
  var productPriceController_text = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var marketController = Get.find<MarketController>();

  @override
  Widget build(BuildContext context) {
    productNameController_text.text = model.name.toString();
    productbarcodeController_text.text = model.barcode.toString();
    productPriceController_text.text = model.price.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.name}"),
        actions: [
          OutlinedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  int? price = int.tryParse(productPriceController_text.text);
                  if (price != null) {
                    marketController
                        .updateProduct(ProductModel(
                            barcode: model.barcode,
                            name: productNameController_text.text,
                            price: productPriceController_text.text))
                        .then((value) {
                      Get.back();
                      showToast(
                          message: marketController.statusUpdateBodyMessage,
                          status: marketController.statusUpdateMessage);
                    });
                  } else {
                    showToast(
                        message: "Price Must be a number ",
                        status: ToastStatus.Error);
                  }
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: _build_Form(),
    );
  }

  _build_Form() => SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: productbarcodeController_text,
                    enabled: false,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(hintText: "Barcode..."),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  defaultTextFormField(
                      onvalidate: (value) {
                        if (value!.isEmpty) {
                          return "Name must not be empty";
                        }
                      },
                      inputtype: TextInputType.name,
                      border: UnderlineInputBorder(),
                      hinttext: "Name...",
                      controller: productNameController_text),
                  SizedBox(
                    height: 5,
                  ),
                  defaultTextFormField(
                      onvalidate: (value) {
                        if (value!.isEmpty) {
                          return "Price must not be empty";
                        }
                      },
                      inputtype: TextInputType.phone,
                      border: UnderlineInputBorder(),
                      hinttext: "Price...",
                      controller: productPriceController_text),
                ],
              ),
            )),
      );
}