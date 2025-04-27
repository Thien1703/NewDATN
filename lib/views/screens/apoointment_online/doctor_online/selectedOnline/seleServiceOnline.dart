import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_care/models/service.dart';
import 'package:health_care/viewmodels/api/service_api.dart';
import 'package:health_care/views/widgets/bottomSheet/header_bottomSheet.dart';

class Seleserviceonline extends StatefulWidget {
  const Seleserviceonline({super.key, required this.serviceId});
  final String serviceId;
  @override
  State<Seleserviceonline> createState() => _SeleserviceonlineState();
}

class _SeleserviceonlineState extends State<Seleserviceonline> {
  List<Service>? service;
  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  void fetchServices() async {
    int serviceIdInt = int.tryParse(widget.serviceId) ?? 0;
    List<Service>? data = await ServiceApi.getOnlineServeById(serviceIdInt);
    if (data != null) {
      setState(() {
        service = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderBottomSheet(
      title: 'Chọn dịch vụ',
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: service == null
            ? Center(child: CircularProgressIndicator())
            : ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height *
                      0.5, // tối đa 50% chiều cao màn hình
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: service!.length,
                  itemBuilder: (context, index) {
                    final services = service![index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context,
                            {'id': services.id, 'name': services.name});
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(services.name),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
