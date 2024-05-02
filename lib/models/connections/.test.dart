main() {
  print('Spotify API');
  Spotify spotify = Spotify();
  spotify.fetchData('0TnOYISbd1XYRBk9myaseg').then((data) {
    print(data);
  });
  spotify.searchArtist('Ariana Grande').then((data) {
    print(data);
  });
}
