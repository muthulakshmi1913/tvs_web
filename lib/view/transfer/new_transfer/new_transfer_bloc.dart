import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tlbilling/api_service/app_service_utils.dart';
import 'package:tlbilling/models/get_model/get_all_branches_by_pagination.dart';
import 'package:tlbilling/models/get_model/get_transport_by_pagination.dart';

import '../../../utils/app_constants.dart';

abstract class NewTransferBloc {
  Stream get selectedVehicleAndAccessoriesStream;

  Stream get vehicleAndEngineNumberStream;

  Stream get changeVehicleAndAccessoriesListStream;

  Stream get selectedVehicleListStream;

  Stream get selectedVehicleAndAccessoriesListStream;

  Stream<int> get accessoriesIncrementStream;

  TextEditingController get vehicleAndEngineNumberController;

  TextEditingController get transporterVehicleNumberController;

  String? get selectedVehicleAndAccessories;

  String? get selectedFromBranch;

  String? get selectedToBranch;

  String? get selectedTransporterName;

  String? get selectedTransporterId;

  Future<List<BranchDetail>?> getBranches();

  Future<List<TransportDetails>?> getAllTransportsWithoutPagination();

  Stream get transporterDetailsStreamController;

  Future<TransportDetails?> getTransporterDetailById();

  String? get transporterName;

  String? get transporterMobileNumber;

  String? get transporterMailId;

  List<Map<String, String>> get vehicleData;

  List<Widget> get selectedItems;

  int? get salesIndex;

  Stream get availableVehicleListStreamController;

  Stream get selectedItemStreamController;

  List<String> get toBranchNameList;

  Stream get toBranchNameListStreamController;

  Stream get fromBranchNameListStreamController;

  GlobalKey<FormState> get dropDownFormKey;

  Stream get availableAccListStreamController;

  Stream<Map<String, dynamic>> get filteredAccListStreamController;

  TextEditingController get accessoriesCountController;
}

class NewTransferBlocImpl extends NewTransferBloc {
  final _selectedVehicleAndAccessoriesStream = StreamController.broadcast();
  final _changeVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _vehicleAndEngineNumberStream = StreamController.broadcast();
  final _selectedVehicleListStream = StreamController.broadcast();
  final StreamController<int> _accessoriesIncrementStream =
      StreamController.broadcast();
  final _selectedVehicleAndAccessoriesListStream = StreamController.broadcast();
  final _transporterDetailsStreamController = StreamController.broadcast();
  final _availableVehicleListStreamController = StreamController.broadcast();
  final _selectedItemStreamController = StreamController.broadcast();
  final _fromBranchNameListStreamController = StreamController.broadcast();
  final _toBranchNameListStreamController = StreamController.broadcast();
  final _availableAccListStreamController = StreamController.broadcast();
  final StreamController<Map<String, dynamic>>
      _filteredAccListStreamController = StreamController.broadcast();
  final _dropDownFormKey = GlobalKey<FormState>();
  final _vehicleAndEngineNumberController = TextEditingController();
  final _transporterVehicleNumberController = TextEditingController();
  final _accessoriesCountController = TextEditingController();
  List<String>? _toBranchNameList;
  List<String> vehicleAndAccessoriesList = ['Vehicle', 'Accessories'];
  List<Widget> selectedVehicleList = [];
  List<Map<String, String>> selectedList = [];
  List<String> branch = ['Kovilpatti', 'Sattur', 'Sivakasi'];
  late Set<String> optionsSet = {selectedVehicleAndAccessories ?? ''};
  String? _selectedVehicleAndAccessories;
  String? _selectedFromBranch;
  String? _selectedToBranch;
  String? _selectedTransporterName;
  String? _selectedTransporterId;
  String? _transporterMailId;
  String? _transporterMobileNumber;
  String? _transporterName;
  int initialValue = 0;
  int? _salesIndex = 0;

