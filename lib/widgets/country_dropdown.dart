// ignore_for_file: deprecated_member_use

import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:region_and_country_dropdown/models/country_model.dart';
import 'package:region_and_country_dropdown/models/region_model.dart';
import 'package:region_and_country_dropdown/providers/region_and_country_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CountryDropdown extends StatefulWidget {
  final Function(CountryModel? country) onChanged;
  final String? label;
  final String? searchHintText;
  final String? hintText;
  final Widget Function(BuildContext)? emptyBuilder;
  final String? lang;
  final BoxDecoration? boxDecoration;
  final String? requiredErrorMessage;

  const CountryDropdown({
    Key? key,
    required this.onChanged,
    this.lang,
    this.emptyBuilder,
    this.label,
    this.searchHintText,
    this.hintText,
    this.boxDecoration,
    this.requiredErrorMessage,
  }) : super(key: key);

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  RegionModel? selectedItem;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.requiredErrorMessage != null &&
        widget.requiredErrorMessage?.isEmpty == true) {
      return FindDropdown<CountryModel>(
        onChanged: (selectedItem) async {
          widget.onChanged(selectedItem);
        },
        onFind: onFind,
        items: getData(widget.lang),
        dropdownBuilder: _buidlItemView,
        dropdownItemBuilder: _dropdownBuilder,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FindDropdown<CountryModel>(
          onChanged: (selectedItem) async {
            widget.onChanged(selectedItem);
          },
          onFind: onFind,
          items: getData(widget.lang),
          dropdownBuilder: _buidlItemView,
          dropdownItemBuilder: _dropdownBuilder,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(widget.requiredErrorMessage ?? '',style: TextStyle(color: Theme.of(context).errorColor),),
        )
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
      decoration: widget.boxDecoration ??
          BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
      child: (item?.flag == null)
          ? ListTile(
              leading: const Icon(Icons.flag),
              title: Text(widget.hintText ?? "Choose a country"))
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
