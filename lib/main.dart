import 'package:covid_app/services/covid.dart';
import 'package:covid_app/utilities/constants.dart';
import 'package:covid_app/widgets/counter.dart';
import 'package:covid_app/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            bodyText2: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> countries = getAllCountries();
  String current;

  @override
  void initState() {
    super.initState();
    current = "Türkiye";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchData(current),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Header(
                    image: "assets/icons/Drcorona.svg",
                    textTop: "",
                    textBottom: "#EvdeKal",
                    countryCode: snapshot.data.code,
                    offset: 0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                            value: snapshot.data.name,
                            items: countries.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(country),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                this.current = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Bugünkü Veriler\n",
                                    style: kTitleTextstyle,
                                  ),
                                  TextSpan(
                                    text:
                                        "Son Güncelleme: ${DateTime.parse(snapshot.data.lastUpdate)}",
                                    style: TextStyle(
                                      color: kTextLightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 30,
                                color: kShadowColor,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Counter(
                                color: kInfectedColor,
                                number: snapshot.data.today['confirmed'],
                                title: "Vaka Sayısı",
                              ),
                              Counter(
                                color: kDeathColor,
                                number: snapshot.data.today['deaths'],
                                title: "Vefat Sayısı",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Toplam Veriler\n",
                                        style: kTitleTextstyle,
                                      ),
                                      TextSpan(
                                        text:
                                            "Son Güncelleme:${DateTime.parse(snapshot.data.lastUpdate)}",
                                        style: TextStyle(
                                          color: kTextLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 30,
                                    color: kShadowColor,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Counter(
                                    color: kInfectedColor,
                                    number: snapshot.data.total['confirmed'],
                                    title: "Vaka Sayısı",
                                  ),
                                  Counter(
                                    color: kDeathColor,
                                    number: snapshot.data.total['deaths'],
                                    title: "Vefat Sayısı",
                                  ),
                                  Counter(
                                    color: kRecovercolor,
                                    number: snapshot.data.total['recovered'],
                                    title: "İyileşen Sayısı",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
                child: SpinKitWanderingCubes(
              color: Color(0xFF3383CD),
              size: 50.0,
            ));
          }
        },
      ),
    );
  }
}
