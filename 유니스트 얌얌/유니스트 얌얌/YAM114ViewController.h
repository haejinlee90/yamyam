//
//  YAM114ViewController.h
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 14..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAM114Object.h"
@interface YAM114ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) UISearchBar *search;
@property (strong, nonatomic) NSMutableDictionary *allDict;
@property (strong, nonatomic) NSMutableDictionary *Dict;
@property (strong, nonatomic) NSMutableDictionary *allData;
@property (strong, nonatomic) NSMutableArray *copiedArray;
@property (strong, nonatomic) NSMutableArray *sortedArray;
@property (strong, nonatomic) NSMutableArray *sectionsArray;
@property (strong, nonatomic) NSMutableArray *favourArray;
@property (strong, nonatomic) NSMutableArray *sectionsIndexArray;
@property (strong, nonatomic) NSMutableArray *sectionsIndex;
@property (strong, nonatomic) NSMutableArray *ArrayOfObjects;
@property (strong, nonatomic) NSString *selectedSection;
@property (strong, nonatomic) YAM114Object *selectedObject;
@property int consist;
@property BOOL searched;
@property BOOL selectChanged;


- (void)resetSearch;
- (void)setData;
- (void)handleSearchForTerm:(NSString *)searchTerm;
- (void)detailInformation:(id) sender;
- (IBAction)closeView;
- (IBAction)goBack;
- (IBAction)callPhone:(id)sender;
- (IBAction)email:(id)sender;
- (IBAction)favourite:(id)sender;

@end
