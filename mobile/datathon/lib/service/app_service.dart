import 'dart:convert';

import 'package:http/http.dart' as http;

final class AppService {
  Future<ResponsePlace> getPlace(double lat, double lon) async {
    String url =
        "https://7e34-84-51-15-243.ngrok-free.app/get_neighborhood_info?lat=${lat}&long=${lon}";
    final response = await http.get(Uri.parse(url));
    final jsonresponse = json.decode(utf8.decode(response.bodyBytes));
    DistrictData a = DistrictData.fromJson(jsonresponse[0]);
    ResponsePlace rp = ResponsePlace();
    rp.aciklama = a.productCategory ?? "";
    rp.enCokYetistirilen = a.enCokYetistirilenUrunler ?? "";
    rp.sulamaKaynakYonetimi = a.sulamaSuyuKaynagiYonetimi ?? "";
    rp.sulamaSuyuKaynagi = a.tarimsalSulamaSuyu ?? "";
    rp.sulanabilirAlandaYetistirilenler =
        a.sulanabilirAlandaYetistirilenUrunler ?? "";
    rp.yuzdelikAlan = a.sulakAlanMiktari ?? "";
    rp.ilceAdi = a.ilceAdi ?? "";
    rp.mahalleAdi = a.mahalleAdi ?? "";
    rp.yagisMiktari = a.yagisMiktariMm ?? 0;
    String temp = "";
    if (a.suggestedProducts != null) {
      for (var i = 0; i < a.suggestedProducts!.length; i++) {
        if (i == a.suggestedProducts!.length - 1) {
          temp += a.suggestedProducts![i];
        } else {
          temp += "${a.suggestedProducts![i]}, ";
        }
      }
    }
    rp.onerilen = temp;
    return rp;
  }
}

class ResponsePlace {
  String yuzdelikAlan;
  String enCokYetistirilen;
  String sulamaKaynakYonetimi;
  String sulanabilirAlandaYetistirilenler;
  String ilceAdi;
  String mahalleAdi;
  int yagisMiktari;
  String sulamaSuyuKaynagi;
  String aciklama;
  String onerilen;
  ResponsePlace(
      {this.yuzdelikAlan = "",
      this.enCokYetistirilen = "",
      this.sulamaKaynakYonetimi = "",
      this.sulanabilirAlandaYetistirilenler = "",
      this.sulamaSuyuKaynagi = "",
      this.aciklama = "",
      this.onerilen = "",
      this.ilceAdi = "",
      this.mahalleAdi = "",
      this.yagisMiktari = 0});
}

class DistrictData {
  String? ilceAdi;
  String? mahalleAdi;
  String? tarimsalSulamaSuyu;
  String? sulamaSuyuKaynagiYonetimi;
  String? enCokYetistirilenUrunler;
  String? sulanabilirAlandaYetistirilenUrunler;
  String? talepEdilenTarimsalEgitimler;
  String? sulakAlanMiktari;
  String? tarimsalSulamaSuyuKaynagi;
  String? toprakTipi;
  String? productCategory;
  int? yagisMiktariMm;
  List<String>? suggestedProducts;

  DistrictData(
      {this.ilceAdi,
      this.mahalleAdi,
      this.tarimsalSulamaSuyu,
      this.sulamaSuyuKaynagiYonetimi,
      this.enCokYetistirilenUrunler,
      this.sulanabilirAlandaYetistirilenUrunler,
      this.talepEdilenTarimsalEgitimler,
      this.sulakAlanMiktari,
      this.tarimsalSulamaSuyuKaynagi,
      this.toprakTipi,
      this.productCategory,
      this.yagisMiktariMm,
      this.suggestedProducts});

  DistrictData.fromJson(Map<String, dynamic> json) {
    ilceAdi = json['ilce_adi'];
    mahalleAdi = json['mahalle_adi'];
    tarimsalSulamaSuyu = json['tarimsal_sulama_suyu'];
    sulamaSuyuKaynagiYonetimi = json['sulama_suyu_kaynagi_yonetimi'];
    enCokYetistirilenUrunler = json['en_cok_yetistirilen_urunler'];
    sulanabilirAlandaYetistirilenUrunler =
        json['sulanabilir_alanda_yetistirilen_urunler'];
    talepEdilenTarimsalEgitimler = json['talep_edilen_tarimsal_egitimler'];
    sulakAlanMiktari = json['sulak_alan_miktari'];
    tarimsalSulamaSuyuKaynagi = json['tarimsal_sulama_suyu_kaynagi'];
    toprakTipi = json['toprak_tipi'];
    productCategory = json['product_category'];
    yagisMiktariMm = json['yagis_miktari (mm)'];
    suggestedProducts = json['suggested_products'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ilce_adi'] = this.ilceAdi;
    data['mahalle_adi'] = this.mahalleAdi;
    data['tarimsal_sulama_suyu'] = this.tarimsalSulamaSuyu;
    data['sulama_suyu_kaynagi_yonetimi'] = this.sulamaSuyuKaynagiYonetimi;
    data['en_cok_yetistirilen_urunler'] = this.enCokYetistirilenUrunler;
    data['sulanabilir_alanda_yetistirilen_urunler'] =
        this.sulanabilirAlandaYetistirilenUrunler;
    data['talep_edilen_tarimsal_egitimler'] = this.talepEdilenTarimsalEgitimler;
    data['sulak_alan_miktari'] = this.sulakAlanMiktari;
    data['tarimsal_sulama_suyu_kaynagi'] = this.tarimsalSulamaSuyuKaynagi;
    data['toprak_tipi'] = this.toprakTipi;
    data['product_category'] = this.productCategory;
    data['yagis_miktari (mm)'] = this.yagisMiktariMm;
    data['suggested_products'] = this.suggestedProducts;
    return data;
  }
}
