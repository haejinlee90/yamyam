//
//  YAMWriteReviewViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 20..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAMWriteReviewViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
@interface YAMWriteReviewViewController ()

@end

@implementation YAMWriteReviewViewController
@synthesize starRatingView;
@synthesize nameField;
@synthesize contentField;
@synthesize name;
@synthesize content;
@synthesize star;
@synthesize myDelegate;
@synthesize deliveryId;


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
    // Do any additional setup after loading the view from its nib.
    self.starRatingView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Delegate implementation of NIB instatiated DLStarRatingControl

-(void)newRating:(DLStarRatingControl *)control :(float)rating {
    NSLog(@"star rating");
    self.star = [NSString stringWithFormat:@"%d", (int)rating];
    
}

- (IBAction) buttonPressed:(id)sender {
    if ([self.nameField.text isEqualToString:@""] || [self.contentField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"이름과 내용 모두 써주세요."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else {
        if (self.starRatingView.rating == 0)
            self.star = @"0";
        NSLog(@"test: %f", self.starRatingView.rating);
        NSURL *url = [NSURL URLWithString:@"http://lejong0106.cafe24.com/php/write_review.php?"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                self.deliveryId, @"delivery_id",
                                self.name, @"user_name",
                                self.content, @"content",
                                self.star, @"star", nil];
        [httpClient postPath:@"?"
                  parameters:params
                     success:^
         (AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success");
            NSLog(@"%@", responseObject);
            [self.myDelegate writeReviewViewControllerDismissedAndSendStar:[responseObject objectForKey:@"star"]
                                                                   JoinNum:[responseObject objectForKey:@"join_num"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error %@", [error userInfo]);
        }];

        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)resignFirstResponder:(id)sender {
    [self.nameField resignFirstResponder];
    [self.contentField resignFirstResponder];
}

- (void)viewDidUnload {
    [self setNameField:nil];
    [self setContentField:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textField did begin editing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textField did ending editing");
    self.name = textField.text;
}
#pragma mark -
#pragma mark Text View Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.text = @"";
}

- (void)textViewDidChange:(UITextView *)textView {
    self.content = textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""])
        textView.text = @"내용을 써주세요..";
    else
        self.content = textView.text;
}

@end
