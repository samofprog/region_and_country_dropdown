import 'dart:convert';

import 'package:flutter/services.dart';

class CountryModel {
  final String? flag;
  final String? alpha2;
  String? translatedName;
  final String ar;
  final String bg;
  final String cs;
  final String da;
  final String de;
  final String el;
  final String en;
  final String eo;
  final String es;
  final String et;
  final String eu;
  final String fi;
  final String fr;
  final String hu;
  final String it;
  final String ja;
  final String ko;
  final String lt;
  final String nl;
  final String no;
  final String pl;
  final String pt;
  final String ro;
  final String ru;
  final String sk;
  final String sv;
  final String th;
  final String uk;
  final String zh;
  final String zhTw;

  CountryModel(
      {required this.ar,
        required this.bg,
        required this.cs,
        required this.da,
        required this.de,
        required this.el,
        required this.en,
        required this.eo,
        required this.es,
        required this.et,
        required this.eu,
        required this.fi,
        required this.fr,
        required this.hu,
        required this.it,
        required this.ja,
        required this.ko,
        required this.lt,
        required this.nl,
        required this.no,
        required this.pl,
        required this.pt,
        required this.ro,
        required this.ru,
        required this.sk,
        required this.sv,
        required this.th,
        required this.uk,
        required this.zh,
        required this.zhTw,
        required this.alpha2,
        required this.flag});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
        ar: json['ar'],
        bg: json['bg'],
        cs: json['cs'],
        da: json['da'],
        de: json['de'],
        el: json['el'],
        en: json['en'],
        eo: json['eo'],
        es: json['es'],
        et: json['et'],
        eu: json['eu'],
        fi: json['fi'],
        fr: json['fr'],
        hu: json['hu'],
        it: json['it'],
        ja: json['ja'],
        ko: json['ko'],
        lt: json['lt'],
        nl: json['nl'],
        no: json['no'],
        pl: json['pl'],
        pt: json['pt'],
        ro: json['ro'],
        ru: json['ru'],
        sk: json['sk'],
        sv: json['sv'],
        th: json['th'],
        uk: json['uk'],
        zh: json['zh'],
        zhTw: json['zhTw'],
        alpha2: json['alpha2'],
        flag: json['flag']);
  }

  Map toJson() => {
    "ar": ar,
    "bg": bg,
    "cs": cs,
    "da": da,
    "de": de,
    "el": el,
    "en": en,
    "eo": eo,
    "es": es,
    "et": et,
    "eu": eu,
    "fi": fi,
    "fr": fr,
    "hu": hu,
    "it": it,
    "ja": ja,
    "ko": ko,
    "lt": lt,
    "nl": nl,
    "no": no,
    "pl": pl,
    "pt": pt,
    "ro": ro,
    "ru": ru,
    "sk": sk,
    "sv": sv,
    "th": th,
    "uk": uk,
    "zh": zh,
    "zh-tw": zhTw,
  };

  @override
  String toString() {
    return translatedName ?? '';
  }

  static Future<List<CountryModel>> load() async {
    final String response = await rootBundle.loadString(
        'packages/region_and_country_dropdown/assets/countries/_.json');
    final data = await json.decode(response);
    return data.map<CountryModel>((c) {
      var flag = c['alpha2'];
      flag =
      'packages/region_and_country_dropdown/assets/countries/flags/$flag.svg';
      return CountryModel(
          ar: c['ar'],
          bg: c['bg'],
          cs: c['cs'],
          da: c['da'],
          de: c['de'],
          el: c['el'],
          en: c['en'],
          eo: c['eo'],
          es: c['es'],
          et: c['et'],
          eu: c['eu'],
          fi: c['fi'],
          fr: c['fr'],
          hu: c['hu'],
          it: c['it'],
          ja: c['ja'],
          ko: c['ko'],
          lt: c['lt'],
          nl: c['nl'],
          no: c['no'],
          pl: c['pl'],
          pt: c['pt'],
          ro: c['ro'],
          ru: c['ru'],
          sk: c['sk'],
          sv: c['sv'],
          th: c['th'],
          uk: c['uk'],
          zh: c['zh'],
          zhTw: c['zh-tw'],
          alpha2: c['alpha2'],
          flag: flag);
    }).toList();
  }
}

class RegionModel {
  final String name;
  final String country;

  RegionModel({required this.name, required this.country});

  @override
  String toString() {
    return name;
  }

  static load() async {
    final String response = await rootBundle.loadString(
        'packages/region_and_country_dropdown/assets/countries/state.json');
    final data = await json.decode(response);
    return data.map<RegionModel>((cs) {
      return RegionModel(
          name: cs['name'], country: cs['country'].toLowerCase());
    }).toList();
  }
}
