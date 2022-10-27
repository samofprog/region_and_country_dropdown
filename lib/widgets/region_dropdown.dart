// ignore_for_file: deprecated_member_use

import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:region_and_country_dropdown/models/country_model.dart';
import 'package:region_and_country_dropdown/models/region_model.dart';
import 'package:region_and_country_dropdown/providers/region_and_country_provider.dart';

class RegionDropdown extends StatefulWidget {
  final Function(RegionModel?) onChanged;
  final String? label;
  final bool? disabled;
  final String? hintText;
  final String? searchText;
  final bool? isMixWithCountry;
  final Widget Function(BuildContext)? emptyBuilder;
  final BoxDecoration? boxDecoration;
  final RegionModel? selectedItem;
  final CountryModel? selectedCountry;
  final String? requiredErrorMessage;

  const RegionDropdown(
      {Key? key,
      required this.onChanged,
      this.disabled,
      this.label,
      this.hintText,
      this.searchText,
      this.isMixWithCountry,
      this.emptyBuilder,
      this.boxDecoration,
      this.selectedItem,
      this.selectedCountry,
      this.requiredErrorMessage})
      : super(key: key);

  @override
  State<RegionDropdown> createState() => _RegionDropdownState();
}

class _RegionDropdownState extends State<RegionDropdown> {
  @override
  Widget build(BuildContext context) {
    if(widget.selectedCountry == null && widget.isMixWithCountry == true){
       if(widget.requiredErrorMessage != null &&
           widget.requiredErrorMessage?.isEmpty == false){
         return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
           AbsorbPointer(
             child: FindDropdown<RegionModel>(
               label: widget.label,
               items: const [],
               onChanged: (RegionModel? data) {},
               dropdownBuilder: _buidlItemView,
               searchHint: widget.searchText,
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 12.0),
             child: Text(
               widget.requiredErrorMessage ?? '',
               style: TextStyle(color: Theme.of(context).errorColor),
             ),
           )
         ],);
       }
       return AbsorbPointer(
         child: FindDropdown<RegionModel>(
           label: widget.label,
           items: const [],
           onChanged: (RegionModel? data) {},
           dropdownBuilder: _buidlItemView,
           searchHint: widget.searchText,
         ),
       );
    }
    if(widget.requiredErrorMessage != null &&
        widget.requiredErrorMessage?.isEmpty == false){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FindDropdown<RegionModel>(
              label: widget.label,
              onFind: onFind,
              items:
              filter(RegionAndCountryProvider.of(context).regions),
              onChanged: (RegionModel? data) async {
                widget.onChanged(data);
              },
              dropdownBuilder: _buidlItemView,
              dropdownItemBuilder: _dropdownBuilder,
              searchHint: widget.searchText,
              emptyBuilder: widget.emptyBuilder,
              selectedItem: widget.selectedItem),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              widget.requiredErrorMessage ?? '',
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
          )
        ],
      );
    }
    return FindDropdown<RegionModel>(
        label: widget.label,
        onFind: onFind,
        items:
        filter(RegionAndCountryProvider.of(context).regions),
        onChanged: (RegionModel? data) async {
          widget.onChanged(data);
        },
        dropdownBuilder: _buidlItemView,
        dropdownItemBuilder: _dropdownBuilder,
        searchHint: widget.searchText,
        emptyBuilder: widget.emptyBuilder,
        selectedItem: widget.selectedItem);
  }

  Future<List<RegionModel>> onFind(String value) async {
    var regions = filter(RegionAndCountryProvider.of(context).regions);
    if (value.isEmpty == false) {
      var filtered = regions?.where((e) =>
          e.name.toLowerCase().contains(value.trim().toLowerCase()) == true);
      return filtered?.toList() ?? [];
    }
    return regions ?? [];
  }

  List<RegionModel>? filter(List<RegionModel>? regions) {
    if (widget.selectedCountry != null) {
      var filtered = regions?.where((e) {
        var sc = widget.selectedCountry;
        return e.country == sc?.alpha2;
      }).toList() as List<RegionModel>;
      return filtered;
    }
    return regions;
  }

  Widget _dropdownBuilder(
      BuildContext context, RegionModel item, bool isSelected) {
    return Container(
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.name ?? ''),
      ),
    );
  }

  Widget _buidlItemView(BuildContext context, RegionModel? item) {
    if (item != null && widget.selectedItem != null) {
      return Container(
          decoration: widget.boxDecoration ??
              BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
          child: ListTile(title: Text(item.name)));
    }
    if (widget.selectedCountry == null && widget.isMixWithCountry == true) {
      return Container(
          decoration: widget.boxDecoration ??
              BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
          child: ListTile(
              title: Text(
            widget.hintText ?? "Choose a state",
            style: TextStyle(color: Theme.of(context).disabledColor),
          )));
    }
    return Container(
        decoration: widget.boxDecoration ??
            BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
        child: ListTile(
            title: Text(
          widget.hintText ?? "Choose a state",
        )));
  }
}
