//
//  FCMSharedInstance.m
//  TradeDesk
//
//  Created by Hitesh.surani on 27/06/17.
//  Copyright © 2017 brainvire. All rights reserved.
//

#import "FCMSharedManager.h"
//#define FCM_DEVICE_TOKEN @"FCMDevicetoken"

@implementation FCMSharedManager
//@synthesize isInvokedKillState,TokenType;
//
//+ (FCMSharedManager *)sharedInstance
//{
//    static FCMSharedManager *sharedInstance = nil;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedInstance = [[self alloc] init];
//
//    });
//    return sharedInstance;
//}
//
//-(void) RegisterForPushNotification:(FIRMessagingAPNSTokenType) ApnsTokenType :(id) launchOptions{
//    
//    TokenType = ApnsTokenType;
//    [FIRApp configure];
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
//        UIUserNotificationType allNotificationTypes =
//        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
//        UIUserNotificationSettings *settings =
//        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    } else {
//        // iOS 10 or later
//#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//        // For iOS 10 display notification (sent via APNS)
//        [[UNUserNotificationCenter currentNotificationCenter] setDelegate:(id<UNUserNotificationCenterDelegate> _Nullable)self];
//        UNAuthorizationOptions authOptions =
//        UNAuthorizationOptionAlert
//        | UNAuthorizationOptionSound
//        | UNAuthorizationOptionBadge;
//        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (!granted) {
//                if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(FailedToRegisterForPushNotification:)]) {
//                    
//                    [[[UIApplication sharedApplication] delegate] performSelector:@selector(FailedToRegisterForPushNotification:) withObject:error];
//                }
//            }
//        }];
//#endif
//    }
//    
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFCMDeviceToken) name:kFIRInstanceIDTokenRefreshNotification object:nil];
//    
//    NSDictionary *dicPushNotification = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    isInvokedKillState = NO;
//    if(dicPushNotification) {
//        isInvokedKillState = YES;
//        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
//            [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:dicPushNotification];
//        }
//    }
//}
//
//- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
//    
//    NSLog(@"FCM registration token: %@", fcmToken);
//    [self SaveApnsToken:fcmToken];
//    
//    
//}
//
//
//#pragma mark - Push Notification Methods
//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings{
//    NSLog(@"Registering device for push notifications..."); //iOS8
//    [application registerForRemoteNotifications];
//}
//
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token{
//    NSLog(@"Registration successful, bundle identifier: %@, mode: %@, device token: %@",
//          [NSBundle.mainBundle bundleIdentifier], @"No Mode String", token);
//    const unsigned *tokenBytes = [token bytes];
//    NSString *strhexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
//                             ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
//                             ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
//                             ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
//    NSLog(@"Device Token String:%@",strhexToken);
//
//    [[FIRMessaging messaging] setAPNSToken:token type:TokenType];
//    
//}
//
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
//    if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(FailedToRegisterForPushNotification:)]) {
//        [[[UIApplication sharedApplication] delegate] performSelector:@selector(FailedToRegisterForPushNotification:) withObject:error];
//    }
//    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:FCM_DEVICE_TOKEN];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//
//    
//}
//
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
//forRemoteNotification:(NSDictionary *)notification completionHandler:(void(^)())completionHandler{
//    NSLog(@"Received push notification: %@, identifier: %@", notification, identifier); //iOS8
//    completionHandler();
//}
//
//
//
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification{
//    NSLog(@"Received push notification: %@", notification); //iOS7 and earlier
//    
//        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive){
//            
//            if (isInvokedKillState) // true
//            {
//                isInvokedKillState = false;
//                if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(applicationReceivedNotificationInKillState:)]) {
//                    
//                    [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationReceivedNotificationInKillState:) withObject:notification];
//                }
//
//            }
//            else
//            {
//                if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(applicationReceivedNotificationInForgroundState:)]) {
//                    
//                    [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationReceivedNotificationInForgroundState:) withObject:notification];
//                }
//            }
//        }
//        else if ( [[UIApplication sharedApplication] applicationState]== UIApplicationStateActive || [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
//
//            if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(applicationReceivedNotificationInActiveState:)]) {
//                
//                [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationReceivedNotificationInActiveState:) withObject:notification];
//            }
//        }
//}
//
//#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center
//       willPresentNotification:(UNNotification *)notification
//         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    
//    if ( [[UIApplication sharedApplication] applicationState]== UIApplicationStateActive || [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
//        
//        if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(applicationReceivedNotificationInActiveState:)]) {
//            
//            [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationReceivedNotificationInActiveState:) withObject:notification.request.content.userInfo];
//            
//            NSLog(@"%@",notification.request.content.userInfo);
//        }
//    }
//    completionHandler(UNNotificationPresentationOptionNone);
//}
//
//// Handle notification messages after display notification is tapped by the user.
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center
//didReceiveNotificationResponse:(UNNotificationResponse *)response
//         withCompletionHandler:(void (^)())completionHandler {
//    
//
//        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive){
//            
//            if (isInvokedKillState) // true
//            {
//                isInvokedKillState = false;
//                // Redirect to Notification from Here Kill State....
//                
//                if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(applicationReceivedNotificationInKillState:)]) {
//                    
//                    [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationReceivedNotificationInKillState:) withObject:response.notification.request.content.userInfo];
//                }
//            }
//            else
//            {
//                if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(applicationReceivedNotificationInForgroundState:)]) {
//                    
//                    [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationReceivedNotificationInForgroundState:) withObject:response.notification.request.content.userInfo];
//                }
//            }
//        }
//        else if ( [[UIApplication sharedApplication] applicationState]== UIApplicationStateActive || [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
//            
//            
//            if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(applicationReceivedNotificationInActiveState:)]) {
//                
//                [[[UIApplication sharedApplication] delegate] performSelector:@selector(applicationReceivedNotificationInActiveState:) withObject:response.notification.request.content.userInfo];
//            }
//            
//        }
//
//    
//    completionHandler();
//}
//#endif
//
//-(void)SaveApnsToken:(NSString *)strToken
//{
//    //Get the documents directory path
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"plist.plist"];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath: path]) {
//        
//        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"plist.plist"] ];
//    }
//    
//    NSMutableDictionary *data;
//    
//    {
//        // If the file doesn’t exist, create an empty dictionary
//        data = [[NSMutableDictionary alloc] init];
//    }
//    
//    //To insert the data into the plist
//    [data setObject:strToken forKey:@"value"];
//    [data writeToFile:path atomically:YES];
//    
//}
//
//
//-(void)setFCMDeviceToken
//{
////    FIRMessagingAPNSTokenType
//    if ([[FIRMessaging messaging] FCMToken]) {
//         [[NSUserDefaults standardUserDefaults]setValue:[[FIRMessaging messaging] FCMToken] forKey:FCM_DEVICE_TOKEN];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        [self SaveApnsToken:[[FIRMessaging messaging] FCMToken]];
//        NSLog(@"FCM Token: %@",[[FIRMessaging messaging] FCMToken]);
//    }
//}
//
//-(NSString *)getFCMDeviceToken
//{
//    if([[NSUserDefaults standardUserDefaults]valueForKey:FCM_DEVICE_TOKEN]){
//        return  [[NSUserDefaults standardUserDefaults]valueForKey:FCM_DEVICE_TOKEN];
//    }else{
//        return @"";
//    }
//}
//
//
//
//-(void)applicationReceivedNotificationInKillState:(NSDictionary*) notification{
//    
//}
//
//-(void)applicationReceivedNotificationInForgroundState:(NSDictionary*) notification{
//}
//
//-(void)applicationReceivedNotificationInActiveState:(NSDictionary*) notification{
//
//}
//
//-(void)FailedToRegisterForPushNotification:(NSError*)error{
//    
//}
//

@end
