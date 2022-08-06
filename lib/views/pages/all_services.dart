import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../constants/constants.dart';
import '../../models/service.dart';
import '../../services/firebase_service.dart';
import 'service_detail.dart';

class AllService extends StatefulWidget {
  const AllService({Key? key}) : super(key: key);

  @override
  State<AllService> createState() => _AllServiceState();
}

class _AllServiceState extends State<AllService> {
  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text("Services", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: [
          Container(
            height: screenheight,
            width: double.infinity,
            child: StreamBuilder<List<Service>>(
              stream: FireService.getServices(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      if (snapshot.data == null) {
                        return const Text('No data to show');
                      } else {
                        final services = snapshot.data!;

                        return ListView.builder(
                          itemCount: services.length,
                          itemBuilder: (BuildContext context, int index) {
                            return builtService(services[index]);
                          },
                        );
                      }
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget builtService(Service service) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ServiceDetails(
                      service: service,
                    ))),
        child: Container(
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(10.0, 10.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            //padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(10), right: Radius.circular(25)),
                  child: Image.network(
                    fit: BoxFit.cover,
                    service.img,
                    width: screenWidth * 0.4,
                    height: 150,
                  ),
                ),
                Container(
                  width: screenWidth * 0.4,
                  padding: EdgeInsets.only(right: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("\$${service.price}/h",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
