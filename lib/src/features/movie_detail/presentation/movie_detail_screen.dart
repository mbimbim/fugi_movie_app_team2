import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fugi_movie_app_team2/src/common_config/app_theme.dart';
import 'package:fugi_movie_app_team2/src/core/client/dio_client.dart';
import 'package:fugi_movie_app_team2/src/features/home/domain/movie_detail.dart';
import 'package:fugi_movie_app_team2/src/features/home/domain/trending.dart';
import 'package:fugi_movie_app_team2/src/features/movie_detail/presentation/widgets/about_movie.dart';
import 'package:fugi_movie_app_team2/src/features/movie_detail/presentation/widgets/cast.dart';
import 'package:fugi_movie_app_team2/src/features/movie_detail/presentation/widgets/movie_status.dart';
import 'package:fugi_movie_app_team2/src/features/movie_detail/presentation/widgets/reviews.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? idAndObject;
  final Trending? trending;
  const MovieDetailScreen({
    Key? key,
    this.trending,
    this.idAndObject,
  }) : super(key: key);
  static const routeName = 'movie-detail-screen';

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  MovieDetail detailMovie = const MovieDetail();
  bool isLoading = false;
  final List<PaletteColor> _colors = [];
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _updatePalettes(MovieDetail movieDetailResponse) async {
    var x = movieDetailResponse.posterPath;
    final generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(
        'https://image.tmdb.org/t/p/w500/$x',
      ),
    );
    _colors.add(generator.lightVibrantColor ?? generator.lightMutedColor ?? PaletteColor(Colors.teal, 2));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark)),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * .09.sp,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15.0.sp),
                                bottomRight: Radius.circular(15.0.sp),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _colors.isNotEmpty
                                      ? _colors[_currentIndex].color.withOpacity(.3)
                                      : Colors.black.withOpacity(0.5),
                                  spreadRadius: 2.5.sp,
                                  blurRadius: 5.0.sp,
                                  offset: const Offset(0, 2), // changes position of shadow
                                ),
                              ],
                              color: AppTheme.secondaryColor,
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/original/${detailMovie.backdropPath}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Text('${widget.trending.id}'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Movie ID: ${widget.idAndObject!['id']}',
                              style: TextStyle(
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 100.0.sp,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: ((BuildContext context) {
                                      return Wrap(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0.sp),
                                                topRight: Radius.circular(20.0.sp),
                                              ),
                                            ),
                                            padding: EdgeInsets.all(20.0.sp),
                                            child: const WidgetSLider(),
                                          )
                                        ],
                                      );
                                    }));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 15.0.sp, horizontal: 15.0.sp),
                                width: 70.0.sp,
                                height: 35.0.sp,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(10.0.sp),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.star_border, color: Colors.orange),
                                      Text('${detailMovie.voteAverage}',
                                          style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.orange,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: 0.0.sp,
                        right: 0.0.sp,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0.sp,
                              // vertical: 5.0.sp,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 75.0.sp,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0.sp),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            _colors.isNotEmpty ? _colors[_currentIndex].color.withOpacity(.5) : Colors.white,
                                        blurRadius: 10.0.sp,
                                        spreadRadius: 5.0.sp,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0.sp)),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500/${detailMovie.posterPath}',
                                      fit: BoxFit.cover,
                                      width: 90.sp,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 25),
                                Flexible(
                                  child: Column(
                                    children: [
                                      SizedBox(height: Platform.isIOS ? 30.0.sp : 50.0.sp),
                                      Text(
                                        '${detailMovie.title}',
                                        style: TextStyle(
                                          fontSize: 22.0.sp,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0.sp),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6.sp,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MovieStatus(
                              icon: FontAwesomeIcons.calendarWeek,
                              text: DateFormat('dd MMM yyyy').format(DateTime.parse(detailMovie.releaseDate.toString()))),
                          MovieStatus(icon: FontAwesomeIcons.clock, text: '${detailMovie.runtime} min'),
                          MovieStatus(icon: FontAwesomeIcons.ticket, text: '${detailMovie.genres?[0].name}'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: const TabBar(
                        tabs: [
                          Tab(child: Text('Reviews')),
                          Tab(child: Text('About Movie')),
                          Tab(child: Text('Production')),
                        ],
                      ),
                      body: TabBarView(
                        children: [
                          AboutMovie(
                            movieTitle: detailMovie.title,
                            content: detailMovie.overview ?? '-',
                          ),
                          Reviews(content: detailMovie.overview ?? '-'),
                          Cast(content: detailMovie.productionCompanies!),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var resp = await DioClient().apiCall(
        // url: '/movie/${widget.trending.id}',
        url: '/movie/${widget.idAndObject!['id']}',
        requestType: RequestType.get,
        queryParameters: {},
      );
      var respBody = resp.data;
      MovieDetail movieDetailResponse = MovieDetail.fromJson(respBody);
      setState(() {
        detailMovie = movieDetailResponse;
        isLoading = false;
      });
      _updatePalettes(movieDetailResponse);
    } catch (e) {
      Logger().e(e);
    }
  }
}

class WidgetSLider extends StatefulWidget {
  const WidgetSLider({Key? key}) : super(key: key);

  @override
  State<WidgetSLider> createState() => _WidgetSLiderState();
}

class _WidgetSLiderState extends State<WidgetSLider> {
  double SliderValue = 0.0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Rate this Movie",
            style: GoogleFonts.montserrat().copyWith(fontSize: 18, fontWeight: FontWeight.w400, color: AppTheme.thirdColor)),
        const SizedBox(height: 20),
        Text('${double.parse(SliderValue.toStringAsFixed(1))}',
            style: GoogleFonts.montserrat().copyWith(fontSize: 32, fontWeight: FontWeight.w400, color: AppTheme.thirdColor)),
        const SizedBox(height: 10),
        SliderTheme(
          data: const SliderThemeData(
            activeTrackColor: Color(0XFFFF8700),
            trackHeight: 10,
            overlayColor: Colors.amber,
            inactiveTrackColor: Colors.grey,
            thumbColor: Colors.white,
            thumbShape: RoundSliderThumbShape(elevation: 10, enabledThumbRadius: 15),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
          ),
          // thumbColor: Colors.green,
          // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20)),
          child: Slider(
            value: SliderValue,
            max: 10,
            // divisions: 100,
            label: '${SliderValue.round()}',
            // thumbColor: Colors.white,
            // activeColor: Colors.amber,
            autofocus: true,
            //inactiveColor: Colors.grey,
            onChanged: (double value) {
              setState(() {
                SliderValue = value;
              });
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 220,
            height: 56,
            color: const Color(0XFF0296E5),
            child: Center(
              child: Text("OK",
                  style: GoogleFonts.montserrat().copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        )
      ],
    );
  }
}
