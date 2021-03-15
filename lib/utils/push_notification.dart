import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../common/config.dart';
import '../models/post.dart';
import '../screen/single_post.dart';
import 'network/wordpress_apis.dart';

class PushNotifications {
  const PushNotifications();

  static Future activate() async {
    await OneSignal.shared.setSubscription(true);
  }

  static Future deactivate() async {
    await OneSignal.shared.setSubscription(false);
  }

  static Future init() async {
    // Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init(oneSignalAppId, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false,
    });

    OneSignal.shared.setInFocusDisplayType(
      OSNotificationDisplayType.notification,
    );

    // The promptForPushNotificationsWithUserResponse function will show
    // the iOS push notification prompt.
    // We recommend removing the following code and instead using
    // an In-App Message to prompt for notification permission.
    await OneSignal.shared.promptUserForPushNotificationPermission(
      fallbackToSettings: true,
    );

    OneSignal.shared.setNotificationOpenedHandler(
      (OSNotificationOpenedResult result) {
        final notification = result.notification;
        final additionalData = notification.payload.additionalData;

        if (additionalData != null && additionalData['id'] != null) {
          handlePostNotifications(notification);
          return;
        }

        handleOtherNotifications();
      },
    );
  }

  static Future<void> handleOtherNotifications() async {
    //TODO
  }

  static Future<void> handlePostNotifications(OSNotification notification) async {
    final Map raw = await WpApi.getPost(
      id: int.parse(notification.payload.additionalData['id'].toString()),
      request: {
        '_fields': 'id,date,title,content,custom,link',
      },
    );
    final Post post = Post.fromJson(raw['body'] as Map);
    SinglePost(
      post: post,
      heroId: '${post.id}',
    );
  }

  static Future<bool> isActive() async {
    final state = await OneSignal.shared.getPermissionSubscriptionState();
    return state.subscriptionStatus.subscribed;
  }
}
