// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_quantity/input_quantity.dart';

import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';

class VehicleAccessoriesList extends StatefulWidget {
  AddSalesBlocImpl addSalesBloc;
  Function(List<Widget>)? selectedItems;
  VehicleAccessoriesList(
      {super.key, required this.addSalesBloc, this.selectedItems});

  @override
  State<VehicleAccessoriesList> createState() => _VehicleAccessoriesListState();
}

class _VehicleAccessoriesListState extends State<VehicleAccessoriesList> {
  final _appColors = AppColors();

  @override
  void initState() {
    super.initState();
    widget.addSalesBloc.filteredVehicleData =
        List.from(widget.addSalesBloc.vehicleData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildDefaultHeight(),
          _buildHeadingAndSegmentedButton(),
          _buildDefaultHeight(),
          _buildVehicleNameAndEngineNumberSearch(),
          _buildDefaultHeight(),
          _buildVehicleAndAccessoriesList()
        ],
      ),
    );
  }

  Widget _buildVehicleAndAccessoriesList() {
    return StreamBuilder(
      stream: widget.addSalesBloc.changeVehicleAndAccessoriesListStream,
      builder: (context, snapshot) {
        return widget.addSalesBloc.selectedVehicleAndAccessories == 'Vehicle'
            ? _buildAvailableVehicleList()
            : widget.addSalesBloc.selectedVehicleAndAccessories == 'Accessories'
                ? _buildAvailableAccessoriesList()
                : Center(
                    child: _buildCustomTextWidget(
                        AppConstants.selectVehicleOrAccessories),
                  );
      },
    );
  }

  Widget _buildAvailableVehicleList() {
    return StreamBuilder(
        stream: widget.addSalesBloc.vehicleListStream,
        builder: (context, snapshot) {
          return Expanded(
              child: ListView.builder(
            itemCount: widget.addSalesBloc.filteredVehicleData.length,
            itemBuilder: (context, index) {
              var vehicle = widget.addSalesBloc.filteredVehicleData[index];
              return Card(
                color: _appColors.whiteColor,
                elevation: 0,
                shape: OutlineInputBorder(
                    borderSide: BorderSide(color: _appColors.cardBorderColor),
                    borderRadius: BorderRadius.circular(5)),
                surfaceTintColor: _appColors.whiteColor,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCustomTextWidget(
                              '${vehicle[AppConstants.vehicleName]}',
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          _buildCustomTextWidget(
                              '${vehicle[AppConstants.color]}',
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ],
                      ),
                      _buildCustomTextWidget('${vehicle[AppConstants.partNo]}',
                          color: _appColors.greyColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCustomTextWidget(
                                  '${vehicle[AppConstants.engineNumber]}',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                              AppWidgetUtils.buildSizedBox(custWidth: 12),
                              _buildCustomTextWidget(
                                  '${vehicle[AppConstants.frameNumber]}',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    var selectedVehicle = widget
                                        .addSalesBloc.filteredVehicleData
                                        .removeAt(index);
                                    widget.addSalesBloc
                                        .vehicleListStreamController(
                                            widget.addSalesBloc.vehicleData);
                                    widget.addSalesBloc.selectedItems.add(
                                        _buildSelectedVehicleCard(
                                            selectedVehicle));
                                    widget.addSalesBloc
                                        .selectedSalesStreamController(true);
                                    widget.addSalesBloc.selectedVehicleList
                                        .add('');
                                    widget.addSalesBloc
                                        .selectedVehicleListStreamController(
                                            true);
                                  },
                                  icon: SvgPicture.asset(
                                    AppConstants.icFilledAdd,
                                    height: 24,
                                    width: 24,
                                  ))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ));
        });
  }

  Widget _buildAvailableAccessoriesList() {
    return Expanded(
        child: ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          color: _appColors.whiteColor,
          elevation: 0,
          shape: OutlineInputBorder(
              borderSide: BorderSide(color: _appColors.cardBorderColor),
              borderRadius: BorderRadius.circular(5)),
          surfaceTintColor: _appColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomTextWidget('TVS APACHE - 200',
                            fontSize: 14, fontWeight: FontWeight.w500),
                        _buildCustomTextWidget('Navy Blue',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _appColors.liteGrayColor),
                      ],
                    ),
                    _buildCustomTextWidget('Qty - 20',
                        fontSize: 14, fontWeight: FontWeight.w500),
                    IconButton(
                        onPressed: () {
                          widget.addSalesBloc.selectedItems
                              .add(_buildSelectedAccessoriesCardDetails());
                          widget.addSalesBloc
                              .selectedSalesStreamController(true);
                        },
                        icon: SvgPicture.asset(
                          AppConstants.icFilledAdd,
                          width: 24,
                          height: 24,
                        ))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  Widget _buildSelectedAccessoriesCardDetails() {
    return Card(
      elevation: 0,
      shape: OutlineInputBorder(
          borderSide: BorderSide(color: _appColors.cardBorderColor),
          borderRadius: BorderRadius.circular(5)),
      surfaceTintColor: _appColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomTextWidget('Tool Kit',
                    fontWeight: FontWeight.w500, fontSize: 14),
                _buildCustomTextWidget('TK627856',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: _appColors.liteGrayColor)
              ],
            ),
            StreamBuilder(
              stream: widget.addSalesBloc.accessoriesIncrementStream,
              builder: (context, snapshot) {
                return InputQty(
                  decoration: QtyDecorationProps(
                      constraints:
                          const BoxConstraints(minWidth: 150, maxWidth: 150),
                      plusBtn: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.addSalesBloc.initialValue++;
                              widget.addSalesBloc
                                  .accessoriesIncrementStreamController(true);
                            });
                          },
                          icon: SvgPicture.asset(
                            AppConstants.icFilledAdd,
                            width: 24,
                            height: 24,
                          )),
                      minusBtn: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.addSalesBloc.initialValue--;
                              widget.addSalesBloc
                                  .accessoriesIncrementStreamController(true);
                            });
                          },
                          icon: SvgPicture.asset(
                            AppConstants.icFilledMinus,
                            width: 24,
                            height: 24,
                          )),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: _appColors.liteBlueColor, width: 2.5),
                          borderRadius: BorderRadius.circular(10))),
                  initVal: widget.addSalesBloc.initialValue,
                  steps: 1,
                );
              },
            ),
            IconButton(
                onPressed: () {
                  widget.addSalesBloc.selectedItems
                      .removeAt(widget.addSalesBloc.salesIndex);
                  widget.addSalesBloc.selectedSalesStreamController(true);
                },
                icon: SvgPicture.asset(AppConstants.icFilledClose))
          ],
        ),
      ),
    );
  }

  Widget _buildHeadingAndSegmentedButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: StreamBuilder(
            stream: widget.addSalesBloc.selectedVehicleAndAccessoriesStream,
            builder: (context, snapshot) {
              return SegmentedButton(
                selected: widget.addSalesBloc.optionsSet,
                multiSelectionEnabled: false,
                segments: List.generate(
                    widget.addSalesBloc.vehicleAndAccessoriesList.length,
                    (index) => ButtonSegment(
                        value: widget
                            .addSalesBloc.vehicleAndAccessoriesList[index],
                        label: Text(
                          widget.addSalesBloc.vehicleAndAccessoriesList[index],
                        ))),
                onSelectionChanged: (Set<String> newValue) {
                  widget.addSalesBloc.optionsSet = newValue;
                  widget.addSalesBloc.selectedVehicleAndAccessories =
                      widget.addSalesBloc.optionsSet.first;
                  widget.addSalesBloc.selectedVehicleAndAccessories ==
                          'Accessories'
                      ? widget.addSalesBloc.selectedVehicleList.clear()
                      : null;
                  widget.addSalesBloc
                      .selectedVehicleAndAccessoriesStreamController(true);
                  widget.addSalesBloc
                      .changeVehicleAndAccessoriesListStreamController(true);
                  widget.addSalesBloc
                      .selectedVehicleAndAccessoriesListStreamController(true);
                },
                style: ButtonStyle(
                  backgroundColor: widget.addSalesBloc
                      .changeSegmentedColor(_appColors.segmentedButtonColor),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildVehicleNameAndEngineNumberSearch() {
    return Container(
      color: _appColors.whiteColor,
      child: StreamBuilder(
        stream: widget.addSalesBloc.vehicleAndEngineNumberStream,
        builder: (context, snapshot) {
          final bool isTextEmpty = widget
              .addSalesBloc.vehicleNoAndEngineNoSearchController.text.isEmpty;
          final IconData iconData = isTextEmpty ? Icons.search : Icons.close;
          final Color iconColor =
              isTextEmpty ? _appColors.primaryColor : Colors.red;
          return TldsInputFormField(
            height: 40,
            controller:
                widget.addSalesBloc.vehicleNoAndEngineNoSearchController,
            hintText: AppConstants.vehicleNameAndEngineNumber,
            suffixIcon: IconButton(
              onPressed: () {
                if (isTextEmpty) {
                  widget.addSalesBloc.vehicleNoAndEngineNoSearchController
                      .clear();
                  updateFilteredVehicleList('');
                }
                widget.addSalesBloc
                    .vehicleAndEngineNumberStreamController(true);
              },
              icon: Icon(
                iconData,
                color: iconColor,
              ),
            ),
            onChanged: (value) {
              updateFilteredVehicleList(value);
              widget.addSalesBloc.vehicleAndEngineNumberStreamController(true);
            },
          );
        },
      ),
    );
  }

  Widget _buildCustomTextWidget(String text,
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          color: color, fontWeight: fontWeight, fontSize: fontSize),
    );
  }

  Widget _buildDefaultHeight({double? height}) {
    return AppWidgetUtils.buildSizedBox(
        custHeight: height ?? MediaQuery.sizeOf(context).height * 0.02);
  }

  Widget _buildSelectedVehicleCard(Map<String, String> vehicle) {
    return Card(
      color: _appColors.whiteColor,
      elevation: 0,
      shape: OutlineInputBorder(
          borderSide: BorderSide(color: _appColors.cardBorderColor),
          borderRadius: BorderRadius.circular(5)),
      surfaceTintColor: _appColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCustomTextWidget('${vehicle[AppConstants.vehicleName]}',
                    fontSize: 14, fontWeight: FontWeight.w500),
                _buildCustomTextWidget('${vehicle[AppConstants.color]}',
                    fontSize: 12, fontWeight: FontWeight.w500),
              ],
            ),
            _buildCustomTextWidget('${vehicle[AppConstants.partNo]}',
                color: _appColors.greyColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCustomTextWidget(
                        '${vehicle[AppConstants.engineNumber]}',
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    AppWidgetUtils.buildSizedBox(custWidth: 12),
                    _buildCustomTextWidget(
                        '${vehicle[AppConstants.frameNumber]}',
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.addSalesBloc.selectedItems
                              .removeAt(widget.addSalesBloc.salesIndex);
                          widget.addSalesBloc.filteredVehicleData.add(vehicle);
                          widget.addSalesBloc
                              .selectedSalesStreamController(true);
                          widget.addSalesBloc.selectedVehicleList.add('');
                          widget.addSalesBloc.vehicleListStreamController(
                              widget.addSalesBloc.filteredVehicleData);
                          widget.addSalesBloc
                              .selectedSalesStreamController(true);
                          widget.addSalesBloc
                              .selectedVehicleListStreamController(true);
                        },
                        icon: SvgPicture.asset(
                          AppConstants.icFilledClose,
                          height: 28,
                          width: 28,
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void updateFilteredVehicleList(String query) {
    setState(() {
      if (query.isEmpty) {
        widget.addSalesBloc.filteredVehicleData =
            List.from(widget.addSalesBloc.vehicleData);
      } else {
        widget.addSalesBloc.filteredVehicleData =
            widget.addSalesBloc.vehicleData.where((vehicle) {
          var lowerCaseQuery = query.toLowerCase();
          return vehicle[AppConstants.engineNumber]!
                  .toLowerCase()
                  .contains(lowerCaseQuery) ||
              vehicle[AppConstants.frameNumber]!
                  .toLowerCase()
                  .contains(lowerCaseQuery);
        }).toList();
      }
    });
  }
}
