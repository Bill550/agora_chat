// ignore: file_names
import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'http_functions.dart';

class ChatFuncations {
  static void initSDK() async {
    ChatOptions options = ChatOptions(
      // Sets your app key applied via Agora Console.
      appKey: "41117440#383391",
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);
  }

///////////////////////////SignUp/////////////////////////////////////////
  static signUp(
    String userId,
    String password,
  ) async {
    if (userId.isEmpty || password.isEmpty) {
      // _addLogToConsole("userId or password is invalid");
      return "userId or password is invalid";
    }
    bool ret = await HttpRequestManager.registerToAppServer(
      userId: userId,
      password: password,
    );
    if (ret) {
      // _addLogToConsole("sign up succeed, userId: $userId");
      return "sign up succeed, userId: $userId";
    } else {
      // _addLogToConsole("sign up failed");
      return "sign up failed";
    }
  }

/////////////////////////////////////////////////////////////////////////
///////////////////////////SignIn///////////////////////////////////////
  static signIn(String userId, String password) async {
    if (userId.isEmpty || password.isEmpty) {
      // _addLogToConsole("userId or password is invalid");

      return "userId or password is invalid";
    }
    String? agoraToken = await HttpRequestManager.loginToAppServer(
      userId: userId,
      password: password,
    );
    if (agoraToken != null) {
      // _addLogToConsole("fetch agora token succeed, begin login");
      try {
        await ChatClient.getInstance.loginWithAgoraToken(userId, agoraToken);
        // _addLogToConsole("login succeed, userId: $userId");
        return "login succeed, userId: $userId";
      } on ChatError catch (e) {
        // _addLogToConsole(
        //     "login failed, code: ${e.code}, desc: ${e.description}");
        return "login failed, code: ${e.code}, desc: ${e.description}";
      }
    } else {
      // _addLogToConsole("fetch agora token failed");
      return "fetch agora token failed";
    }
  }

///////////////////////////////////////////////////////////////////////
///////////////////////Signout////////////////////////////////////////
  static signOut() async {
    try {
      await ChatClient.getInstance.logout(true);
      // _addLogToConsole("sign out succeed");
      return "sign out succeed";
    } on ChatError catch (e) {
      // _addLogToConsole(
      //     "sign out failed, code: ${e.code}, desc: ${e.description}");
      return "sign out failed, code: ${e.code}, desc: ${e.description}";
    }
  }

/////////////////////////////////////////////////////////////////////
//////////////////////////Send-Message//////////////////////////////
  static sendMessage(String chatId, String messageContent) async {
    if (chatId.isEmpty || messageContent.isEmpty) {
      // _addLogToConsole("single chat id or message content is invalid");
      return "single chat id or message content is invalid";
    }
    var msg = ChatMessage.createTxtSendMessage(
      targetId: chatId,
      content: messageContent,
    );
    msg.setMessageStatusCallBack(MessageStatusCallBack(
      onSuccess: () {
        // _addLogToConsole("send message succeed");
        // return "send message succeed";
        return;
      },
      onError: (e) {
        // _addLogToConsole(
        //   "send message failed, code: ${e.code}, desc: ${e.description}",
        // );
      },
    ));
    await ChatClient.getInstance.chatManager.sendMessage(msg);
  }

///////////////////////////////////////////////////////////////////
////////////////////////////Add-Chat-Listener/////////////////////
  static void addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }

//////////////////////////////////////////////////////////////
//////////////////////////On-Messages-Received////////////////
  static onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            // _addLogToConsole(
            //   "receive text message: ${body.content}, from: ${msg.from}",
            // );
            return "receive text message: ${body.content}, from: ${msg.from}";
          }
        case MessageType.IMAGE:
          {
            // _addLogToConsole(
            //   "receive image message, from: ${msg.from}",
            // );
            return "receive image message, from: ${msg.from}";
          }
        // break;
        case MessageType.VIDEO:
          {
            // _addLogToConsole(
            //   "receive video message, from: ${msg.from}",
            // );
            return "receive video message, from: ${msg.from}";
          }
        // break;
        case MessageType.LOCATION:
          {
            // _addLogToConsole(
            //   "receive location message, from: ${msg.from}",
            // );
            return "receive location message, from: ${msg.from}";
          }
        // break;
        case MessageType.VOICE:
          {
            // _addLogToConsole(
            //   "receive voice message, from: ${msg.from}",
            // );
            return "receive voice message, from: ${msg.from}";
          }
        // break;
        case MessageType.FILE:
          {
            // _addLogToConsole(
            //   "receive image message, from: ${msg.from}",
            // );
            return "receive image message, from: ${msg.from}";
          }
        // break;
        case MessageType.CUSTOM:
          {
            // _addLogToConsole(
            //   "receive custom message, from: ${msg.from}",
            // );

            return "receive custom message, from: ${msg.from}";
          }
          // break;
        case MessageType.CMD:
          {
            // Receiving command messages does not trigger the `onMessagesReceived` event, but triggers the `onCmdMessagesReceived` event instead.
          }
          break;
      }
    }
  }

  static disposeChat(){
    ChatClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
  }
}
