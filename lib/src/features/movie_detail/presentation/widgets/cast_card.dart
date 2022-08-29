import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Cast_card extends StatelessWidget {
  List list_data;
  Cast_card({Key? key, required this.list_data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: list_data.length,
      itemBuilder: (BuildContext context, int index) {
        final item = list_data[index];
        //get your item data here ...
        return Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              color: Colors.transparent,
              width: 110,
              height: 110,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: list_data[index]['profile_path'] == null
                      ? Center(
                          child: Text(
                            "No Image",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Image.network(
                          'https://image.tmdb.org/t/p/w92/${list_data[index]['profile_path']}',
                          fit: BoxFit.cover,
                        )),
            ),
            SizedBox(
              height: 10,
            ),
            Text('${list_data[index]['name']}')
          ],
        );
        //  Card(
        //   //color: RandomColor().randomColor(),
        //   child: ListTile(
        //     title: Text(list_data[index]['name']),
        //   ),
        // );
      },
    )

        //  GridView.count(
        //     crossAxisCount: 2,

        //     children: List.generate(
        //       list_data.length,
        //       (index) {
        //         return Column(
        //           children: [
        //             Container(
        //                 color: Colors.transparent,
        //                 width: 150,
        //                 height: 150,
        //                 child: ClipRRect(
        //                     borderRadius: BorderRadius.circular(100),
        //                     child: Image.network(
        //                       'https://image.tmdb.org/t/p/w92//gXKyT1YU5RWWPaE1je3ht58eUZr.jpg',
        //                       fit: BoxFit.cover,
        //                     )
        //                     //  CachedNetworkImage(
        //                     //   imageUrl:
        //                     //       'https://image.tmdb.org/t/p/original/gXKyT1YU5RWWPaE1je3ht58eUZr.jpg',
        //                     //   fit: BoxFit.cover,
        //                     //   placeholder: (context, url) => Center(
        //                     //     child: CircularProgressIndicator(),
        //                     //   ),
        //                     //   errorWidget: (context, url, error) => Icon(Icons.error),
        //                     // ),
        //                     )),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Text("Spider Man")
        //           ],
        //         );
        //       },
        //     ))

        );
  }
}
