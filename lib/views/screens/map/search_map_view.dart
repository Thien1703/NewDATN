import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:health_care/views/screens/map/data_search_model.dart';
import 'package:http/http.dart' as http;

class SearchAddressPage extends StatefulWidget {
  const SearchAddressPage({
    super.key,
  });

  @override
  State<SearchAddressPage> createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  bool isWaitting = false;
  List<DataSearchModel> listLocation = [];
  String apiKey = "PWunup1r6WKIVOuEJcS1j9uGxhg5MfPAYF9oySV8";
  String input = "";
  TextEditingController controller = TextEditingController();
  double lat = 0;
  double lng = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchData() async {
    isWaitting = true;
    try {
      var url = Uri.parse(
          "https://rsapi.goong.io/Place/AutoComplete?api_key=$apiKey&input=$input");
      final response = await http.get(
        url,
      );
      if (response.statusCode.toString() == '200') {
        var dataRespone = jsonDecode(response.body);
        Iterable listData = dataRespone["predictions"];

        final mapData = listData.cast<Map<String, dynamic>>();
        listLocation = mapData.map<DataSearchModel>((json) {
          return DataSearchModel.fromJson(json);
        }).toList();
      } else {
        listLocation = [];
      }
    } catch (e) {
      listLocation = [];
    } finally {
      setState(() {
        isWaitting = false;
      });
    }
  }

  Future<void> getLatLong(BuildContext context, DataSearchModel data) async {
    try {
      var url = Uri.parse(
          "https://rsapi.goong.io/Place/Detail?place_id=${data.placeId}&api_key=$apiKey");
      final response = await http.get(
        url,
      );
      print(response.body);
      if (response.statusCode.toString() == '200') {
        var dataRespone = jsonDecode(response.body);
        lat = dataRespone["result"]["geometry"]["location"]["lat"].toDouble();
        lng = dataRespone["result"]["geometry"]["location"]["lng"].toDouble();
        DataSearchModel result = data;
        result.lat = lat;
        result.lng = lng;
        Navigator.pop(context, result);
      } else {}
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: TextFormField(
            autofocus: true,
            controller: controller,
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Nhập vị trí",
              hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800]),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[800],
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    input = "";
                    controller.text = "";
                  });
                },
              ),
            ),
            textInputAction: TextInputAction.search,
            onChanged: (value) async {
              setState(() {
                isWaitting = true;
                input = value;
              });
              await fetchData();
            },
            onFieldSubmitted: (value) async {
              setState(() {
                isWaitting = true;
                input = value;
              });
              await fetchData();
            },
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // suggestion text
          isWaitting
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: listLocation.isEmpty
                      ? SizedBox.shrink()
                      : ListView.separated(
                          padding: EdgeInsets.all(10),
                          itemCount: listLocation.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 5,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () async {
                                await getLatLong(context, listLocation[index]);
                              },
                              leading: Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                              ),
                              title: Text(listLocation[index]
                                  .structuredFormatting!
                                  .mainText),
                              subtitle: Text(listLocation[index]
                                  .structuredFormatting!
                                  .secondaryText),
                            );
                          },
                        ))
        ],
      ),
    );
  }
}
