import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stay_indie/screens/chat/InboxScreen.dart';
import 'package:stay_indie/utilities/input_fields.dart';
import 'constants.dart';
import 'package:stay_indie/models/connections/google_signin_helper.dart';
import 'package:stay_indie/screens/profile/profile_page.dart';
import 'package:stay_indie/models/connections/Spotify/spotify_signin_helper.dart';
import 'package:spotify/spotify.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);
  static const String id = '/test_page';

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final GoogleSignInHelper _googleSignInHelper = GoogleSignInHelper();

  List<Artist> artists = [];
  Artist? selectedArtist = null;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              style: kSmallPrimaryButtonStyle,
              onPressed: () {
                context.go('/myprofile');
              },
              child: const Text('Navigate to Profile Page'),
            ),
            TextButton(
              style: kSmallPrimaryButtonStyle,
              onPressed: () {
                context.go('/inbox');
              },
              child: const Text('Navigate to Inbox'),
            ),
            TextButton(
              style: kSmallPrimaryButtonStyle,
              onPressed: () async {
                await showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              child: const Text('Search'),
            ),
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
            TextButton(
              style: kSmallPrimaryButtonStyle,
              onPressed: selectedArtist != null
                  ? () async {
                      Spotify.addArtistToDatabase(selectedArtist!);
                    }
                  : null,
              child: Text('Confirm that this is me'),
            ),
            Column(
              children: [
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    var artist = artists[index];
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage: NetworkImage(
                            artist.images?.first.url ??
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  // Dummy list
  final List<String> searchList = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Fig",
    "Grapes",
    "Kiwi",
    "Lemon",
    "Mango",
    "Orange",
    "Papaya",
    "Raspberry",
    "Strawberry",
    "Tomato",
    "Watermelon",
  ];

  // These methods are mandatory you cannot skip them.

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          // When pressed here the query will be cleared from the search bar.
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> searchResults = searchList
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]),
          onTap: () {
            // Handle the selected search result.
            close(context, searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? []
        : searchList
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query = suggestionList[index];
            // Show the search results based on the selected suggestion.
          },
        );
      },
    );
  }
}
