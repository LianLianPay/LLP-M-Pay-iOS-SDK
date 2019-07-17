//
//  LLPAppDelegate.m
//  LLMPay
//
//  Created by LLPayiOSDev on 11/08/2018.
//  Copyright (c) 2018 LianLian Pay. All rights reserved.
//

#import "LLPAppDelegate.h"
#import <LLMPay/LLEBankPay.h>
#import <LLMPay/LLMPay.h>

@implementation LLPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [LLMPay registerApp:@""];
//    });
    return YES;
}

//iOS 9 before
- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return [LLMPay handleOpenURL:url];
    }
    if ([url.scheme hasPrefix:@"ll"] || [url.scheme hasPrefix:@"lian"]) {
        return [LLEBankPay handleOpenURL:url];
    }
    return YES;
}

// iOS 9 later
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return [LLMPay handleOpenURL:url];
    }
    if ([url.scheme hasPrefix:@"ll"] || [url.scheme hasPrefix:@"lian"]) {
        return [LLEBankPay handleOpenURL:url];
    }
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [LLEBankPay handleOpenURL:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary
    // interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the
    // transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this
    // method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state
    // information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user
    // quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was
    // previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
