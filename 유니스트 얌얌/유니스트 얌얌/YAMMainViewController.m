//
//  YAMMainViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 13..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMMainViewController.h"
#import "YAMDeliveryViewController.h"
#import "YAMBusViewController.h"
#import "YAM114ViewController.h"
#import "YAMCarteViewController.h"
#import "YAMAppDelegate.h"
#import "YAMQnAViewController.h"

@interface YAMMainViewController ()

@end

@implementation YAMMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadView
{
    [super loadView];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if (result.height == 480) {
            // iPhone Classic
            [[NSBundle mainBundle] loadNibNamed:@"YAMMainViewController" owner:self options:nil];
        } else if(result.height == 568) {
            // iPhone 5
            [[NSBundle mainBundle] loadNibNamed:@"YAMMainViewController-5" owner:self options:nil];
        }
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    YAMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.viewController.rightViewController = nil;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction) gotoDelivery:(id)sender {
    YAMDeliveryViewController *deliveryVC = [[YAMDeliveryViewController alloc] initWithNibName:@"YAMDeliveryViewController-5" bundle:nil];
    [self.navigationController pushViewController:deliveryVC animated:YES];
}

- (IBAction) gotoBus:(id)sender {
    YAMBusViewController *busVC = [[YAMBusViewController alloc] initWithNibName:@"YAMBusViewController" bundle:nil];
    [self.navigationController pushViewController:busVC animated:YES];
}

- (IBAction) goto114:(id)sender {
    YAM114ViewController *infoVC = [[YAM114ViewController alloc] initWithNibName:@"YAM114ViewController" bundle:nil];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (IBAction)gotoCarte:(id)sender {
    YAMCarteViewController *carteVC = [[YAMCarteViewController alloc] initWithNibName:@"YAMCarteViewController" bundle:nil];
    [self.navigationController pushViewController:carteVC animated:YES];
}

- (IBAction)gotoQnA:(id)sender {
    YAMQnAViewController *QnAVC = [[YAMQnAViewController alloc] initWithNibName:@"YAMQnAViewController" bundle:nil];
    [self.navigationController pushViewController:QnAVC animated:YES];
}

@end
