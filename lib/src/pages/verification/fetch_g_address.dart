import 'dart:io';

import 'package:curnect/src/pages/verification/validate_address.dart';
import 'package:curnect/src/routes/route_animation.dart';
import 'package:curnect/src/widgets/snackBar/ErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import '../../widgets/appbar.dart';
import '../../widgets/unauthenticatedPageHeader.dart';

String title =
    'What is a Fetch shipping address? You can think of your Fetch shipping address as a P.O. box that delivers directly to you! Your Fetch shipping address is our facility address that includes your apartment\'s unique Fetch code identifier.';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesScreenState extends State<SearchPlacesScreen>
    with ErrorSnackBar {
  String googleApiKey = "AIzaSyBmmJDKJshf79zx5eh71HwC7DaXep7s1LI";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  LatLng startLocation = const LatLng(6.465422, 3.406448);
  String location = "Search your business location";
  Map<String, String> address = {};
  String unformattedAddres = "";
  bool navEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UnauthenticatedAppBar(context: context, screeenInfo: title)
          .preferredSize(),
      key: homeScaffoldKey,
      body: SafeArea(
          child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.14,
              width: MediaQuery.of(context).size.width * 0.1,
              child: const UnauthenticatedPageheader(
                subTitle:
                    'Do your clients come to you, do you go to them, or both',
                title: 'Your Address',
              ),
            ),
            Column(children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: InkWell(
                    onTap: () async {
                      try {
                        var place = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: googleApiKey,
                            mode: Mode.overlay,
                            logo: const Text(""),
                            types: [],
                            strictbounds: false,
                            components: [],
                            onError: (err) {
                              debugPrint("$err");
                            });
                        if (place != null) {
                          setState(() {
                            location = place.description.toString();
                          });
                          final plist = GoogleMapsPlaces(
                              apiKey: googleApiKey,
                              apiHeaders:
                                  await const GoogleApiHeaders().getHeaders());
                          String placeid = place.placeId ?? "0";
                          final detail =
                              await plist.getDetailsByPlaceId(placeid);
                          var a = detail.result.adrAddress!.replaceAll(",", '');
                          var b = a.replaceAll("<span class=", '');
                          var c = b.split("</span>");
                          for (var element in c) {
                            var lastSplit = element.split(">");
                            debugPrint("$lastSplit");
                            if (lastSplit.length >= 2) {
                              setState(() {
                                address[lastSplit
                                        .toString()
                                        .contains('street-address')
                                    ? 'street-adress'
                                    : lastSplit[0]
                                        .toString()
                                        .replaceAll("\"", "")
                                        .replaceFirst(" ", "")] = lastSplit[1];
                              });
                            }
                          }
                          setState(() {
                            unformattedAddres = detail.result.formattedAddress!;
                          });
                          // debugPrint("$address");
                          final geometry = detail.result.geometry;
                          final lat = geometry?.location.lat;
                          final lang = geometry?.location.lng;
                          var newlatlang = LatLng(lat!, lang!);

                          mapController
                              ?.animateCamera(CameraUpdate.newCameraPosition(
                                  CameraPosition(target: newlatlang, zoom: 17)))
                              .whenComplete(() {
                            if (detail.isNotFound) {
                              navEnable = false;
                            } else {
                              navEnable = true;
                            }
                          });
                          // ignore: use_build_context_synchronously
                        }
                      } on SocketException catch (_) {
                        sendErrorMessage('Network error',
                            'Please check your internet connection', context);
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListTile(
                          title: Text(
                            location,
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: const Icon(Icons.search),
                          dense: true,
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.52,
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  scrollGesturesEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: startLocation, zoom: 14.0),
                  mapType: MapType.normal,
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                ),
              ),
            ]),
          ])),
      persistentFooterButtons: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // <-- Radius
              ),
              backgroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50)),
          onPressed: navEnable
              ? () {
                  setState(() {
                    navEnable = !navEnable;
                    // Provider.of<AddServiceManipulator>(context,
                    //         listen: false)
                    //     .createLocation(address);
                  });
                  Navigator.of(context).push(RouteAnimation(
                      Screen: ValidateAddress(
                    addresses: address,
                  )).createRoute());
                }
              : null,
          child: const Text(
            'Continue',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
        )
      ],
    );
  }
}
