import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_customerName_List.dart';
import 'package:tlbilling/utils/app_constants.dart';

abstract class AddSalesBloc {
  Stream get selectedVehicleAndAccessoriesStream;
  Stream get vehicleAndEngineNumberStream;
  Stream get changeVehicleAndAccessoriesListStream;
  Stream get selectedVehicleListStream;
  Stream get selectedVehicleAndAccessoriesListStream;
  Stream get accessoriesIncrementStream;

  TextEditingController get discountTextController;
  TextEditingController get transporterVehicleNumberController;
  TextEditingController get vehicleNoAndEngineNoSearchController;

  String? get selectedVehicleAndAccessories;
  String? get selectedBranch;
  String? get selectedCustomer;

  List<Widget> get selectedItems;

  Stream<bool> get selectedSalesStreamItems;

  int get salesIndex;

  String get selectedGstType;
  bool get isDiscountChecked;
  bool get isInsurenceChecked;
  String? get selectedPaymentOption;

  Future<List<GetAllCustomerNameList>> getAllCustomerList();

  Future<List<String>> getPaymentmethods();
  Stream<List<Map<String, String>>> get vehicleListStream;
  List<Map<String, String>> get vehicleData;
  List<Map<String, String>> get filteredVehicleData;
}

class AddSalesBlocImpl extends AddSalesBloc {
  final _apiServices = AppServiceUtilImpl();
  final _selectedVehicleAndAccessoriesStream = StreamController.broadcast();
  final _changeVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _vehicleAndEngineNumberStream = StreamController.broadcast();
  final _selectedVehicleListStream = StreamController.broadcast();
  final _accessoriesIncrementStream = StreamController.broadcast();
  final _selectedVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _selectedSalesStreamController = StreamController<bool>.broadcast();
  final _discountTextController = TextEditingController();
  final _transporterVehicleNumberController = TextEditingController();
  final _vehicleNoAndEngineNoSearchController = TextEditingController();
  List<String> vehicleAndAccessoriesList = ['Vehicle', 'Accessories'];
  List<String> selectedVehicleList = [];
  List<String> branch = ['Kovilpatti', 'Sattur', 'Sivakasi'];
  late Set<String> optionsSet = {selectedVehicleAndAccessories ?? ''};
  String? _selectedVehicleAndAccessories;
  String? _selectedBranch;
  String? _selectedCustomer;
  int initialValue = 0;
  final List<Widget> _selectedItems = [];
  int? _salesIndex = 0;
  String _selectedGstType = 'GST';
  bool _isDiscountChecked = false;
  bool _isInsurenceChecked = false;
  String? _selectedPaymentOption;
  List<String> _customerNameList = [];
  final _vehicleListStreamController =
      StreamController<List<Map<String, String>>>.broadcast();

  final List<Map<String, String>> _vehicleData = [
    {
      AppConstants.partNo: 'K61916304K',
      AppConstants.vehicleName: 'TVS JUPITER',
      AppConstants.color: 'Red',
      AppConstants.frameNumber: 'MDFJ1A1A1A1A1A1A1',
      AppConstants.engineNumber: 'E1A1A1A1A1A1A1A1A1',
    },
    {
      AppConstants.partNo: 'K61916305K',
      AppConstants.vehicleName: 'HONDA ACTIVA',
      AppConstants.color: 'Blue',
      AppConstants.frameNumber: 'MDFJ2B2B2B2B2B2B2',
      AppConstants.engineNumber: 'E2B2B2B2B2B2B2B2B2',
    },
    {
      AppConstants.partNo: 'K61916306K',
      AppConstants.vehicleName: 'BAJAJ PULSAR',
      AppConstants.color: 'Black',
      AppConstants.frameNumber: 'MDFJ3C3C3C3C3C3C3',
      AppConstants.engineNumber: 'E3C3C3C3C3C3C3C3C',
    },
    {
      AppConstants.partNo: 'K61916307K',
      AppConstants.vehicleName: 'YAMAHA FZ',
      AppConstants.color: 'Green',
      AppConstants.frameNumber: 'MDFJ4D4D4D4D4D4D4',
      AppConstants.engineNumber: 'E4D4D4D4D4D4D4D4D4',
    },
    {
      AppConstants.partNo: 'K61916308K',
      AppConstants.vehicleName: 'SUZUKI GIXXER',
      AppConstants.color: 'Yellow',
      AppConstants.vehicleNumber: 'TN01AB1238',
      AppConstants.frameNumber: 'MDFJ5E5E5E5E5E5E5',
      AppConstants.engineNumber: 'E5E5E5E5E5E5E5E5E5',
    },
    {
      AppConstants.partNo: 'K61916309K',
      AppConstants.vehicleName: 'ROYAL ENFIELD',
      AppConstants.color: 'Black',
      AppConstants.frameNumber: 'MDFJ6F6F6F6F6F6F6',
      AppConstants.engineNumber: 'E6F6F6F6F6F6F6F6F6',
    },
    {
      AppConstants.partNo: 'K61916310K',
      AppConstants.vehicleName: 'HERO SPLENDOR',
      AppConstants.color: 'Red',
      AppConstants.vehicleNumber: 'TN01AB1240',
      AppConstants.frameNumber: 'MDFJ7G7G7G7G7G7G7',
      AppConstants.engineNumber: 'E7G7G7G7G7G7G7G7G7',
    },
    {
      AppConstants.partNo: 'K61916311K',
      AppConstants.vehicleName: 'TVS APACHE',
      AppConstants.color: 'Blue',
      AppConstants.frameNumber: 'MDFJ8H8H8H8H8H8H8',
      AppConstants.engineNumber: 'E8H8H8H8H8H8H8H8H8',
    },
    {
      AppConstants.partNo: 'K61916312K',
      AppConstants.vehicleName: 'KTM DUKE',
      AppConstants.color: 'Orange',
      AppConstants.frameNumber: 'MDFJ9I9I9I9I9I9I9',
      AppConstants.engineNumber: 'E9I9I9I9I9I9I9I9I9',
    },
    {
      AppConstants.partNo: 'K61916313K',
      AppConstants.vehicleName: 'BMW G310R',
      AppConstants.color: 'White',
      AppConstants.frameNumber: 'MDFJ0J0J0J0J0J0J0',
      AppConstants.engineNumber: 'E0J0J0J0J0J0J0J0J0',
    },
  ];

