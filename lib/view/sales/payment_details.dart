import 'package:flutter/material.dart';
import 'package:tlbilling/components/custom_action_button.dart';
import 'package:tlbilling/utils/app_colors.dart';
import 'package:tlbilling/utils/app_constants.dart';
import 'package:tlbilling/utils/app_util_widgets.dart';
import 'package:tlbilling/utils/app_utils.dart';
import 'package:tlbilling/utils/input_formates.dart';
import 'package:tlbilling/view/sales/add_sales_bloc.dart';
import 'package:tlds_flutter/components/tlds_input_form_field.dart';
import 'package:tlds_flutter/components/tlds_input_formaters.dart';

class PaymentDetails extends StatefulWidget {
  final AddSalesBlocImpl addSalesBloc;

  const PaymentDetails({
    super.key,
    required this.addSalesBloc,
  });

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 45, right: 30, left: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGstDetails(),
            AppWidgetUtils.buildSizedBox(custHeight: 30),
            _buildHeadingText(AppConstants.paymentDetails),
            _buildPaymentDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildGstDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeadingText(AppConstants.gstDetails),
        AppWidgetUtils.buildSizedBox(custHeight: 10),
        _buildHsnCodeField(),
        AppWidgetUtils.buildSizedBox(custHeight: 18),
        _buildGstRadioBtns(),
      ],
    );
  }

  Widget _buildHsnCodeField() {
    return TldsInputFormField(
      inputFormatters: TlInputFormatters.onlyAllowNumbers,
      hintText: AppConstants.hsnCode,
      labelText: AppConstants.hsnCode,
      controller: widget.addSalesBloc.hsnCodeTextController,
      onChanged: (hsn) {},
      validator: (value) {
        if (value!.isEmpty) {
          return AppConstants.enterHsnCode;
        }
        return null;
      },
      focusNode: widget.addSalesBloc.hsnCodeFocus,
      onSubmit: (value) {
        FocusScope.of(context).requestFocus(widget.addSalesBloc.cgstFocus);
      },
    );
  }

  Widget _buildGstRadioBtns() {
    return StreamBuilder<bool>(
      stream: widget.addSalesBloc.gstRadioBtnRefreashStream,
      builder: (context, snapshot) {
        return Row(
          children: [
            Row(
              children: widget.addSalesBloc.gstTypeOptions.map((gstTypeOption) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: gstTypeOption,
                        groupValue: widget.addSalesBloc.selectedGstType,
                        onChanged: (String? value) {
                          setState(() {
                            //   print('Selected GST Type: $value');

                            widget.addSalesBloc.selectedGstType = value;
                            FocusScope.of(context)
                                .requestFocus(widget.addSalesBloc.igstFocus);
                            widget.addSalesBloc
                                .gstRadioBtnRefreashStreamController(true);
                          });
                        },
                      ),
                      Text(gstTypeOption),
                    ],
                  ),
                );
              }).toList(),
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 10),
            if (widget.addSalesBloc.selectedGstType == AppConstants.gstPercent)
              _buildGstPercentFields()
            else if (widget.addSalesBloc.selectedGstType ==
                AppConstants.igstPercent)
              _buildIgstPercentField(),
          ],
        );
      },
    );
  }

  Widget _buildGstPercentFields() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: TldsInputFormField(
              inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
              hintText: AppConstants.cgstPercent,
              controller: widget.addSalesBloc.cgstPresentageTextController,
              focusNode: widget.addSalesBloc.cgstFocus,
              onChanged: (cgst) {
                setState(() {
                  _calculateGST();
                });
              },
              onSubmit: (value) {
                FocusScope.of(context)
                    .requestFocus(widget.addSalesBloc.discountFocus);
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TldsInputFormField(
              enabled: false,
              inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
              hintText: AppConstants.sgstPercent,
              controller: widget.addSalesBloc.cgstPresentageTextController,
            ),
          ),
        ],
      ),
    );
  }

  void _calculateGST() {
    double totalValues = widget.addSalesBloc.totalValue ?? 0;
    double cgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;
    double sgstPercent = double.tryParse(
            widget.addSalesBloc.cgstPresentageTextController.text) ??
        0;

    widget.addSalesBloc.taxableValue = totalValues;
    widget.addSalesBloc.cgstAmount = (totalValues / 100) * cgstPercent;
    widget.addSalesBloc.sgstAmount = (totalValues / 100) * sgstPercent;

    double taxableValue = widget.addSalesBloc.taxableValue ?? 0;
    widget.addSalesBloc.invAmount =
        taxableValue + (widget.addSalesBloc.sgstAmount ?? 0 * 2);
    _updateTotalInvoiceAmount();

    widget.addSalesBloc.paymentDetailsStreamController(true);
    widget.addSalesBloc.gstRadioBtnRefreashStreamController(true);
  }

  void _updateTotalInvoiceAmount() {
    double? empsIncValue =
        double.tryParse(widget.addSalesBloc.empsIncentiveTextController.text) ??
            0.0;
    double? stateIncValue = double.tryParse(
            widget.addSalesBloc.stateIncentiveTextController.text) ??
        0.0;

    double totalIncentive = empsIncValue + stateIncValue;

    if ((widget.addSalesBloc.invAmount ?? 0) != -1) {
      widget.addSalesBloc.totalInvAmount =
          (widget.addSalesBloc.invAmount ?? 0) - totalIncentive;
    } else {
      widget.addSalesBloc.totalInvAmount = 0.0;
    }

    double advanceAmt = widget.addSalesBloc.advanceAmt ?? 0;
    double totalInvAmt = widget.addSalesBloc.totalInvAmount ?? 0;
    widget.addSalesBloc.toBePayedAmt = totalInvAmt - advanceAmt;

    widget.addSalesBloc.paymentDetailsStreamController(true);
  }

  Widget _buildHeadingText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: _appColors.primaryColor),
    );
  }

  Widget _buildIgstPercentField() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: TldsInputFormField(
              inputFormatters: TlInputFormatters.onlyAllowDecimalNumbers,
              hintText: AppConstants.igstPercent,
              controller: widget.addSalesBloc.igstPresentageTextController,
              focusNode: widget.addSalesBloc.igstFocus,
              onChanged: (igst) {
                double igstPersent = double.parse(igst);
                widget.addSalesBloc.paymentDetailsStreamController(true);
                widget.addSalesBloc.gstRadioBtnRefreashStreamController(true);
                double unitRate = widget.addSalesBloc.totalUnitRate ?? 0;
                widget.addSalesBloc.paymentDetailsStreamController(true);
                widget.addSalesBloc.igstAmount = (unitRate / 10) * igstPersent;
                widget.addSalesBloc.paymentDetailsStreamController(true);
                double taxableValue = widget.addSalesBloc.taxableValue ?? 0;
                widget.addSalesBloc.paymentDetailsStreamController(true);
                widget.addSalesBloc.invAmount =
                    taxableValue + (widget.addSalesBloc.sgstAmount ?? 0 * 2);
                widget.addSalesBloc.paymentDetailsStreamController(true);
                _updateTotalInvoiceAmount();
                widget.addSalesBloc.paymentDetailsStreamController(true);

                // print('IGST changed: $igst');
              },
              onSubmit: (value) {
                FocusScope.of(context)
                    .requestFocus(widget.addSalesBloc.discountFocus);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return StreamBuilder(
        stream: widget.addSalesBloc.paymentDetailsStream,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.sizeOf(context).width * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentDetailTile(
                    AppConstants.totalValue,
                    Text(
                      widget.addSalesBloc.selectedVehiclesList!.isNotEmpty
                          ? AppUtils.formatCurrency(
                              widget.addSalesBloc.totalValue ?? 0.0)
                          : '₹0.0',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subTitle: AppConstants.totalValueA),
                _buildPaymentDetailTile(
                  AppConstants.discount,
                  subTitle: AppConstants.discountB,
                  TldsInputFormField(
                    hintText: AppConstants.rupeeHint,
                    inputFormatters:
                        TldsInputFormatters.onlyAllowDecimalNumbers,
                    width: 100,
                    height: 40,
                    controller: widget.addSalesBloc.discountTextController,
                    focusNode: widget.addSalesBloc.discountFocus,
                    onChanged: (discount) {
                      double? discountAmount = double.tryParse(discount);

                      if (widget.addSalesBloc.totalValue != 0) {
                        widget.addSalesBloc.taxableValue =
                            (widget.addSalesBloc.totalValue ?? 0) -
                                (discountAmount ?? 0);

                        widget.addSalesBloc.totalInvAmount =
                            ((widget.addSalesBloc.invAmount ?? 0) -
                                (discountAmount ?? 0));
                      }

                      widget.addSalesBloc.paymentDetailsStreamController(true);
                    },
                    onSubmit: (value) {
                      FocusScope.of(context)
                          .requestFocus(widget.addSalesBloc.empsIncentiveFocus);
                    },
                  ),
                ),
                _buildPaymentDetailTile(
                    AppConstants.taxableValue,
                    subTitle: AppConstants.taxableValueAB,
                    Text(
                      AppUtils.formatCurrency(
                          widget.addSalesBloc.taxableValue ?? 0.0),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Text(
                  AppConstants.gstThree,
                  style: TextStyle(
                      color: _appColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                Container(
                    decoration: BoxDecoration(
                        color: _appColors.hightlightColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Visibility(
                          visible: widget.addSalesBloc.selectedGstType ==
                              AppConstants.igstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.igstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    widget.addSalesBloc.igstAmount ?? 0.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ),
                        Visibility(
                          visible: widget.addSalesBloc.selectedGstType ==
                              AppConstants.gstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.cgstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    widget.addSalesBloc.cgstAmount ?? 0.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ),
                        Visibility(
                          visible: widget.addSalesBloc.selectedGstType ==
                              AppConstants.gstPercent,
                          child: _buildPaymentDetailTile(
                              AppConstants.sgstAmount,
                              Text(
                                AppUtils.formatCurrency(
                                    widget.addSalesBloc.sgstAmount ?? 0.0),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    )),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildPaymentDetailTile(
                    AppConstants.invoiceValue,
                    subTitle: AppConstants.invoiceValueThree,
                    Text(
                      AppUtils.formatCurrency(
                          widget.addSalesBloc.invAmount ?? 0.0),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                _buildPaymentDetailTile(
                    AppConstants.empsIncentive,
                    subTitle: AppConstants.empsIncentiveFour,
                    TldsInputFormField(
                      hintText: AppConstants.rupeeHint,
                      inputFormatters:
                          TldsInputFormatters.onlyAllowDecimalNumbers,
                      focusNode: widget.addSalesBloc.empsIncentiveFocus,
                      width: 100,
                      height: 40,
                      controller:
                          widget.addSalesBloc.empsIncentiveTextController,
                      onChanged: (empsInc) {
                        _updateTotalInvoiceAmount();
                      },
                      onSubmit: (value) {
                        FocusScope.of(context).requestFocus(
                            widget.addSalesBloc.stateIncentiveFocus);
                      },
                    )),
                _buildPaymentDetailTile(
                    AppConstants.stateIncentive,
                    subTitle: AppConstants.stateIncentiveFive,
                    TldsInputFormField(
                      hintText: AppConstants.rupeeHint,
                      inputFormatters:
                          TldsInputFormatters.onlyAllowDecimalNumbers,
                      focusNode: widget.addSalesBloc.stateIncentiveFocus,
                      width: 100,
                      height: 40,
                      controller:
                          widget.addSalesBloc.stateIncentiveTextController,
                      onChanged: (stateInc) {
                        _updateTotalInvoiceAmount();
                      },
                    )),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                ListTile(
                  title: const Text(AppConstants.totalInvoiceAmount,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    AppConstants.totalInvoiceAmountCalTwo,
                    style: TextStyle(color: _appColors.grey),
                  ),
                  trailing: Text(
                    AppUtils.formatCurrency(
                        widget.addSalesBloc.totalInvAmount ?? 0.0),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                Container(
                  decoration: BoxDecoration(
                      color: _appColors.amountBgColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Text(
                      AppConstants.bookAdvAmt,
                      style: TextStyle(
                          fontSize: 16, color: _appColors.primaryColor),
                    ),
                    // tileColor: _appColors.primaryColor,
                    trailing: Text(
                      '₹0.0',
                      style: TextStyle(
                          color: _appColors.primaryColor, fontSize: 16),
                    ),
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                Container(
                  decoration: BoxDecoration(
                      color: _appColors.transparentGreenColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: const ListTile(
                    title: Text(
                      AppConstants.toBePayed,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    // tileColor: _appColors.primaryColor,
                    trailing: Text(
                      '₹0.0',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildPaymentOptions(),
                AppWidgetUtils.buildSizedBox(custHeight: 10),
                _buildSplitPayment(),
                _buildSaveBtn(),
              ],
            ),
          );
        });
  }

  Widget _buildPaymentDetailTile(String? title, Widget? textField,
      {String? subTitle}) {
    return ListTile(
        title: Row(
          children: [
            Text(
              title ?? '',
              style: TextStyle(color: _appColors.greyColor),
            ),
            AppWidgetUtils.buildSizedBox(custWidth: 5),
            Text(
              subTitle ?? '',
              style: TextStyle(color: _appColors.greyColor, fontSize: 14),
            ),
          ],
        ),
        trailing: textField ?? const SizedBox.shrink());
  }

  Widget _buildPaymentOptions() {
    return StreamBuilder<bool>(
        stream: widget.addSalesBloc.paymentOptionStream,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: widget.addSalesBloc.getPaymentmethods(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 250,
                  child: ListView.separated(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) => _buildCustomRadioTile(
                      value: snapshot.data?[index].toString() ?? '',
                      groupValue: widget.addSalesBloc.selectedPaymentOption,
                      onChanged: (value) {
                        widget.addSalesBloc.selectedPaymentOption = value!;
                        widget.addSalesBloc.paymentOptionStreamController(true);
                      },
                      icon: Icons.payment,
                      label: snapshot.data?[index].toUpperCase() ?? '',
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return AppWidgetUtils.buildSizedBox(custHeight: 8);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('No Payment Methods Available'),
                );
              }
            },
          );
        });
  }

  Widget _buildCustomRadioTile({
    required String value,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required String label,
  }) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 180,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : _appColors.greyColor,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                icon,
                color:
                    isSelected ? _appColors.primaryColor : _appColors.greyColor,
              ),
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 16.0,
                    color: isSelected
                        ? _appColors.primaryColor
                        : _appColors.greyColor),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  _buildSplitPayment() {
    return Column(
      children: [
        StreamBuilder<bool>(
            stream: widget.addSalesBloc.isSplitPaymentStream,
            builder: (context, snapshot) {
              return Row(
                children: [
                  Switch(
                    value: widget.addSalesBloc.isSplitPayment,
                    onChanged: (value) {
                      widget.addSalesBloc.isSplitPayment = value;
                      widget.addSalesBloc.isSplitPaymentStreamController(true);
                    },
                  ),
                  const Text(
                    AppConstants.splitPayment,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              );
            }),
        // CheckboxListTile(
        //   title: const Text("title text"),
        //   value: true,
        //   onChanged: (newValue) {},
        //   controlAffinity: ListTileControlAffinity.leading,
        // )
      ],
    );
  }

  _buildSaveBtn() {
    return CustomActionButtons(
        onPressed: () {
          if (widget.addSalesBloc.paymentFormKey.currentState!.validate()) {
            if (widget.addSalesBloc.selectedVehiclesList!.isEmpty ||
                widget.addSalesBloc.accessoriesData!.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    surfaceTintColor: _appColors.whiteColor,
                    title: const Text('selected vehicle or accessories'),
                    // content: const Text(AppConstants.alertContent),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('ok'),
                      ),
                    ],
                  );
                },
              );
            }
            //  print('ok');
          }
        },
        buttonText: AppConstants.save);
  }
}
