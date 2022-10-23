// ignore_for_file: deprecated_member_use

import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:region_and_country_dropdown/models/country_model.dart';
import 'package:region_and_country_dropdown/models/region_model.dart';
import 'package:region_and_country_dropdown/widgets/region_dropdown.dart';
import 'package:region_and_country_dropdown/providers/region_and_country_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegionAndCountryDropdown extends StatefulWidget {
  final Function(CountryModel? country, RegionModel? countryState) onChanged;
  final String? countryLabel;
  final String? searchCountryHintText;
  final String? regionLabel;
  final String? searchRegionHintText;
  final bool? onlyEnableCountryDropdown;
  final bool? onlyEnableRegionDropdown;
  final String? regionHintText;
  final String? countryHintText;
  final Widget Function(BuildContext)? countryEmptyBuilder;
  final Widget Function(BuildContext)? regionEmptyBuilder;
  final String? lang;
  final BoxDecoration? countryBoxDecoration;
  final BoxDecoration? regionBoxDecoration;
  final String? countryRequiredErrorMessage;
  final String? regionRequiredErrorMessage;
  final CountryModel? countrySelected;
  final RegionModel? regionSelected;

  const RegionAndCountryDropdown({
    Key? key,
    required this.onChanged,
    this.onlyEnableCountryDropdown,
    this.onlyEnableRegionDropdown,
    this.lang,
    this.countryLabel,
    this.searchCountryHintText,
    this.regionLabel,
    this.searchRegionHintText,
    this.regionHintText,
    this.countryHintText,
    this.countryEmptyBuilder,
    this.regionEmptyBuilder,
    this.countryBoxDecoration,
    this.regionBoxDecoration,
    this.countryRequiredErrorMessage,
    this.regionRequiredErrorMessage, this.countrySelected, this.regionSelected,
  }) : super(key: key);

  @override
  State<RegionAndCountryDropdown> createState() =>
      _RegionAndCountryDropdownState();
}