  List<Map<String, String>> _filteredVehicleData = [];
  @override
  String? get selectedVehicleAndAccessories => _selectedVehicleAndAccessories;

  set selectedVehicleAndAccessories(String? newValue) {
    _selectedVehicleAndAccessories = newValue;
  }

  @override
  Stream get selectedVehicleAndAccessoriesStream =>
      _selectedVehicleAndAccessoriesStream.stream;

  selectedVehicleAndAccessoriesStreamController(bool streamValue) {
    _selectedVehicleAndAccessoriesStream.add(streamValue);
  }

  changeSegmentedColor(Color color) {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return color;
      }
      return null;
    });
  }

  @override
  Stream get vehicleAndEngineNumberStream =>
      _vehicleAndEngineNumberStream.stream;

  vehicleAndEngineNumberStreamController(bool streamValue) {
    _vehicleAndEngineNumberStream.add(streamValue);
  }

  @override
  TextEditingController get discountTextController => _discountTextController;

  @override
  Stream get changeVehicleAndAccessoriesListStream =>
      _changeVehicleAndAccessoriesListStream.stream;

  changeVehicleAndAccessoriesListStreamController(bool streamValue) {
    _changeVehicleAndAccessoriesListStream.add(streamValue);
  }

  @override
  Stream get selectedVehicleListStream => _selectedVehicleListStream.stream;

  selectedVehicleListStreamController(bool streamValue) {
    _selectedVehicleListStream.add(streamValue);
  }

  @override
  Stream get selectedVehicleAndAccessoriesListStream =>
      _selectedVehicleAndAccessoriesListStream.stream;

  selectedVehicleAndAccessoriesListStreamController(bool streamValue) {
    _selectedVehicleAndAccessoriesListStream.add(streamValue);
  }

  @override
  Stream get accessoriesIncrementStream => _accessoriesIncrementStream.stream;

  accessoriesIncrementStreamController(bool streamValue) {
    _accessoriesIncrementStream.add(streamValue);
  }

  @override
  String? get selectedBranch => _selectedBranch;

  set selectedBranch(String? newValue) {
    _selectedBranch = newValue;
  }

  @override
  TextEditingController get transporterVehicleNumberController =>
      _transporterVehicleNumberController;

  @override
  List<Widget> get selectedItems => _selectedItems;

  @override
  Stream<bool> get selectedSalesStreamItems =>
      _selectedSalesStreamController.stream;

  selectedSalesStreamController(bool streamValue) {
    _selectedSalesStreamController.add(streamValue);
  }

  @override
  int get salesIndex => _salesIndex!;
  set salesIndex(int value) {
    _salesIndex = value;
  }

  @override
  String get selectedGstType => _selectedGstType;

  set selectedGstType(String value) {
    _selectedGstType = value;
  }

  @override
  bool get isDiscountChecked => _isDiscountChecked;

  set isDiscountChecked(bool discountValue) {
    _isDiscountChecked = discountValue;
  }

  @override
  bool get isInsurenceChecked => _isInsurenceChecked;

  set isInsurenceChecked(bool insurenceValue) {
    _isInsurenceChecked = insurenceValue;
  }

  @override
  String? get selectedPaymentOption => _selectedPaymentOption;

  set selectedPaymentOption(String? paymentOption) {
    _selectedPaymentOption = paymentOption;
  }

  @override
  TextEditingController get vehicleNoAndEngineNoSearchController =>
      _vehicleNoAndEngineNoSearchController;

  @override
  Future<List<GetAllCustomerNameList>> getAllCustomerList() async {
    return await _apiServices.getAllCustomerList();
  }

  @override
  Future<List<String>> getPaymentmethods() async {
    return await _apiServices.getConfigByIdModel(configId: 'paymentMethod');
  }

  @override
  String? get selectedCustomer => _selectedCustomer;

  set selectedCustomer(String? selectedValue) {
    _selectedCustomer = selectedValue;
  }

  @override
  Stream<List<Map<String, String>>> get vehicleListStream =>
      _vehicleListStreamController.stream;

  vehicleListStreamController(List<Map<String, String>> streamValue) {
    _vehicleListStreamController.add(streamValue);
  }

  @override
  List<Map<String, String>> get vehicleData => _vehicleData;

  @override
  List<Map<String, String>> get filteredVehicleData => _filteredVehicleData;

  set filteredVehicleData(List<Map<String, String>> vehicleData) {
    _filteredVehicleData = vehicleData;
  }
}
