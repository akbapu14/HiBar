//
//  AppDelegate.h
//  HiBar
//
//  Created by Akilesh Bapu on 1/16/15.
//  Copyright (c) 2015 HiBar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <PebbleKit/PebbleKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSNumber *wobbleX;
@property (strong, nonatomic) NSNumber *wobbleY;
-(NSNumber*)getDuration;  //add this before the @end
-(NSNumber*)getWobbleY;  //add this before the @end
-(NSNumber*)getWobbleX;  //add this before the @end

@property (strong, nonatomic) PBWatch *connectedWatch;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