  final List<Map<String, String>> _vehicleData = [
    {
      AppConstants.partNo: 'K61916304K',
      AppConstants.vehicleName: 'TVS JUPITER',
      AppConstants.color: 'Red',
      AppConstants.vehicleNumber: 'TN01AB1240',
      AppConstants.frameNumber: 'MDFJ1A1A1A1A1A1A1',
      AppConstants.engineNumber: 'E1A1A1A1A1A1A1A1A1',
    },
    {
      AppConstants.partNo: 'K61916305K',
      AppConstants.vehicleName: 'HONDA ACTIVA',
      AppConstants.color: 'Blue',
      AppConstants.vehicleNumber: 'TN01AB1240',
      AppConstants.frameNumber: 'MDFJ2B2B2B2B2B2B2',
      AppConstants.engineNumber: 'E2B2B2B2B2B2B2B2B2',
    },
    {
      AppConstants.partNo: 'K61916306K',
      AppConstants.vehicleName: 'BAJAJ PULSAR',
      AppConstants.color: 'Black',
      AppConstants.vehicleNumber: 'TN01AB1240',
      AppConstants.frameNumber: 'MDFJ3C3C3C3C3C3C3',
      AppConstants.engineNumber: 'E3C3C3C3C3C3C3C3C',
    },
    {
      AppConstants.partNo: 'K61916307K',
      AppConstants.vehicleName: 'YAMAHA FZ',
      AppConstants.color: 'Green',
      AppConstants.vehicleNumber: 'TN01AB1240',
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
      AppConstants.vehicleNumber: 'TN01AB1240',
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
      AppConstants.vehicleNumber: 'TN01AB1240',
      AppConstants.frameNumber: 'MDFJ8H8H8H8H8H8H8',
      AppConstants.engineNumber: 'E8H8H8H8H8H8H8H8H8',
    },
    {
      AppConstants.partNo: 'K61916312K',
      AppConstants.vehicleName: 'KTM DUKE',
      AppConstants.color: 'Orange',
      AppConstants.vehicleNumber: 'TN01AB1240',
      AppConstants.frameNumber: 'MDFJ9I9I9I9I9I9I9',
      AppConstants.engineNumber: 'E9I9I9I9I9I9I9I9I9',
    },
    {
      AppConstants.partNo: 'K61916313K',
      AppConstants.vehicleName: 'BMW G310R',
      AppConstants.color: 'White',
      AppConstants.vehicleNumber: 'TN01AB1240',
      AppConstants.frameNumber: 'MDFJ0J0J0J0J0J0J0',
      AppConstants.engineNumber: 'E0J0J0J0J0J0J0J0J0',
    },
  ];
  final List<Map<String, dynamic>> accessoriesList = [
    {
      AppConstants.accessoriesName: 'TVS-APACHE TOOL KIT',
      AppConstants.quantity: 10,
      AppConstants.accessoriesNumber: 'K61916321F',
    },
    {
      AppConstants.accessoriesName: 'HELMET',
      AppConstants.quantity: 20,
      AppConstants.accessoriesNumber: 'K61916322F',
    },
    {
      AppConstants.accessoriesName: 'STAR-CITY FOOT REST',
      AppConstants.quantity: 10,
      AppConstants.accessoriesNumber: 'K61916323F',
    },
    {
      AppConstants.accessoriesName: 'XL-SUPER SEAT',
      AppConstants.quantity: 5,
      AppConstants.accessoriesNumber: 'K61916324F',
    },
    {
      AppConstants.accessoriesName: 'SILENCER',
      AppConstants.quantity: 2,
      AppConstants.accessoriesNumber: 'K61916325F',
    },
  ];
  final List<Map<String, dynamic>> filteredAccessoriesList = [];

  final List<Widget> _selectedItems = [];

  final _appServices = AppServiceUtilImpl();

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
  TextEditingController get vehicleAndEngineNumberController =>
      _vehicleAndEngineNumberController;

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
  Stream<int> get accessoriesIncrementStream =>
      _accessoriesIncrementStream.stream;

