//
//  AddExerciseViewController.h
//  HiBar
//
//  Created by CavanKlinsky on 1/17/15.
//  Copyright (c) 2015 HiBar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExerciseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ExLabel;
@property (weak, nonatomic) IBOutlet UITextField *Sets;
@property (weak, nonatomic) IBOutlet UITextField *Reps;
@property (weak, nonatomic) IBOutlet UITextField *Weight;
@property (weak, nonatomic) IBOutlet UIButton *AddButton;

@end
