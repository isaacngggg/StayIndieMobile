import 'package:flutter/material.dart';
import 'package:stay_indie/constants.dart';
import 'package:stay_indie/models/ConnectionRequest.dart';
import 'package:stay_indie/models/Profile.dart';
import 'package:stay_indie/widgets/GRBottomSheet.dart';

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
  late bool isConnected =
      widget.userProfile.connectionsProfileIds.contains(currentUserId);

  late bool requestPendingSnapshot;
  late bool receivedRequestSnapshot;
  @override
  void initState() {
    // TODO: implement initState
    ConnectionRequest.getProfileConnectionRequests(widget.userProfile.id)
        .then((value) {
      // print("Getting all the connection Requests for ${widget.userProfile.id}" +
      //     value.toString());
    });

    setState(() {
      requestPending = ConnectionRequest.isRequested(widget.userProfile.id);
      receivedRequest = ConnectionRequest.needToAccept(widget.userProfile.id);
      isConnected =
          widget.userProfile.connectionsProfileIds!.contains(currentUserId);
      // print(isConnected);
      // print("Connections:  ${widget.userProfile.connectionsProfileIds}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([requestPending, receivedRequest]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // print('Snapshot: ' + snapshot.toString());
            if (snapshot.hasError) {
              return Text('Snapshot Error: ${snapshot.error}');
            } else {
              requestPendingSnapshot = snapshot.data![0];
              receivedRequestSnapshot = snapshot.data![1];

              if (isConnected) {
                return TextButton(
                  onPressed: () {
                    GRBottomSheet.buildBottomSheet(
                      context,
                      Column(
                        children: [
                          Text('Connected'),
                          TextButton(
                            onPressed: () {},
                            child: Text('Remove Connection'),
                            style: kSmallPrimaryButtonStyle,
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('Connected'),
                  style: kSmallSecondaryButtonStyle,
                );
              } else if (requestPendingSnapshot) {
                return TextButton(
                  onPressed: () {
                    ConnectionRequest.getRequest(
                            currentUserId, widget.userProfile.id)
                        .then((value) {
                      if (value != null) {
                        ConnectionRequest.deleteRequest(value.id);
                        setState(() {
                          requestPending = Future.value(false);
                          // receivedRequestSnapshot = false;
                        });
                      }
                    });
                  },
                  child: Text('Request Pending'),
                  style: kSmallSecondaryButtonStyle,
                );
              } else if (receivedRequestSnapshot) {
                return TextButton(
                  onPressed: () {
                    print('Accepting Request');
                    ConnectionRequest.getRequest(
                            widget.userProfile.id, currentUserId)
                        .then((value) {
                      if (value != null) {
                        ConnectionRequest.acceptRequest(value.id);
                        setState(() {
                          receivedRequest = Future.value(false);
                          isConnected = true;
                        });
                      }
                    });
                  },
                  child: Text('Accept Request'),
                  style: kSmallPrimaryButtonStyle,
                );
              } else {
                return TextButton(
                  onPressed: () {
                    ConnectionRequest.sendRequest(widget.userProfile.id);
                    setState(() {
                      requestPending = Future.value(true);
                      isConnected = false;
                    });
                  },
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
