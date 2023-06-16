import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:study247/constants/common.dart';

final meetingControllerProvider =
    ChangeNotifierProvider((ref) => MeetingController());

class MeetingController extends ChangeNotifier {
  bool micEnabled = false;
  bool camEnabled = false;

  Future<String> createMeeting() async {
    final http.Response httpResponse = await http.post(
      Uri.parse("https://api.videosdk.live/v2/rooms"),
      headers: {'Authorization': Constants.videoSDKToken},
    );

    return json.decode(httpResponse.body)['roomId'];
  }
}
