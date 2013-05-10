//
//  YAMWriteReviewViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 20..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@protocol WriteReviewDelegate <NSObject>
- (void) writeReviewViewControllerDismissedAndSendStar:(NSString *)star JoinNum:(NSString *)join;
@end


@interface YAMWriteReviewViewController : UIViewController <DLStarRatingDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    id myDelegate;
}
@property (strong, nonatomic) IBOutlet DLStarRatingControl *starRatingView;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextView *contentField;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *star;
@property (nonatomic) id<WriteReviewDelegate> myDelegate;
@property (strong, nonatomic) NSString *deliveryId;
@property (strong, nonatomic) NSString *average_star;
@property (strong, nonatomic) NSString *join_num;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)resignFirstResponder:(id)sender;
@end
