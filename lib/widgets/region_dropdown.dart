import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:region_and_country_dropdown/models/region_model.dart';
import 'package:region_and_country_dropdown/providers/region_and_country_provider.dart';

class RegionDropdown extends StatefulWidget {
  final Function(RegionModel?) onChanged;
  final String? label;
  final bool? disabled;
  final String? hintText;
  final String? searchText;
  final bool? isMixWithRegion;

  const RegionDropdown(
      {Key? key,
        required this.onChanged,
        this.disabled,
        this.label,
        this.hintText,
        this.searchText,
        this.isMixWithRegion})
      : super(key: key);

  @override
  State<RegionDropdown> createState() => _RegionDropdownState();
}

class _RegionDropdownState extends State<RegionDropdown> {
  bool reset = false;

  @override
  Widget build(BuildContext context) {
    var sc = RegionAndCountryProvider.of(context).currentCountry;
    return (sc == null && widget.isMixWithRegion == true)
        ? AbsorbPointer(
      child: FindDropdown<RegionModel>(
        label: widget.label,
        items: const [],
        onChanged: (RegionModel? data) {},
        dropdownBuilder: _buidlItemView,
        searchHint: widget.searchText,
      ),
    )
        : FindDropdown<RegionModel>(
      label: widget.label,
      onFind: onFind,
      onChanged: (RegionModel? data) {
        RegionAndCountryProvider.of(context).previousUniqid =
            RegionAndCountryProvider.of(context).uniqId;
        setState(() {});
        widget.onChanged(data);
      },
      dropdownBuilder: _buidlItemView,
      dropdownItemBuilder: _dropdownBuilder,
      searchHint: widget.searchText,
    );
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
    if (RegionAndCountryProvider.of(context).currentCountry == null) {
      return regions;
    }
    var filtered = regions?.where((e) {
      var sc = RegionAndCountryProvider.of(context).currentCountry;
      return e.country == sc?.alpha2;
    }).toList() as List<RegionModel>;
    return filtered;
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
    if (RegionAndCountryProvider.of(context).uniqId !=
        RegionAndCountryProvider.of(context).previousUniqid) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(
              title: Text(
                widget.hintText ?? "Choose a state",
              )));
    }

    if (item != null) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(
              title: Text(
                item.name,
              )));
    }
    if (RegionAndCountryProvider.of(context).currentCountry == null &&
        item != null) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(title: Text(item.name)));
    }
    if (RegionAndCountryProvider.of(context).currentCountry == null &&
        item == null &&
        widget.isMixWithRegion != true) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ListTile(
              title: Text(
                widget.hintText ?? "Choose a state",
              )));
    }
    return Container(
        decoration: BoxDecoration(
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
}
