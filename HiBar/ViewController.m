//
//  ViewController.m
//  HiBar
//
//  Created by Akilesh Bapu on 1/16/15.
//  Copyright (c) 2015 HiBar. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSArray *tableData;
    
}
@synthesize weight, weightdisplay, reps, repsdisplay,pebbleconnect, test,wobblexLabel,wobbleyLabel;

- (PBWatch*) watch {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate.connectedWatch;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    // Create the request.
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"workouts" ofType:@"plist"];
    //NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSData *dataPull = [self getDataFrom: @"http://104.236.38.240/workout"];
    //NSLog(@"%@", dataPull);
    NSError *jsonParsingError = nil;
    NSDictionary* jsonDec = [NSJSONSerialization JSONObjectWithData:dataPull options:NSJSONReadingAllowFragments error:&jsonParsingError];
   
                               NSLog(@"%@", jsonDec[@"workouts"]);
    NSArray *keyArray = jsonDec[@"workouts"];
    tableData = keyArray;
    
    
}



- (NSData *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    //NSLog(@"%@", oResponseData);
   
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        return nil;
    }
    else
        NSLog(@"Helloworld");
    
 return oResponseData;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"WorkoutCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *workout = [tableData objectAtIndex:indexPath.row];
    NSLog(@"%@",workout[@"name"]);
    cell.textLabel.text = workout[@"name"];
    return cell;
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weightenter:(id)sender {
    
    NSString * weightinput= weight.text;

    weightdisplay.text=weightinput;
    NSLog(@"%@", weightinput);
    NSDictionary *update = @{ @(0):[NSNumber numberWithUint8:42],
                              @(1):@"Bench Press" };
    
    [self.watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message1.");
        }
        else {
            NSLog(@"Error sending message1: %@", error);
        }
    }];
}
- (IBAction)nslogb:(id)sender {
}
- (IBAction)repsenter:(id)sender {
    NSString * repsinput= reps.text;
    
    repsdisplay.text=repsinput;
    NSLog(@"%@", repsinput);

    NSDictionary *update = @{ @(0):[NSNumber numberWithUint8:42],
                              @(1):@"Variable" };
    [self.watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message2.");
        }
        else {
            NSLog(@"Error sending message2: %@", error);
        }
    }];
}

- (IBAction)workoutResult:(id)sender {
   
}

- (IBAction)finishButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    test.text = [[appDelegate getDuration] stringValue];
    // NSLog(@"Error sending message2: %@", inStr);
   
    wobblexLabel.text =  [[appDelegate getWobbleX] stringValue];
    wobbleyLabel.text =  [[appDelegate getWobbleY] stringValue];
    
    
    
    
}

- (IBAction)finishWorkout:(id)sender {
    NSDictionary *update = @{
                             @(16):@"Finish Workout" };
    
    
    [self.watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}

- (IBAction)startWorkout:(id)sender {
    NSDictionary *update = @{
                              @(10):@"Start Workout?" };
    

    [self.watch appMessagesPushUpdate:update onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
        if (!error) {
            NSLog(@"Successfully sent message.");
        }
        else {
            NSLog(@"Error sending message: %@", error);
        }
    }];
}

- (IBAction)benchPress:(UIButton *)sender {

}

@end
