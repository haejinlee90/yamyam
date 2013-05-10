//
//  YAMBusViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 14..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMBusViewController.h"
#import "AFJSONRequestOperation.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface YAMBusViewController ()

@end

@implementation YAMBusViewController
@synthesize busTime;
@synthesize indicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setTextAnimation:(UILabel *)label withNewText:(NSString *)newText {
    [UIView beginAnimations:@"animateText" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0f];
    [label setAlpha:0];
    [label setText:newText];
    [label setAlpha:1];
    [UIView commitAnimations];
}

- (void) setBusTime:(NSDictionary *)BusTime {
    NSDate *date = [NSDate date];
    NSLog(@"%@", date);
    
    NSTimeZone *seoul = [NSTimeZone timeZoneWithName:@"Asia/Seoul"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    timeFormatter.timeZone = seoul;
    
    NSDateFormatter *todayFormatter = [[NSDateFormatter alloc] init];
    todayFormatter.dateFormat = @"yyyy-MM-dd";
    [todayFormatter setTimeZone:seoul];
    
    NSDateFormatter *currentFormatter = [[NSDateFormatter alloc] init];
    currentFormatter.dateFormat = @" HH:mm";
    [todayFormatter setTimeZone:seoul];
    
    
    NSString *currentTime = [currentFormatter stringFromDate:[NSDate date]];
    NSLog(@"current: %@", currentTime);
    NSDate *current = [currentFormatter dateFromString:currentTime];
    
    NSDateFormatter *start = [[NSDateFormatter alloc] init];
    start.dateFormat = @"기점 출발 HH:mm";
    
    
    NSString *bus133 = [BusTime objectForKey:@"bus133"];
    NSDate *bus133_leaveTime = [start dateFromString:bus133];
    NSString *bus133_leave_time = [currentFormatter stringFromDate:bus133_leaveTime];
    
    NSLog(@"bus133 leave time: %@", bus133_leave_time);
    
    
    NSString *bus233 = [BusTime objectForKey:@"bus233"];
    NSDate *bus233_leaveTime = [start dateFromString:bus233];
    NSString *bus233_leave_time = [currentFormatter stringFromDate:bus233_leaveTime];
    
    NSLog(@"bus233 leave %@", bus233_leave_time);
    
    NSString *bus733 = [BusTime objectForKey:@"bus733"];
    NSDate *bus733_leaveTime = [start dateFromString:bus733];
    NSString *bus733_leave_time = [currentFormatter stringFromDate:bus733_leaveTime];
    
    NSLog(@"bus733 leave %@", bus733_leave_time);
    
    double time_interval_133 = [bus133_leaveTime timeIntervalSinceDate:current];
    double time_interval_233 = [bus233_leaveTime timeIntervalSinceDate:current];
    double time_interval_733 = [bus733_leaveTime timeIntervalSinceDate:current];
    
    NSString *timeTo133 = [NSString stringWithFormat:@"%d분", (int)(time_interval_133/60)];
    NSString *timeTo233 = [NSString stringWithFormat:@"%d분", (int)(time_interval_233/60)];
    NSString *timeTo733 = [NSString stringWithFormat:@"%d분", (int)(time_interval_733/60)];
    
    if ([[BusTime objectForKey:@"bus133"] isEqualToString:@"운행종료"])
        timeTo133 = @"운행종료";
    if ([[BusTime objectForKey:@"bus233"] isEqualToString:@"운행종료"])
        timeTo233 = @"운행종료";
    if ([[BusTime objectForKey:@"bus733"] isEqualToString:@"운행종료"])
        timeTo733 = @"운행종료";

    NSLog(@"%@, %@, %@", timeTo133, timeTo233, timeTo733);
    
    UILabel *label133_1 = (UILabel *)[self.view viewWithTag:1];
    //[[UILabel alloc] initWithFrame:CGRectMake(120, 122, 180, 30)];
    label133_1.text = [NSString stringWithFormat:@"%@에 출발합니다.", bus133_leave_time];
    label133_1.textColor = UIColorFromRGB(0x656565);
    label133_1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label133_2 = (UILabel *)[self.view viewWithTag:2];
    label133_2.text = timeTo133;
    label133_2.textColor = UIColorFromRGB(0x1886C1);
    label133_2.textAlignment = NSTextAlignmentRight;
    [self setTextAnimation:label133_2 withNewText:label133_2.text];
    label133_2.alpha = 1;
    
    UILabel *label133_3 = (UILabel *)[self.view viewWithTag:3];
    label133_3.text = @"남았습니다.";
    [self setTextAnimation:label133_3 withNewText:label133_3.text];
    label133_3.alpha = 1;
    
    UILabel *leave133 = (UILabel *)[self.view viewWithTag:30];
    leave133.alpha = 0;
    if([timeTo133 intValue] <= 0){
        label133_2.alpha = 0;
        label133_3.alpha = 0;
        leave133.alpha = 1;
    }
    
    UILabel *label133_over = (UILabel *)[self.view viewWithTag:4];
    //[[UILabel alloc] initWithFrame:CGRectMake(130, 120, 170, 75)];
    label133_over.backgroundColor = [UIColor whiteColor];
    label133_over.text = @"운행종료";
    label133_over.textAlignment = NSTextAlignmentCenter;
    label133_over.alpha = 0;
    
    if ([timeTo133 isEqualToString:@"운행종료"]) {
        label133_over.alpha = 1;
    }

    
    UILabel *label233_1 = (UILabel *)[self.view viewWithTag:5];
    label233_1.text = [NSString stringWithFormat:@"%@에 출발합니다.", bus233_leave_time];
    label233_1.textColor = UIColorFromRGB(0x656565);
    label233_1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label233_2 = (UILabel *)[self.view viewWithTag:6];
    label233_2.text = timeTo233;
    label233_2.textColor = UIColorFromRGB(0xFC7309);
    label233_2.textAlignment = NSTextAlignmentRight;
    [self setTextAnimation:label233_2 withNewText:label233_2.text];
    label233_2.alpha = 1;
    
    UILabel *label233_3 = (UILabel *)[self.view viewWithTag:7];
    label233_3.text = @"남았습니다.";
    label233_3.alpha = 1;

    UILabel *leave233 = (UILabel *)[self.view viewWithTag:31];
    leave233.alpha = 0;
    if([timeTo233 intValue] <= 0) {
        label233_2.alpha = 0;
        label233_3.alpha = 0;
        leave233.alpha = 1;
    }
    
    UILabel *label233_over = (UILabel *)[self.view viewWithTag:8];
    label233_over.text = @"운행종료";
    label233_over.textAlignment = NSTextAlignmentCenter;
    label233_over.backgroundColor = [UIColor whiteColor];
    label233_over.alpha = 0;
    
    if ([timeTo233 isEqualToString:@"운행종료"]) {
        label233_over.alpha = 1;
    }
    
    UILabel *label733_1 = (UILabel *)[self.view viewWithTag:9];
    label733_1.text = [NSString stringWithFormat:@"%@에 출발합니다.", bus733_leave_time];
    label733_1.textColor = UIColorFromRGB(0x656565);
    label733_1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *label733_2 = (UILabel *)[self.view viewWithTag:10];
    label733_2.text = timeTo733;
    label733_2.textColor = UIColorFromRGB(0xBE0005);
    label733_2.textAlignment = NSTextAlignmentRight;
    [self setTextAnimation:label733_2 withNewText:label733_2.text];
    label733_2.alpha = 1;
    
    UILabel *label733_3 = (UILabel *)[self.view viewWithTag:11];
    label733_3.text = @"남았습니다.";
    label733_3.alpha = 1;

    UILabel *leave733 = (UILabel *)[self.view viewWithTag:32];
    leave733.alpha = 0;
    if ([timeTo733 intValue] <= 0) {
        label733_2.alpha = 0;
        label733_3.alpha = 0;
        leave733.alpha = 1;
    }
        
    
    UILabel *label733_over = (UILabel *)[self.view viewWithTag:12];
    label733_over.text = @"운행종료";
    label733_over.textAlignment = NSTextAlignmentCenter;
    label733_over.backgroundColor = [UIColor whiteColor];
    label733_over.alpha = 0;
    
    if([timeTo733 isEqualToString:@"운행종료"])
        label733_over.alpha = 1;
    
    
    NSString *toKTX = [BusTime objectForKey:@"bus337_ktx"];
    NSRange toKTX_range = [toKTX rangeOfString:@"분"];
    
    NSString *bus337_ktx_time = nil;
    if (toKTX_range.location != NSNotFound) {
        NSRange KTX_Range = NSMakeRange(0, toKTX_range.location-1);
        bus337_ktx_time = [toKTX substringWithRange:KTX_Range];
    } else {
        NSDate *bus337_leaveToKTX_Time = [start dateFromString:toKTX];
        double time_interval_337_ktx = [bus337_leaveToKTX_Time timeIntervalSinceDate:current];
        NSString *timeTo337 = [NSString stringWithFormat:@"%d", (int)(time_interval_337_ktx/60)+35];
        bus337_ktx_time = timeTo337;
    }
    
    NSLog(@"toKTX: %@", bus337_ktx_time);
    
    NSString *toTown = [BusTime objectForKey:@"bus337_town"];
    NSRange toTown_range = [toTown rangeOfString:@"분"];
    NSString *bus337_town_time = nil;
    if (toTown_range.location != NSNotFound) {
        NSRange TOWN_range = NSMakeRange(0, toTown_range.location-1);
        bus337_town_time = [toTown substringWithRange:TOWN_range];
    } else {
        NSDate *bus337_leaveToTown_Time = [start dateFromString:toTown];
        double time_interval_337_town = [bus337_leaveToTown_Time timeIntervalSinceDate:current];
        NSString *timeTo337_town = [NSString stringWithFormat:@"%d", (int)(time_interval_337_town/60)+20];
        bus337_town_time = timeTo337_town;
    }
    
    UILabel *toKTX_label_1 = (UILabel *)[self.view viewWithTag:13];
    toKTX_label_1.text = @"KTX방면 도착까지";
    toKTX_label_1.textColor = UIColorFromRGB(0x656565);
    
    UILabel *toKTX_label_2 = (UILabel *)[self.view viewWithTag:14];
    toKTX_label_2.text = [NSString stringWithFormat:@"%@분", bus337_ktx_time];
    toKTX_label_2.textColor = UIColorFromRGB(0x8511C0);
    toKTX_label_2.alpha = 1;
    [self setTextAnimation:toKTX_label_2 withNewText:toKTX_label_2.text];
    
    UILabel *toKTX_label_3 = (UILabel *)[self.view viewWithTag:15];
    toKTX_label_3.text = @"남았습니다.";
    toKTX_label_3.alpha = 1;
    
    UILabel *toKTX_over = (UILabel *)[self.view viewWithTag:19];
    toKTX_over.backgroundColor = [UIColor whiteColor];
    toKTX_over.alpha = 0;
    
    if (bus337_ktx_time.intValue <= 0) {
        toKTX_over.alpha = 1;
        toKTX_over.text = @"KTX방면 버스가 도착하였습니다.";
        [self setTextAnimation:toKTX_over withNewText:toKTX_over.text];
        toKTX_over.font = [UIFont systemFontOfSize:12];
        toKTX_label_2.alpha = 0;
        toKTX_label_3.alpha = 0;
    } else {
        toKTX_over.text = @"운행종료";
        toKTX_over.font = [UIFont systemFontOfSize:16];
    }
    
    if ([[BusTime objectForKey:@"bus337_ktx"] isEqualToString:@"운행종료"]) {
        toKTX_over.alpha = 1;
        toKTX_label_2.alpha = 0;
        toKTX_label_3.alpha = 0;
    }
    
    UILabel *toTown_label_1 = (UILabel *)[self.view viewWithTag:16];
    toTown_label_1.text = @"시내방면 도착까지";
    toTown_label_1.textColor = UIColorFromRGB(0x656565);
    
    UILabel *toTown_label_2 = (UILabel *)[self.view viewWithTag:17];
    toTown_label_2.text = [NSString stringWithFormat:@"%@분", bus337_town_time];
    toTown_label_2.textColor = UIColorFromRGB(0x8511C0);
    toTown_label_2.alpha = 1;
    [self setTextAnimation:toTown_label_2 withNewText:toTown_label_2.text];
    
    UILabel *toTown_label_3 = (UILabel *)[self.view viewWithTag:18];
    toTown_label_3.text = @"남았습니다.";
    toTown_label_3.alpha = 1;
    
    UILabel *toTown_over = (UILabel *)[self.view viewWithTag:20];
    toTown_over.backgroundColor = [UIColor whiteColor];
    toTown_over.alpha = 0;
    
    if (bus337_town_time.intValue <= 0) {
        NSLog(@"339 <= 0");
        toTown_over.alpha = 1;
        toTown_over.text = @"시내방면 버스가 도착하였습니다.";
        [self setTextAnimation:toTown_over withNewText:toTown_over.text];
        toTown_over.font = [UIFont systemFontOfSize:12];
        toTown_label_2.alpha = 0;
        toTown_label_3.alpha = 0;
    } else {
        toTown_over.text = @"운행종료";
        toTown_over.font = [UIFont systemFontOfSize:16];
    }
    
    if ([[BusTime objectForKey:@"bus337_town"] isEqualToString:@"운행종료"]) {
        toTown_over.alpha = 1;
        toTown_label_2.alpha = 0;
        toTown_label_3.alpha = 0;
    }
}

- (void)loadView {
    [super loadView];
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if (result.height == 480) {
            // iPhone Classic
            [[NSBundle mainBundle] loadNibNamed:@"YAMBusViewController" owner:self options:nil];
            
        }
        if (result.height == 568) {
            // iPhone 5
            [[NSBundle mainBundle] loadNibNamed:@"YAMBusViewController-5" owner:self options:nil];
        }
    }

    [self.indicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"http://lejong0106.cafe24.com/php/get_bus_time.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.indicator startAnimating];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^
                                         (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self setBusTime:JSON];
        [self.indicator stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
        [self.indicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"네트워크 상태를 확인해주세요."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles: nil];
        [alert show];
    }];
    [operation start];
        [NSTimer scheduledTimerWithTimeInterval:30.0
                                         target:self
                                       selector:@selector(Request)
                                       userInfo:nil
                                        repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) Request {
    NSURL *url = [NSURL URLWithString:@"http://lejong0106.cafe24.com/php/get_bus_time.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^
                                         (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self setBusTime:JSON];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", [error userInfo]);
    }];
    [operation start];
}

@end
