import 'package:datathon/const/color.dart';
import 'package:datathon/places/place.dart';
import 'package:datathon/service/app_service.dart';
import 'package:flutter/material.dart';

class PlaceDetail extends StatefulWidget {
  const PlaceDetail({super.key, required this.place});

  final Place place;

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  String lorem =
      "Bu kategori, verimli toprak türlerini temsil eder ve bu topraklar yüksek su ihtiyacına sahiptir. Bu topraklarda bitkilerin sağlıklı bir şekilde büyümesi için düzenli sulama gereklidir.";
  String lorem2 =
      "Kumlu toprakları temsil eden bu kategori, yüksek su ihtiyacına sahiptir. Kumlu topraklar suyu hızla geçirme eğilimindedir, bu nedenle düzenli ve bol sulama önemlidir.";
  ResponsePlace? place;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    AppService service = AppService();
    place = await service.getPlace(widget.place.lat, widget.place.lon);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.place.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: isLoading
              ? const SizedBox(
                  height: double.maxFinite,
                  child: Center(
                    child: CircularProgressIndicator(
                        color: CustomColors.primaryColor),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    partBox(
                        "İlçe adı", (place?.ilceAdi ?? "").toUpperCase(), 0),
                    partBox("Mahalle adı", place?.mahalleAdi ?? "", 1),
                    place?.ilceAdi.toUpperCase() == "KARAPINAR"
                        ? partBoxError(
                            "Bu bölge için önerilmeyen ürünler", "MISIR")
                        : SizedBox(),
                    partBox("Bu bölge için önerilen ürünler",
                        place?.onerilen ?? "", 0),
                    place?.ilceAdi.toUpperCase() == "KARAPINAR"
                        ? partBox("Açıklama", lorem2, 1)
                        : partBox("Açıklama", lorem, 1),
                    partBox("Sulak alan miktarı", place?.yuzdelikAlan ?? "", 0),
                    partBox("Yıllık yağış miktarı",
                        (place?.yagisMiktari ?? 0).toString(), 1),
                    partBox("Sulanabilir alanda yetiştirilen ürünler",
                        place?.sulanabilirAlandaYetistirilenler ?? "", 0),
                    partBox("Sulama suyu kaynağı",
                        place?.sulamaSuyuKaynagi ?? "", 1),
                    partBox("En çok yetiştirilen ürünler",
                        place?.enCokYetistirilen ?? "", 0),
                    partBox("Sulama suyu kaynağı yönetimi",
                        place?.sulamaKaynakYonetimi ?? "", 1),
                  ],
                ),
        ),
      ),
    );
  }

  Container partBox(String title, String body, int index) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 20),
      decoration: BoxDecoration(
        color: index == 1 ? CustomColors.secondaryColor.withOpacity(0.5) : null,
        border: const Border(
          bottom: BorderSide(
            color: CustomColors.primaryColor,
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CustomColors.primaryColor, fontWeight: FontWeight.bold),
          ),
          Text(body, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Container partBoxError(
    String title,
    String body,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        border: const Border(
          bottom: BorderSide(
            color: CustomColors.primaryColor,
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(body, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