class _RegionAndCountryDropdownState extends State<RegionAndCountryDropdown> {
  CountryModel? _selectedCountry;
  RegionModel? selectedItem;
  String uniqId = const Uuid().v4();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.onlyEnableCountryDropdown ?? false) {
      if (widget.countryRequiredErrorMessage != null &&
          widget.countryRequiredErrorMessage?.isNotEmpty == true) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FindDropdown<CountryModel>(
              label: widget.countryLabel,
              onFind: onFind,
              items: getData(widget.lang),
              onChanged: (CountryModel? data) {
                widget.onChanged(data, null);
              },
              selectedItem: widget.countrySelected ,
              dropdownBuilder: _buidlItemView,
              dropdownItemBuilder: _dropdownBuilder,
              searchHint: widget.searchCountryHintText,
              emptyBuilder: widget.countryEmptyBuilder,
            ),
            Padding(
              padding: const EdgeInsets.only(top:7,bottom: 9.0,left: 15.0),
              child: Text(widget.countryRequiredErrorMessage ?? '',style: const TextStyle(color: Colors.red,height: 0.7,fontSize: 13),),
            ),
          ],
        );
      }
      return FindDropdown<CountryModel>(
        label: widget.countryLabel,
        onFind: onFind,
        items: getData(widget.lang),
        onChanged: (CountryModel? data) {
          widget.onChanged(data, null);
        },
        dropdownBuilder: _buidlItemView,
        dropdownItemBuilder: _dropdownBuilder,
        searchHint: widget.searchCountryHintText,
        emptyBuilder: widget.countryEmptyBuilder,
        selectedItem: widget.countrySelected ,
      );
    }
    if (widget.onlyEnableRegionDropdown ?? false) {
      if (widget.regionRequiredErrorMessage != null &&
          widget.regionRequiredErrorMessage?.isNotEmpty == true) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RegionDropdown(
              onChanged: (value) {
                widget.onChanged(null, value);
              },
              disabled: false,
              label: widget.regionLabel,
              searchText: widget.searchRegionHintText,
              hintText: widget.regionHintText,
              emptyBuilder: widget.regionEmptyBuilder,
              boxDecoration: widget.regionBoxDecoration,
              selectedItem: widget.regionSelected,
            ),
            Padding(
              padding: const EdgeInsets.only(top:7,bottom: 9.0,left: 15.0),
              child: Text(widget.regionRequiredErrorMessage ?? '',style: const TextStyle(color: Colors.red,height: 0.7,fontSize: 13),),
            ),
          ],
        );
      }
      return RegionDropdown(
        onChanged: (value) {
          widget.onChanged(null, value);
        },
        disabled: false,
        label: widget.regionLabel,
        searchText: widget.searchRegionHintText,
        hintText: widget.regionHintText,
        emptyBuilder: widget.regionEmptyBuilder,
        boxDecoration: widget.regionBoxDecoration,
        selectedItem: widget.regionSelected,
      );
    }
    if ((widget.regionRequiredErrorMessage != null &&
            widget.regionRequiredErrorMessage != null) ||
        widget.regionRequiredErrorMessage?.isNotEmpty == true &&
            widget.countryRequiredErrorMessage?.isNotEmpty == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FindDropdown<CountryModel>(
            label: widget.countryLabel,
            onChanged: (CountryModel? data) {
              var previous =
                  RegionAndCountryProvider.of(context).previousCountry =
                      RegionAndCountryProvider.of(context).currentCountry;
              var current =
                  RegionAndCountryProvider.of(context).currentCountry = data;
              RegionAndCountryProvider.of(context).previousUniqid =
                  RegionAndCountryProvider.of(context).uniqId;
              RegionAndCountryProvider.of(context).uniqId = const Uuid().v4();
              if (current != previous) {
                setState(() {
                  _selectedCountry = data;
                });
              }
              widget.onChanged(_selectedCountry, null);
            },
            items: getData(widget.lang),
            onFind: onFind,
            dropdownBuilder: _buidlItemView,
            emptyBuilder: widget.regionEmptyBuilder,
            dropdownItemBuilder: _dropdownBuilder,
            searchHint: widget.searchCountryHintText,
            selectedItem: widget.countrySelected,
          ),
          Padding(
            padding: const EdgeInsets.only(top:7,bottom: 9.0,left: 15.0),
            child: Text(widget.countryRequiredErrorMessage ?? '',style: const TextStyle(color: Colors.red,height: 0.7,fontSize: 13),),
          ),
          RegionDropdown(
            onChanged: (RegionModel? region) {
              widget.onChanged(_selectedCountry, region);
            },
            label: widget.regionLabel,
            searchText: widget.searchRegionHintText,
            hintText: widget.regionHintText,
            isMixWithRegion: true,
            emptyBuilder: widget.regionEmptyBuilder,
            boxDecoration: widget.regionBoxDecoration,
            selectedItem: widget.regionSelected,
          ),
          Padding(
            padding: const EdgeInsets.only(top:7,bottom: 9.0,left: 15.0),
            child: Text(widget.regionRequiredErrorMessage ?? '',style: const TextStyle(color: Colors.red,height: 0.7,fontSize: 13),),
          )
        ],
      );
    }
    if ((widget.regionRequiredErrorMessage != null &&
        widget.regionRequiredErrorMessage?.isNotEmpty == true)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FindDropdown<CountryModel>(
            label: widget.countryLabel,
            onChanged: (CountryModel? data) {
              var previous =
                  RegionAndCountryProvider.of(context).previousCountry =
                      RegionAndCountryProvider.of(context).currentCountry;
              var current =
                  RegionAndCountryProvider.of(context).currentCountry = data;
              RegionAndCountryProvider.of(context).previousUniqid =
                  RegionAndCountryProvider.of(context).uniqId;
              RegionAndCountryProvider.of(context).uniqId = const Uuid().v4();
              if (current != previous) {
                setState(() {
                  _selectedCountry = data;
                });
              }
              widget.onChanged(_selectedCountry, null);
            },
            items: getData(widget.lang),
            onFind: onFind,
            dropdownBuilder: _buidlItemView,
            emptyBuilder: widget.regionEmptyBuilder,
            dropdownItemBuilder: _dropdownBuilder,
            searchHint: widget.searchCountryHintText,
            selectedItem: widget.countrySelected,
          ),
          RegionDropdown(
            onChanged: (RegionModel? region) {
              widget.onChanged(_selectedCountry, region);
            },
            label: widget.regionLabel,
            searchText: widget.searchRegionHintText,
            hintText: widget.regionHintText,
            isMixWithRegion: true,
            emptyBuilder: widget.regionEmptyBuilder,
            boxDecoration: widget.regionBoxDecoration,
            selectedItem: widget.regionSelected,
          ),
          Padding(
            padding: const EdgeInsets.only(top:7,bottom: 9.0,left: 15.0),
            child: Text(widget.regionRequiredErrorMessage ?? '',style: const TextStyle(color: Colors.red,height: 0.7,fontSize: 13),),
          ),
        ],
      );
    }
    if ((widget.countryRequiredErrorMessage != null &&
        widget.countryRequiredErrorMessage?.isNotEmpty == true)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FindDropdown<CountryModel>(
            label: widget.countryLabel,
            onChanged: (CountryModel? data) {
              var previous =
                  RegionAndCountryProvider.of(context).previousCountry =
                      RegionAndCountryProvider.of(context).currentCountry;
              var current =
                  RegionAndCountryProvider.of(context).currentCountry = data;
              RegionAndCountryProvider.of(context).previousUniqid =
                  RegionAndCountryProvider.of(context).uniqId;
              RegionAndCountryProvider.of(context).uniqId = const Uuid().v4();
              if (current != previous) {
                setState(() {
                  _selectedCountry = data;
                });
              }
              widget.onChanged(_selectedCountry, null);
            },
            items: getData(widget.lang),
            onFind: onFind,
            dropdownBuilder: _buidlItemView,
            emptyBuilder: widget.regionEmptyBuilder,
            dropdownItemBuilder: _dropdownBuilder,
            searchHint: widget.searchCountryHintText,
            selectedItem: widget.countrySelected,
          ),
          Padding(
            padding: const EdgeInsets.only(top:7,bottom: 9.0,left: 15.0),
            child: Text(widget.countryRequiredErrorMessage ?? '',
              style: const TextStyle(color: Colors.red,
                  height: 0.7,fontSize: 13)),
          ),
          RegionDropdown(
            onChanged: (RegionModel? region) {
              widget.onChanged(_selectedCountry, region);
            },
            label: widget.regionLabel,
            searchText: widget.searchRegionHintText,
            hintText: widget.regionHintText,
            isMixWithRegion: true,
            emptyBuilder: widget.regionEmptyBuilder,
            boxDecoration: widget.regionBoxDecoration,
            selectedItem: widget.regionSelected,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FindDropdown<CountryModel>(
          label: widget.countryLabel,
          onChanged: (CountryModel? data) {
            var previous =
                RegionAndCountryProvider.of(context).previousCountry =
                    RegionAndCountryProvider.of(context).currentCountry;
            var current =
                RegionAndCountryProvider.of(context).currentCountry = data;
            RegionAndCountryProvider.of(context).previousUniqid =
                RegionAndCountryProvider.of(context).uniqId;
            RegionAndCountryProvider.of(context).uniqId = const Uuid().v4();
            if (current != previous) {
              setState(() {
                _selectedCountry = data;
              });
            }
            widget.onChanged(_selectedCountry, null);
          },
          items: getData(widget.lang),
          onFind: onFind,
          dropdownBuilder: _buidlItemView,
          emptyBuilder: widget.regionEmptyBuilder,
          dropdownItemBuilder: _dropdownBuilder,
          searchHint: widget.searchCountryHintText,
          selectedItem: widget.countrySelected
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: RegionDropdown(
            onChanged: (RegionModel? region) {
              widget.onChanged(_selectedCountry, region);
            },
            label: widget.regionLabel,
            searchText: widget.searchRegionHintText,
            hintText: widget.regionHintText,
            isMixWithRegion: true,
            emptyBuilder: widget.regionEmptyBuilder,
            boxDecoration: widget.regionBoxDecoration,
            selectedItem: widget.regionSelected,
          ),
        ),
      ],
    );
  }

  Widget _dropdownBuilder(
      BuildContext context, CountryModel item, bool isSelected) {
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
        title: Text(item.translatedName ?? ''),
        leading: SizedBox(
          width: 30,
          height: 30,
          child: ClipOval(
            child: SvgPicture.asset(
              item.flag?.replaceAll(':', 's:') ?? '',
              width: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buidlItemView(BuildContext context, CountryModel? item) {
    return Container(
      decoration: widget.countryBoxDecoration ??
          BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
      child: (item?.flag == null)
          ? ListTile(
              leading: const Icon(Icons.flag),
              title: Text(widget.countryHintText ?? "Choose a country"))
          : ListTile(
              leading: SizedBox(
                width: 30,
                height: 30,
                child: ClipOval(
                  child: SvgPicture.asset(
                    item?.flag?.replaceAll(':', 's:') ?? '',
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(item?.translatedName ?? ''),
            ),
    );
  }

  List<CountryModel>? getData(String? lang) {
    if (lang != null) {
      return RegionAndCountryProvider.of(context).countries?.map((c) {
        var json = c.toJson();
        c.translatedName = json[lang] ?? json['en'];
        return c;
      }).toList();
    }
    return RegionAndCountryProvider.of(context).countries?.map((c) {
      var json = c.toJson();
      c.translatedName = json['en'];
      return c;
    }).toList();
  }

  Future<List<CountryModel>> onFind(String value) async {
    _controller.text = value;
    setState(() {});
    if (value.isEmpty == false) {
      var filtered = getData(widget.lang)?.where((e) =>
          e.translatedName
              ?.toLowerCase()
              .contains(value.trim().toLowerCase()) ==
          true);
      return filtered?.toList() ?? [];
    }
    return getData(widget.lang) ?? [];
  }
}
