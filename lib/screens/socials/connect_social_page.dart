import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stay_indie/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stay_indie/models/SocialMetric.dart';
import 'package:stay_indie/widgets/GRBottomSheet.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'dart:async';

// youtube

import 'package:stay_indie/models/connections/google_signin_helper.dart';

// spotify
import 'package:spotify/spotify.dart';
import 'package:stay_indie/models/connections/spotify/spotify_signin_helper.dart';

class ConnectSocialPage extends StatefulWidget {
  static const id = '/connect_social_page';

  @override
  State<ConnectSocialPage> createState() => _ConnectSocialPageState();
}

class _ConnectSocialPageState extends State<ConnectSocialPage> {
  List<bool> _isOpen = [false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Connect your socials'),
      ),
      body: SafeArea(
        child: const Accordion(),
      ),
    );
  }
}

class Accordion extends StatefulWidget {
  const Accordion({super.key});

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  final List<ConnectSocial> _data = getConnectSocials(8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      dividerColor: kBackgroundColour30,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((ConnectSocial connectSocial) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Icon(SocialMetric.getIcon(
                  connectSocial.headerValue.toLowerCase())),
              title: Text(connectSocial.headerValue, style: kHeading4),
            );
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    'Connect your ${connectSocial.headerValue} account to share statistics and allow your account to be verified',
                    style: kBody1),
                SizedBox(height: 20),
                Wrap(
                  children: [
                    TextButton(
                      style: kSmallPrimaryButtonStyle,
                      onPressed: () {
                        connectSocial.sheetHeight != null
                            ? GRBottomSheet.buildFixedHeightBottomSheet(
                                context,
                                connectSocial.child!,
                                connectSocial.sheetHeight!)
                            : GRBottomSheet.buildBottomSheet(
                                context,
                                connectSocial.child!,
                              );
                      },
                      child: Text('Connect to ${connectSocial.headerValue}'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          canTapOnHeader: true,
          backgroundColor: kBackgroundColour,
          isExpanded: connectSocial.isExpanded,
        );
      }).toList(),
    );
  }
}

class ConnectSocial {
  ConnectSocial({
    required this.expandedValue,
    required this.headerValue,
    this.child,
    this.isExpanded = false,
    this.isConnected = false,
    this.sheetHeight,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
  Widget? child;
  bool isConnected = false;
  double? sheetHeight;
}

List<ConnectSocial> getConnectSocials(int numberOfItems) {
  return [
    ConnectSocial(
      headerValue: 'Spotify',
      expandedValue: 'Spotify',
      child: const SpotifySearch(),
      sheetHeight: 0.8,
    ),
    ConnectSocial(
      headerValue: 'Youtube',
      expandedValue: 'Youtube',
      child: const YoutubeConnection(),
    ),
    ConnectSocial(
      headerValue: 'Instagram',
      expandedValue: 'Instagram',
    ),
    ConnectSocial(
      headerValue: 'Soundcloud',
      expandedValue: 'Soundcloud',
    ),
  ];
}

class YoutubeConnection extends StatefulWidget {
  const YoutubeConnection({super.key});

  @override
  State<YoutubeConnection> createState() => _YoutubeConnectionState();
}

class _YoutubeConnectionState extends State<YoutubeConnection> {
  final GoogleSignInHelper _googleSignInHelper = GoogleSignInHelper();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            style: kSmallPrimaryButtonStyle,
            onPressed: () {
              _googleSignInHelper.signIn();
            },
            child: Text('Sign in with Google')),
        Text(_googleSignInHelper.account?.displayName ?? 'No user'),
        TextButton(
            style: kSmallPrimaryButtonStyle,
            onPressed: () {
              _googleSignInHelper.signOut();
            },
            child: Text('Sign out with Google')),
      ],
    );
  }
}

class SpotifySearch extends StatefulWidget {
  const SpotifySearch({super.key});

  @override
  State<SpotifySearch> createState() => _SpotifySearchState();
}

class _SpotifySearchState extends State<SpotifySearch> {
  List<Artist> artists = [];
  Artist? selectedArtist = null;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _debounce;

  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.dispose();
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      performSearch(_controller.text);
    });
  }

  void performSearch(String value) async {
    if (value.isEmpty) {
      setState(() {
        artists = [];
      });
      return;
    }
    try {
      var searchResults = await Spotify().searchArtist(value);
      if (_controller.text == value) {
        setState(() {
          artists = searchResults;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        formSpacer,
        Text('Connect Spotify', style: kHeading2),
        Text(
            'We will verify your account later. Please search for your artist name below and select it.',
            style: kBody1),
        formSpacer,
        selectedArtist != null
            ? Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(16),
                decoration: kOutlineBorder,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      foregroundImage: NetworkImage(
                          selectedArtist?.images?.first.url ??
                              'https://via.placeholder.com/150'),
                      child: Text(selectedArtist?.name?[0] ?? ''),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedArtist?.name ?? '',
                            style: kHeading2,
                          ),
                          Text(
                              '${formatLargeNumber(selectedArtist?.followers?.total ?? 0)} followers'),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: kSearchTextFieldDecoration.copyWith(
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _controller.clear();
                        artists = [];
                      });
                    },
                  )
                : null,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 0),
            shrinkWrap: false,
            itemCount: artists.length,
            itemBuilder: (context, index) {
              var artist = artists[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                leading: CircleAvatar(
                  foregroundImage: NetworkImage(artist.images?.first.url ??
                      'https://via.placeholder.com/150'),
                  child: Text(artist.name![0]),
                ),
                title: Text(artist.name ?? ""),
                onTap: () {
                  setState(() {
                    selectedArtist = artist;
                  });
                },
              );
            },
          ),
        ),
        TextButton(
          style: kSmallPrimaryButtonStyle,
          onPressed: selectedArtist != null
              ? () async {
                  Spotify.addArtistToDatabase(selectedArtist!);
                }
              : null,
          child: Text('Confirm that this is me'),
        ),
      ],
    );
  }
}
