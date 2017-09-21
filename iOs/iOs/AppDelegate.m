//
//  AppDelegate.m
//  iOs
//
//  Created by Bernardo Breder on 05/03/14.
//  Copyright (c) 2014 Bernardo Breder. All rights reserved.
//

#import "AppDelegate.h"
#import "GalleryViewController.h"
#import "GalleryDatabase.h"

@implementation AppDelegate

@synthesize database;
@synthesize window;
@synthesize secondWindow;
@synthesize mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    database = [[GalleryDatabase alloc] init];
    [self setUpScreenConnectionNotificationHandlers];
    if ([UIScreen screens].count > 1) {
        UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
        secondWindow = [[UIWindow alloc] initWithFrame:secondScreen.bounds];
        secondWindow.screen = secondScreen;
        secondWindow.hidden = YES;
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    window = [[UIWindow alloc] initWithFrame:frame];
    window.backgroundColor = [UIColor whiteColor];
    mainViewController = [[GalleryViewController alloc] init];
    mainViewController.secondWindow = secondWindow;
    mainViewController.database = database;
    window.rootViewController = mainViewController;
    [window makeKeyAndVisible];
    return YES;
}

- (void)setUpScreenConnectionNotificationHandlers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
                   name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
                   name:UIScreenDidDisconnectNotification object:nil];
}

- (void)handleScreenDidConnectNotification:(NSNotification*)aNotification
{
    UIScreen *newScreen = [aNotification object];
    CGRect screenBounds = newScreen.bounds;
    if (!secondWindow)
    {
        secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        secondWindow.screen = newScreen;
        mainViewController.secondWindow = secondWindow;
    }
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification
{
    if (secondWindow)
    {
        secondWindow.hidden = YES;
        secondWindow = nil;
        mainViewController.secondWindow = nil;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)start
{
    [database connect];
    if (0) {
        if ([UIScreen screens].count > 1) {
            UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
            secondWindow = [[UIWindow alloc] initWithFrame:secondScreen.bounds];
            secondWindow.screen = secondScreen;
            mainViewController.secondWindow = secondWindow;
        }
    }
}

- (void)stop
{
    [database close];
    if (0) {
        if ([UIScreen screens].count > 1) {
            secondWindow.screen = nil;
            secondWindow = nil;
            mainViewController.secondWindow = nil;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self stop];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self stop];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self start];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self stop];
}

@end
