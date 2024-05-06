import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/ConnectionRequest.dart';
import 'package:stay_indie/models/Profile.dart';

class CoverButton extends StatefulWidget {
  final Profile userProfile;
  const CoverButton({
    required this.userProfile,
    super.key,
  });

  @override
  State<CoverButton> createState() => _CoverButtonState();
}

class _CoverButtonState extends State<CoverButton> {
  late Future<bool> requestPending;
  late Future<bool> receivedRequest;
  late bool isConnected = false;
  @override
  void initState() {
    // TODO: implement initState
    ConnectionRequest.getProfileConnectionRequests(widget.userProfile.id)
        .then((value) {
      print("Getting all the connection Requests for ${widget.userProfile.id}" +
          value.toString());
    });

    setState(() {
      requestPending = ConnectionRequest.isRequested(widget.userProfile.id);
      receivedRequest = ConnectionRequest.needToAccept(currentUserId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([requestPending, receivedRequest]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('Snapshot: ' + snapshot.toString());
            if (snapshot.hasError) {
              return Text('Snapshot Error: ${snapshot.error}');
            } else {
              bool requestPending = snapshot.data![0];
              bool receivedRequest = snapshot.data![1];

              if (requestPending) {
                return TextButton(
                  onPressed: () {},
                  child: Text('Request Pending'),
                  style: kSmallSecondaryButtonStyle,
                );
              } else if (receivedRequest) {
                return TextButton(
                  onPressed: () {},
                  child: Text('Accept Request'),
                  style: kSmallAccentButtonStyle,
                );
              } else if (isConnected) {
                return TextButton(
                  onPressed: () {},
                  child: Text('Connected'),
                  style: kSmallSecondaryButtonStyle,
                );
              } else {
                return TextButton(
                  onPressed: () {},
                  child: Text('Connect'),
                  style: kSmallPrimaryButtonStyle,
                );
              }
            }
          } else {
            return TextButton(
              onPressed: () {},
              child: Text('Loading'),
              style: kSmallDisableButton,
            );
          }
        });
  }
}
