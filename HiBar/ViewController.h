//
//  ViewController.h
//  HiBar
//
//  Created by Akilesh Bapu on 1/16/15.
//  Copyright (c) 2015 HiBar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *pebbleconnect;
@property (strong, nonatomic) IBOutlet UITextField *weight;
@property (strong, nonatomic) IBOutlet UILabel *weightdisplay;
@property (strong, nonatomic) IBOutlet UITextField *reps;
@property (strong, nonatomic) IBOutlet UILabel *test;
@property (strong, nonatomic) IBOutlet UILabel *wobblexLabel;
@property (strong, nonatomic) IBOutlet UILabel *wobbleyLabel;



@property (strong, nonatomic) IBOutlet UILabel *repsdisplay;
- (IBAction)workoutResult:(id)sender;
- (IBAction)finishButton:(id)sender;

- (IBAction)finishWorkout:(id)sender;

- (IBAction)startWorkout:(id)sender;

- (IBAction)benchPress:(UIButton *)sender;
- (IBAction)weightenter:(id)sender;
- (IBAction)repsenter:(id)sender;
- (IBAction)nslogb:(id)sender;

@end