  accessoriesIncrementStreamController(int streamValue) {
    _accessoriesIncrementStream.add(streamValue);
  }

  @override
  String? get selectedFromBranch => _selectedFromBranch;

  set selectedFromBranch(String? newValue) {
    _selectedFromBranch = newValue;
  }

  @override
  TextEditingController get transporterVehicleNumberController =>
      _transporterVehicleNumberController;

  @override
  Future<List<BranchDetail>?> getBranches() async {
    return _appServices.getAllBranchListWithoutPagination();
  }

  @override
  Future<List<TransportDetails>?> getAllTransportsWithoutPagination() async {
    return _appServices.getAllTransportsWithoutPagination();
  }

  @override
  String? get selectedToBranch => _selectedToBranch;

  set selectedToBranch(String? newValue) {
    _selectedToBranch = newValue;
  }

  @override
  String? get selectedTransporterId => _selectedTransporterId;

  set selectedTransporterId(String? newValue) {
    _selectedTransporterId = newValue;
  }

  @override
  String? get selectedTransporterName => _selectedTransporterName;

  set selectedTransporterName(String? newValue) {
    _selectedTransporterName = newValue;
  }

  @override
  Stream get transporterDetailsStreamController =>
      _transporterDetailsStreamController.stream;

  transporterDetailsStream(bool? streamValue) {
    _transporterDetailsStreamController.add(streamValue);
  }

  @override
  Future<TransportDetails?> getTransporterDetailById() async {
    return _appServices.getTransportDetailsById(selectedTransporterId ?? '');
  }

  @override
  String? get transporterMailId => _transporterMailId;

  set transporterMailId(String? newValue) {
    _transporterMailId = newValue;
  }

  @override
  String? get transporterMobileNumber => _transporterMobileNumber;

  set transporterMobileNumber(String? newValue) {
    _transporterMobileNumber = newValue;
  }

  @override
  String? get transporterName => _transporterName;

  set transporterName(String? newValue) {
    _transporterName = newValue;
  }

  @override
  List<Map<String, String>> get vehicleData => _vehicleData;

  @override
  List<Widget> get selectedItems => _selectedItems;

  @override
  int? get salesIndex => _salesIndex;

  set salesIndex(int? newValue) {
    _salesIndex = newValue;
  }

  @override
  Stream get availableVehicleListStreamController =>
      _availableVehicleListStreamController.stream;

  availableVehicleListStream(bool? streamValue) {
    _availableVehicleListStreamController.add(streamValue);
  }

  @override
  Stream get selectedItemStreamController =>
      _selectedItemStreamController.stream;

  selectedItemStream(bool? streamValue) {
    _selectedItemStreamController.add(streamValue);
  }

  @override
  List<String> get toBranchNameList => _toBranchNameList ?? [];

  set toBranchNameList(List<String> newList) {
    _toBranchNameList = newList;
  }

  @override
  Stream get toBranchNameListStreamController =>
      _toBranchNameListStreamController.stream;

  toBranchNameListStream(bool? streamValue) {
    _toBranchNameListStreamController.add(streamValue);
  }

  @override
  GlobalKey<FormState> get dropDownFormKey => _dropDownFormKey;

  @override
  Stream get fromBranchNameListStreamController =>
      _fromBranchNameListStreamController.stream;

  fromBranchNameListStream(bool? streamValue) {
    _fromBranchNameListStreamController.add(streamValue);
  }

  @override
  Stream get availableAccListStreamController =>
      _availableAccListStreamController.stream;

  availableAccListStream(bool? streamValue) {
    _availableAccListStreamController.add(streamValue);
  }

  @override
  Stream<Map<String, dynamic>> get filteredAccListStreamController =>
      _filteredAccListStreamController.stream;

  filteredAccListStream(Map<String, dynamic> streamValue) {
    _filteredAccListStreamController.add(streamValue);
  }

  @override
  TextEditingController get accessoriesCountController =>
      _accessoriesCountController;
}
