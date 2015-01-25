//
//  AppDelegate.m
//  HiBar
//
//  Created by Akilesh Bapu on 1/16/15.
//  Copyright (c) 2015 HiBar. All rights reserved.
//

#import "AppDelegate.h"
#import <PebbleKit/PebbleKit.h>
@interface AppDelegate ()<PBPebbleCentralDelegate>
@property (nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray *exercises;


@end

@implementation AppDelegate
-(NSNumber*)getDuration
{
    return _duration;
}
-(NSNumber*)getWobbleX
{
    return _wobbleX;
}
-(NSNumber*)getWobbleY
{
    return  _wobbleY;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *exercise1 = @{ @(11):@"Bench Press",
                                 @(12):@"150 Pounds",
                                 @(13):[NSNumber numberWithUint32:3],
                                 @(14):[NSNumber numberWithUint32:3],
                                 @(15):[NSNumber numberWithUint32:1]
                                 };
    NSDictionary *exercise2 = @{ @(11):@"Bench Press",
                                 @(12):@"170 Pounds",
                                 @(13):[NSNumber numberWithUint32:3],
                    
                                 @(14):[NSNumber numberWithUint32:3],
                                 @(15):[NSNumber numberWithUint32:2]
                                 };
    NSDictionary *exercise3 = @{ @(11):@"Bench Press",
                                 @(12):@"185 Pounds",
                                 @(13):[NSNumber numberWithUint32:3],
                                 @(14):[NSNumber numberWithUint32:3],
                                 @(15):[NSNumber numberWithUint32:3]
                                 };
    _exercises = @[exercise1,exercise2,exercise3];
    _index= 0;
    

    
    [[PBPebbleCentral defaultCentral] setDelegate:self];
    uuid_t myAppUUIDbytes;
    NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"a0dd135f-96b0-4b0e-9afa-608e3d2e9c73"];
    [myAppUUID getUUIDBytes:myAppUUIDbytes];
    
    [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:sizeof(uuid_t)]];
    
    PBWatch *lastWatch = [[[PBPebbleCentral defaultCentral] connectedWatches] firstObject];
    if (lastWatch) {
        [self pebbleCentral:[PBPebbleCentral defaultCentral] watchDidConnect:lastWatch isNew:NO];
    }

    // Override point for customization after application launch.
    return YES;
}
    
- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    if (!self.connectedWatch) {
        NSLog(@"Pebble connected: %@", [watch name]);
        //pebbleconnect.text = @"Pebble Connected";
        self.connectedWatch = watch;
    }
}


- (void) setConnectedWatch:(PBWatch*)watch {
    if (!_connectedWatch) {
        NSLog(@"setting listener");
        _connectedWatch = watch;
        [watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
            if (isAppMessagesSupported) {
                
                
                // Configure our communications channel to target the weather app:
                // See demos/feature_app_messages/weather.c in the native watch app SDK for the same definition on the watch's end:
                [watch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
                  NSLog(@"Received message: %@", update);
                    
                    if (!update) {
                        NSLog(@"Waiting on Watch");
                    }
                    if (update[@1]) {
                        
                        if (_index > _exercises.count -1) {
                            _index=0;
                            NSDictionary *update = @{@(16):@"Finish Workout" };
                            NSLog(@"Finish Workout");
                            
                            
                            [self.connectedWatch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
                                if (!error) {
                                    NSLog(@"Successfully sent message.");
                                }
                                else {
                                    NSLog(@"Error sending message: %@", error);
                                }
                            }];
                            
                            NSLog(@"finishcount");
                        } else {
                            [self.connectedWatch appMessagesPushUpdate:_exercises[_index] onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
                                if (!error) {
                                    NSLog(@"Successfully chose Workout Name");
                                }
                                else {
                                    NSLog(@"Error sending message: %@", error);
                                }
                            }];
                            _index++;
                        }

                        

                        
                    }
                        NSLog(@"%@", update);
                     if (update[@2]) {
                         NSLog(@"Duration: %@", update[@2]);
                         _duration = update[@2];
                                                
                         NSLog(@"%@", [_duration class]);
                     };
                    if (update[@3]) {
                        _wobbleX = update[@3];
                    }
                    
                    if (update[@4]) {
                        _wobbleY = update[@4];
                    }
                   
                    
                    

                    
                    
                    
                    return YES;
                }];
                
                //NSString *message = [NSString stringWithFormat:@"Yay! %@ supports AppMessages :D", [watch name]];;
                //[[[UIAlertView alloc] initWithTitle:@"Connected!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            } else {
                
                // NSString *message = [NSString stringWithFormat:@"Blegh... %@ does NOT support AppMessages :'(", [watch name]];
                // [[[UIAlertView alloc] initWithTitle:@"Connected..." message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }
    
    NSLog(@"setConnectedWatch");
    // NOTE:
    // For demonstration purposes, we start communicating with the watch immediately upon connection,
    // because we are calling -appMessagesGetIsSupported: here, which implicitely opens the communication session.
    // Real world apps should communicate only if the user is actively using the app, because there
    // is one communication session that is shared between all 3rd party iOS apps.
    
    // Test if the Pebble's firmware supports AppMessages / Weather:
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    NSLog(@"Pebble disconnected: %@", [watch name]);
    
    if (self.connectedWatch == watch || [watch isEqual:self.connectedWatch]) {
        self.connectedWatch = nil;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.AkBapu.HiBar" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HiBar" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HiBar.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
