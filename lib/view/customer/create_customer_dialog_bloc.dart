import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_customers_model.dart';
import 'package:tlbilling/models/post_model/add_customer_model.dart';

abstract class CreateCustomerDialogBloc {
  TextEditingController get customerNameTextController;

  TextEditingController get custMobileNoTextController;

  TextEditingController get custMailIdTextController;

  TextEditingController get custAccNoTextController;

  TextEditingController get custAadharNoTextController;

  TextEditingController get custCitytextcontroller;

  TextEditingController get custAddressTextController;

  TextEditingController get custIFSCTextController;

  GlobalKey<FormState> get custFormKey;

  bool? get isAsyncCall;

  Future<void> addCustomer(Function(int? statusCode) onSuccessCallBack);

  Future<GetAllCustomersModel?> getCustomerDetails(String customerId);

  Future<void> updateCustomer(
      String customerId, Function(int statusCode) onSuccessCallBack);
}

class CreateCustomerDialogBlocImpl extends CreateCustomerDialogBloc {
  final _custFormKey = GlobalKey<FormState>();
  final _customerNameTextController = TextEditingController();
  final _custMobileNoTextController = TextEditingController();
  final _custMailIdTextController = TextEditingController();
  final _custAccNoTextController = TextEditingController();
  final _custAadharNoTextController = TextEditingController();
  final _custCityTextController = TextEditingController();
  final _custAddressTextController = TextEditingController();
  final _custIFSCTextController = TextEditingController();
  final _apiCalls = AppServiceUtilImpl();
  bool? _isAsyncCall = false;

  @override
  TextEditingController get customerNameTextController =>
      _customerNameTextController;

  @override
  TextEditingController get custMobileNoTextController =>
      _custMobileNoTextController;

  @override
  TextEditingController get custMailIdTextController =>
      _custMailIdTextController;

  @override
  TextEditingController get custAccNoTextController => _custAccNoTextController;

  @override
  TextEditingController get custAadharNoTextController =>
      _custAadharNoTextController;

  @override
  TextEditingController get custCitytextcontroller => _custCityTextController;

  @override
  TextEditingController get custAddressTextController =>
      _custAddressTextController;

  @override
  GlobalKey<FormState> get custFormKey => _custFormKey;

  @override
  Future<void> addCustomer(Function(int? statusCode) onSuccessCallBack) async {
    return await _apiCalls.addCustomer(
        onSuccessCallBack,
        AddCustomerModel(
            aadharNo: custAadharNoTextController.text,
            address: custAddressTextController.text,
            mobileNo: custMobileNoTextController.text,
            accountNo: custAccNoTextController.text,
            city: custCitytextcontroller.text,
            emailId: custMailIdTextController.text,
            customerName: customerNameTextController.text,
            ifsc: custIFSCTextController.text));
  }

  @override
  TextEditingController get custIFSCTextController => _custIFSCTextController;

  @override
  Future<GetAllCustomersModel?> getCustomerDetails(String customerId) async {
    return await _apiCalls.getCustomerDetails(customerId);
  }

  @override
  Future<void> updateCustomer(
      String customerId, Function(int statusCode) onSuccessCallBack) async {
    return await _apiCalls.updateCustomer(
        customerId,
        AddCustomerModel(
            aadharNo: custAadharNoTextController.text,
            address: custAddressTextController.text,
            mobileNo: custMobileNoTextController.text,
            accountNo: custAccNoTextController.text,
            city: custCitytextcontroller.text,
            emailId: custMailIdTextController.text,
            customerName: customerNameTextController.text,
            ifsc: custIFSCTextController.text),
        onSuccessCallBack);
  }

  @override
  bool? get isAsyncCall => _isAsyncCall;

  set isAsyncCall(bool? newValue) {
    _isAsyncCall = newValue;
  }
}
