import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fugi_movie_app_team2/src/features/home/presentation/home_screen.dart';
import 'package:fugi_movie_app_team2/src/features/search/presentation/search_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/client/dio_client.dart';
import '../../home/domain/trending.dart';
import 'widgets/movie_item_widget.dart';

class SearchScreen extends StatefulHookConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const routeName = 'search-screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  bool isLoading = false;
  List<Trending> trendings = [];

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final searchResultState = ref.watch(searchControllerProvider);
    final keywordSearchState = ref.watch(keywordsProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Search Results'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline)),
            ],
          ),
          body: searchResultState.when(
            data: (datas) {
              return Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0.sp),
                        child: Row(
                          children: [
                            Text('Finded ${datas?.length} results for keyword'),
                            SizedBox(width: 5.0.sp),
                            Text(
                              '"$keywordSearchState"',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
                      itemCount: datas?.length,
                      itemBuilder: (context, index) {
                        var dataku = datas![index];
                        return MovieItemWidget(
                          imagePath: dataku['poster_path'],
                          title: dataku['title'],
                          rating: dataku['vote_average'].toString(),
                          date: dataku['release_date'],
                          movie: dataku,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            error: (e, st) => const Text('Error'),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          )),
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    var resp = await DioClient().apiCall(
      url: '/trending/all/week',
      requestType: RequestType.get,
      queryParameters: {
        'language': 'en-US',
      },
    );
    List<dynamic> listTrending = resp.data['results'];
    List<Trending> myTrendings = listTrending.map((e) => Trending.fromJson(e)).toList();
    setState(() {
      trendings = myTrendings;
      isLoading = false;
    });
  }
}
