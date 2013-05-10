//
//  YAM114ViewController.m
//  DeliveryTest2
//
//  Created by haejin on 13. 3. 14..
//  Copyright (c) 2013년 haejin. All rights reserved.
//

#import "YAM114ViewController.h"
#import "YAM114SelectViewController.h"
//#import "NSMutableArray+MutableDeepCopy.h"
#import "NSDictionary+MutableDeepCopy.h"
#import <QuartzCore/QuartzCore.h>
#import "YAMAppDelegate.h"
#import "YAM114Object.h"
#import "YAMFavourArray.h"


#define kFilename       @"favourite114"
#define kDataKey        @"favourite114Key"

#define SELECT (self.selectedSection != nil) && ![self.selectedSection isEqualToString:@"All"] && ![self.selectedSection isEqualToString:@"All(가나다순)"]
#define SELECT_ALL [self.selectedSection isEqualToString:@"All"]
#define SELECT_ORDERED [self.selectedSection isEqualToString:@"All(가나다순)"]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface YAM114ViewController ()

@end

@implementation YAM114ViewController

@synthesize table;
@synthesize search;
@synthesize allDict;
@synthesize Dict;
@synthesize allData;
@synthesize copiedArray;
@synthesize sortedArray;
@synthesize sectionsArray;
@synthesize favourArray;
@synthesize sectionsIndexArray;
@synthesize sectionsIndex;
@synthesize ArrayOfObjects;
@synthesize selectedSection;
@synthesize selectedObject;
@synthesize consist;
@synthesize searched;
@synthesize selectChanged;

static NSString *k114CellIdentifier = @"114TableCell";


#pragma mark -
#pragma mark Custom Methods

- (void) resetSearch {
    self.Dict = [self.allDict mutableDeepCopy];
    searched = NO;
    NSMutableArray *keyArray = [[NSMutableArray alloc] initWithObjects:@"기초과정부", @"기계 및 신소재공학부",
                                @"나노생명화학공학부", @"도시환경공학부", @"디자인 및 인간공학부", @"전기전자컴퓨터공학부",
                                @"친환경에너지공학부", @"테크노경영학부", @"학교 부서", @"기타", nil];

    self.sectionsArray = keyArray;
}

- (void) handleSearchForTerm:(NSString *)searchTerm {
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    
    for (NSString *key in self.sectionsArray) {
        NSMutableDictionary *dict = [self.Dict objectForKey:key];
        NSMutableArray *array = [[dict allKeys] mutableCopy];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        
        for (NSString *name in array){
            if([name rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        
        [dict removeObjectsForKeys:toRemove];
    }
    self.searched = YES;
    [self.sectionsArray removeObjectsInArray:sectionsToRemove];
    [self setData];
    [table reloadData];
}

- (void) handleSearchForTerm:(NSString *)searchTerm InSection:(NSString *)section {
    [self resetSearch];
    NSMutableDictionary *dict = [self.Dict objectForKey:section];
    NSMutableArray *array = [[dict allKeys] mutableCopy];
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    
    for (NSString *name in array){
        if([name rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)
            [toRemove addObject:name];
    }
    if ([array count] == [toRemove count]) {
        [self.sectionsArray removeAllObjects];
    } else {
        [self.sectionsArray removeAllObjects];
        [self.sectionsArray addObject:section];
    }
    [dict removeObjectsForKeys:toRemove];

    self.searched = YES;
    [self setData];
    [table reloadData];
}

- (NSString *)shortenUniversity:(NSString *)university {
    NSString *shorten = nil;
    if ([university isEqualToString:@"기초과정부"])
        shorten = @"기초";
    else if ([university isEqualToString:@"기계 및 신소재공학부"])
        shorten = @"기계";
    else if ([university isEqualToString:@"나노생명화학공학부"])
        shorten = @"나노";
    else if ([university isEqualToString:@"도시환경공학부"])
        shorten = @"도시";
    else if ([university isEqualToString:@"디자인 및 인간공학부"])
        shorten = @"디인공";
    else if ([university isEqualToString:@"전기전자컴퓨터공학부"])
        shorten = @"전전컴";
    else if ([university isEqualToString:@"친환경에너지공학부"])
        shorten = @"친환경";
    else if ([university isEqualToString:@"테크노경영학부"])
        shorten = @"테경";

    return shorten;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *) dataFilePath {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:kFilename];
    return filePath;
}

- (void) loadDataFromBundle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"unist1114" ofType:@"plist"];
    self.allDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSLog(@"allDict: %@", allDict);
}

- (void)loadFavouriteArray {
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        YAMFavourArray *FavourArray = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        self.favourArray = [[NSMutableArray alloc] initWithArray:FavourArray.favourArray];
    } else {
        self.favourArray = [[NSMutableArray alloc] init];
    }
}

- (void) setData {
    self.ArrayOfObjects = [[NSMutableArray alloc] init];
    self.sectionsIndexArray = [[NSMutableArray alloc] init];
    int i=0;
    
    [self.sectionsIndexArray addObject:[NSNumber numberWithInt:i]];
    
    for (int j=0; j<self.sectionsArray.count; j++) {
        NSString *key1 = [self.sectionsArray objectAtIndex:j];
        NSDictionary *dict = [self.Dict objectForKey:key1];
        for (NSString *key2 in dict) {
            YAM114Object *object = [[YAM114Object alloc] init];
            [YAM114Object set:dict Key1:key1 Key2:key2 To:object];
            [self.ArrayOfObjects addObject:object];
            i++;
        }
        [self.sectionsIndexArray addObject:[NSNumber numberWithInt:i]];
    }
    [self.sectionsIndexArray removeObjectAtIndex:self.sectionsIndexArray.count -1];

    self.sortedArray = [[NSMutableArray alloc] initWithArray:self.ArrayOfObjects];
    [YAM114Object sort:self.sortedArray];
    [table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadDataFromBundle];
    [self loadFavouriteArray];
    [self resetSearch];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadView {
    [super loadView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    YAM114SelectViewController *selectVC = [[YAM114SelectViewController alloc] init];
    YAMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.viewController.rightViewController = selectVC;
    
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 95, 200, 30)];
    search.delegate = self;
    for (UIView *subview in search.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            subview.alpha = 0;
        if ([subview isKindOfClass:[UITextField class]]) {
            [(UITextField *)subview setBackground:nil];
            [(UITextField *)subview setBorderStyle:UITextBorderStyleNone];
        }

    }
    [self.view addSubview:search];
    [self.table registerNib:[UINib nibWithNibName:@"YAM114ViewTableCell" bundle:nil] forCellReuseIdentifier:k114CellIdentifier];
    
    /////////////////detail view////////////////
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat height = screenRect.size.height;
    
    UIControl *detailBack1 = (UIControl *)[self.view viewWithTag:1];
    detailBack1.alpha = 0;

    UIView *detail = (UIView *)[self.view viewWithTag:3];//[[UIView alloc] initWithFrame:CGRectMake(0, height + 145, 320, 140)];
    detail.backgroundColor = [UIColor whiteColor];
    detail.frame = CGRectMake(0, height +5, 320, 160);
}

- (IBAction)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (selectedSection == nil || SELECT_ALL) {
        if (self.favourArray.count != 0) {
            if (self.searched == YES)
                return self.sectionsArray.count;
            else {
                return self.sectionsArray.count + 1;
            }
        } else {return self.sectionsArray.count;}
    } else if (SELECT_ORDERED) {
        return 1;
    }
    if (SELECT && self.searched)
        return self.sectionsArray.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([sectionsArray count] == 0)
        return 0;
    else if (SELECT_ORDERED) {
        return self.sortedArray.count;
    }
    
    if (self.selectedSection == nil || SELECT_ALL) {
        if (self.favourArray.count != 0) {
            if (self.searched == YES) {
                if (section < self.sectionsArray.count - 1) {
                    int currentSection = [[self.sectionsIndexArray objectAtIndex:section] intValue];
                    int nextSection = [[self.sectionsIndexArray objectAtIndex:section+1] intValue];
                    return nextSection - currentSection;
                } else
                    return (self.ArrayOfObjects.count - [[self.sectionsIndexArray objectAtIndex:section] intValue]);
            } else if (section == 0) {
                return self.favourArray.count;
            } else {
                if (section < self.sectionsArray.count) {
                    int currentSection = [[self.sectionsIndexArray objectAtIndex:section-1] intValue];
                    int nextSection = [[self.sectionsIndexArray objectAtIndex:section] intValue];
                    return nextSection - currentSection;
                } else {
                    return (self.ArrayOfObjects.count - [[self.sectionsIndexArray objectAtIndex:section-1] intValue]);
                }
            }
        } else if (section < self.sectionsArray.count - 1) {
            int currentSection = [[self.sectionsIndexArray objectAtIndex:section] intValue];
            int nextSection = [[self.sectionsIndexArray objectAtIndex:section+1] intValue];
            return nextSection - currentSection;
        } else
            return (self.ArrayOfObjects.count - [[self.sectionsIndexArray objectAtIndex:section] intValue]);
    } else if (SELECT) {
        if ([self.selectedSection isEqualToString:@"즐겨찾기"]) {
            return self.favourArray.count;
        }
        for (int i=0; i<self.ArrayOfObjects.count; i++) {
            if ([self.selectedSection isEqualToString:[self.sectionsArray objectAtIndex:i]] && i<self.sectionsArray.count -1) {
                int currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:i] intValue];
                int nextSectionIndex = [[self.sectionsIndexArray objectAtIndex:i+1] intValue];
                return nextSectionIndex - currentSectionIndex;
            } else if ([self.selectedSection isEqualToString:[self.sectionsArray objectAtIndex:i]] && i == self.sectionsArray.count - 1) {
                int currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:i] intValue];
                return self.ArrayOfObjects.count - currentSectionIndex;
            }
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSString *cellIdentifier = k114CellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *positionLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *university = (UILabel *)[cell viewWithTag:102];
    UILabel *location = (UILabel *)[cell viewWithTag:103];
    
    YAM114Object *currentObject = [[YAM114Object alloc] init];
    if (self.selectedSection == nil || SELECT_ALL) {
        if (self.favourArray.count != 0) {
            if (self.searched == YES) {
                int currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:section] intValue];
                int currentIndex = row + currentSectionIndex;
                currentObject = [self.ArrayOfObjects objectAtIndex:currentIndex];
                university.alpha = 0;
            } else if (section == 0) {
                currentObject = [self.favourArray objectAtIndex:row];
                university.alpha = 1;
            } else {
                section -= 1;
                int currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:section] intValue];
                int currentIndex = row + currentSectionIndex;
                currentObject = [self.ArrayOfObjects objectAtIndex:currentIndex];
                university.alpha = 0;
            }
        } else {
            int currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:section] intValue];
            int currentIndex = row + currentSectionIndex;
            currentObject = [self.ArrayOfObjects objectAtIndex:currentIndex];
            university.alpha = 0;
        }
    } else if (SELECT) {
        if ([selectedSection isEqualToString:@"즐겨찾기"]) {
            currentObject = [self.favourArray objectAtIndex:row];
            university.alpha = 1;
        } else {
            int currentSectionIndex = NAN;
            for (int i=0; i<self.sectionsArray.count; i++) {
                if ([self.selectedSection isEqualToString:[self.sectionsArray objectAtIndex:i]]) {
                    currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:i] intValue];
                    break;
                }
            }
            int currentIndex = row + currentSectionIndex;
            if (currentSectionIndex == NAN)
                currentObject = nil;
            else
                currentObject = [self.ArrayOfObjects objectAtIndex:currentIndex];
            university.alpha = 0;
        }
    } else if (SELECT_ORDERED) {
        currentObject = [self.sortedArray objectAtIndex:row];
        university.alpha = 1;
    }

    nameLabel.text = currentObject.name;

    [nameLabel sizeToFit];
    if ([currentObject.section isEqualToString:@"기타"]) {
        location.text = [NSString stringWithFormat:@"052-%@", currentObject.phoneNum];
        university.text = @"기타";
        positionLabel.text = @"";
    } else if ([currentObject.section isEqualToString:@"학교 부서"]) {
        location.text = [NSString stringWithFormat:@"052-217-%@", currentObject.phoneNum];
        university.text = @"부서";
        positionLabel.text = @"";
    } else {
        positionLabel.text = currentObject.position;
        university.text = [self shortenUniversity:currentObject.section];
        location.text = currentObject.location;
    }
    positionLabel.textColor = UIColorFromRGB(0x7C7C7C);
    [positionLabel sizeToFit];
    
    CGRect position_frame = positionLabel.frame;
    position_frame.origin.x = nameLabel.frame.origin.x + nameLabel.frame.size.width + 10;
    positionLabel.frame = position_frame;

    [location sizeToFit];
    if (university.alpha == 0) {
        CGRect location_frame = location.frame;
        location_frame.origin.x = 287 - location.frame.size.width - 10;
        location.frame = location_frame;
    } else {
        CGRect location_frame = location.frame;
        location_frame.origin.x = 252 - location.frame.size.width - 10;
        location.frame = location_frame;
    }
    if ([university.text isEqualToString:@"기초"])
        university.backgroundColor = UIColorFromRGB(0xFF6666);
    else if ([university.text isEqualToString:@"기계"])
        university.backgroundColor = UIColorFromRGB(0xFCAE28);
    else if ([university.text isEqualToString:@"나노"])
        university.backgroundColor = UIColorFromRGB(0xAED978);
    else if ([university.text isEqualToString:@"도시"])
        university.backgroundColor = UIColorFromRGB(0x0080FF);
    else if ([university.text isEqualToString:@"디인공"])
        university.backgroundColor = UIColorFromRGB(0x8000FF);
    else if ([university.text isEqualToString:@"전전컴"])
        university.backgroundColor = UIColorFromRGB(0xFF66FF);
    else if ([university.text isEqualToString:@"친환경"])
        university.backgroundColor = UIColorFromRGB(0xFF0080);
    else if ([university.text isEqualToString:@"테경"])
        university.backgroundColor = UIColorFromRGB(0x6666FF);
    else if ([university.text isEqualToString:@"부서"])
        university.backgroundColor = UIColorFromRGB(0x008040);
    else if ([university.text isEqualToString:@"기타"])
        university.backgroundColor = UIColorFromRGB(0x666666);
    
    university.textColor = [UIColor whiteColor];
    location.textColor = UIColorFromRGB(0x7C7C7C);
//    [location sizeToFit];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([sectionsArray count] == 0)
        return nil;
    NSString *sectionName = [[NSString alloc] init];//[sectionsArray objectAtIndex:section];
    
    if (SELECT_ORDERED)
        sectionName = @"All(가나다순)";
    else if (SELECT) {
        if (self.searched == YES) {
            sectionName = [self.sectionsArray objectAtIndex:section];
        } else
            sectionName = self.selectedSection;
    }

    if (selectedSection ==nil || SELECT_ALL) {
        if (self.favourArray.count != 0) {
            if (self.searched == YES)
                sectionName = [self.sectionsArray objectAtIndex:section];
            else if (section == 0)
                sectionName = @"즐겨찾기";
            else
                sectionName = [self.sectionsArray objectAtIndex:section -1];
        } else {
            sectionName = [self.sectionsArray objectAtIndex:section];
        }
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 294, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 200, 30)];
    
    headerLabel.font = [UIFont boldSystemFontOfSize:20];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.text = sectionName;
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 290, 2)];
    
    if ([sectionName isEqualToString:@"즐겨찾기"]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xC6EAF8);
        headerLabel.textColor = UIColorFromRGB(0x2CA5DF);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:0]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xFF6666);
        headerLabel.textColor = UIColorFromRGB(0xFF6666);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:1]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xFCAE28);
        headerLabel.textColor = UIColorFromRGB(0xFCAE28);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:2]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xAED978);
        headerLabel.textColor = UIColorFromRGB(0xAED978);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:3]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0x0080FF);
        headerLabel.textColor = UIColorFromRGB(0x0080FF);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:4]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0x8000FF);
        headerLabel.textColor = UIColorFromRGB(0x8000FF);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:5]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xFF66FF);
        headerLabel.textColor = UIColorFromRGB(0xFF66FF);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:6]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0xFF0080);
        headerLabel.textColor = UIColorFromRGB(0xFF0080);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:7]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0x6666FF);
        headerLabel.textColor = UIColorFromRGB(0x6666FF);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:8]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0x008040);
        headerLabel.textColor = UIColorFromRGB(0x008040);
    } else if ([sectionName isEqualToString:[self.sectionsArray objectAtIndex:9]]) {
        bottomLine.backgroundColor = UIColorFromRGB(0x666666);
        headerLabel.textColor = UIColorFromRGB(0x666666);
    } else {
        bottomLine.backgroundColor = UIColorFromRGB(0x000000);
        headerLabel.textColor = UIColorFromRGB(0x000000);
    }
    
    UIControl *resignFirstResponder = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 294, 40)];
    [resignFirstResponder addTarget:self action:@selector(clickedHeader) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerLabel];
    [headerView addSubview:resignFirstResponder];
    [headerView addSubview:bottomLine];
    
    return headerView;
}

- (void)clickedHeader {
    [self.search resignFirstResponder];
}
     
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (sectionsArray.count == 0)
        return 0;
    return 40;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self detailInformation:indexPath];
}

- (void)detailInformation:(id)sender {
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    int row = indexPath.row;
    int section = indexPath.section;

    UIControl *detailBack1 = (UIControl *)[self.view viewWithTag:1];
    UIView *detail = (UIView *)[self.view viewWithTag:3];
    
    UILabel *nameLabel = (UILabel *)[self.view viewWithTag:10];
    UILabel *university = (UILabel *)[self.view viewWithTag:11];
    UILabel *phoneTitle = (UILabel *)[self.view viewWithTag:12];
    UILabel *phoneLabel = (UILabel *)[self.view viewWithTag:13];
    UILabel *emailTitle = (UILabel *)[self.view viewWithTag:14];
    UILabel *emailLabel = (UILabel *)[self.view viewWithTag:15];
    UILabel *otherLabel = (UILabel *)[self.view viewWithTag:19];
    UIButton *emailBtn = (UIButton *)[self.view viewWithTag:17];
    UIButton *callBtn = (UIButton *)[self.view viewWithTag:18];
    [callBtn addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *favourBtn = (UIButton *)[self.view viewWithTag:16];
    UIImage *favour_Img = [UIImage imageNamed:@"favour"];
    UIImage *favour_sel_Img = [UIImage imageNamed:@"favour_sel"];
    UIImage *favour_star_Img = [UIImage imageNamed:@"favour_star"];
    UIImage *favour_star_sel_Img = [UIImage imageNamed:@"favour_star_sel"];
    
    self.selectedObject = [[YAM114Object alloc] init];
    
    if (selectedSection == nil || SELECT_ALL) {
        if (self.favourArray.count != 0) {
            if (self.searched == YES) {
                int currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:section] intValue];
                int currentIndex = row + currentSectionIndex;
                self.selectedObject = [self.ArrayOfObjects objectAtIndex:currentIndex];
            } else if(section == 0) {
                self.selectedObject = [self.favourArray objectAtIndex:row];
            } else {
                section -= 1;
                int currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:section] intValue];
                int currentIndex = row + currentSectionIndex;
                self.selectedObject = [self.ArrayOfObjects objectAtIndex:currentIndex];
            }
        } else {
            int currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:section] intValue];
            int currentIndex = row + currentSectionIndex;
            self.selectedObject = [self.ArrayOfObjects objectAtIndex:currentIndex];
        }
    } else if (SELECT) {
        if ([selectedSection isEqualToString:@"즐겨찾기"])
            self.selectedObject = [self.favourArray objectAtIndex:row];
        else {
            int currentSectionIndex = NAN;
            for (int i=0; i<self.sectionsArray.count; i++) {
                if ([selectedSection isEqualToString:[sectionsArray objectAtIndex:i]]) {
                    currentSectionIndex = [[self.sectionsIndexArray objectAtIndex:i] intValue];
                    break;
                }
            }
            int currentIndex = row + currentSectionIndex;
            self.selectedObject = [self.ArrayOfObjects objectAtIndex:currentIndex];
        }
    } else if (SELECT_ORDERED) {
        self.selectedObject = [self.sortedArray objectAtIndex:row];
    }

    if ([self.selectedObject.section isEqualToString:@"기타"] || [self.selectedObject.section isEqualToString:@"학교 부서"]) {
        CGRect favour_frame = favourBtn.frame;
        favour_frame.origin.x = 159;
        favourBtn.frame = favour_frame;
        
        nameLabel.text = selectedObject.name;
        [nameLabel sizeToFit];
        university.alpha = 0;
        phoneTitle.alpha = 0;
        phoneLabel.alpha = 0;
        emailTitle.alpha = 0;
        emailLabel.alpha = 0;
        otherLabel.alpha = 1;
        emailBtn.alpha = 0;
       if ([self.selectedObject.section isEqualToString:@"기타"])
           otherLabel.text = [NSString stringWithFormat:@"052-%@", selectedObject.phoneNum];
        else if ([self.selectedObject.section isEqualToString:@"학교 부서"])
            otherLabel.text = [NSString stringWithFormat:@"052-217-%@", selectedObject.phoneNum];
    } else {
        CGRect favour_frame = favourBtn.frame;
        favour_frame.origin.x = 50;
        favourBtn.frame = favour_frame;
        
        university.alpha = 1;
        phoneTitle.alpha = 1;
        phoneLabel.alpha = 1;
        emailTitle.alpha = 1;
        emailLabel.alpha = 1;
        otherLabel.alpha = 0;
        emailBtn.alpha = 1;
        
        nameLabel.text = [NSString stringWithFormat:@"%@ 교수님", selectedObject.name];
        [nameLabel sizeToFit];
        
        university.text = selectedObject.section;
        [university sizeToFit];
        university.textColor = UIColorFromRGB(0x7C7C7C);
        CGRect university_frame = university.frame;
        university_frame.origin.x = nameLabel.frame.origin.x + nameLabel.frame.size.width + 7;
        university.frame = university_frame;
        
        phoneTitle.textColor = UIColorFromRGB(0x2CA5DF);
        phoneLabel.text = [NSString stringWithFormat:@"052-217-%@", selectedObject.phoneNum];
        
        emailTitle.textColor = UIColorFromRGB(0x53A618);
        emailLabel.text = selectedObject.email;
    }
    consist = 0;
    
    for (int i=0; i<favourArray.count; i++) {
        if ([selectedObject.name isEqualToString:[[favourArray objectAtIndex:i] name]])
            consist = 1;
    }

    if (consist == 1) {
        [favourBtn setBackgroundImage:favour_star_Img forState:UIControlStateNormal];
        [favourBtn setBackgroundImage:favour_star_sel_Img forState:UIControlStateHighlighted];
    } else {
        [favourBtn setBackgroundImage:favour_Img forState:UIControlStateNormal];
        [favourBtn setBackgroundImage:favour_sel_Img forState:UIControlStateHighlighted];
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat height = screenRect.size.height;
    
    [UIView beginAnimations:@"up" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    detailBack1.alpha = 0.1;
    detail.alpha = 1;
    detailBack1.frame = CGRectMake(0, 0, 320, height);
//    detailBack2.frame = CGRectMake(0, 383, 320, 5);
    detail.frame = CGRectMake(0, height - 160, 320, 160);
    [UIView commitAnimations];
    self.table.scrollEnabled = NO;
}

- (IBAction)closeView {
    UIControl *detailBack1 = (UIControl *)[self.view viewWithTag:1];
    UIView *detail = (UIView *)[self.view viewWithTag:3];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat height = screenRect.size.height;
    
    [UIView beginAnimations:@"close" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    detailBack1.alpha = 0;
    detailBack1.frame = CGRectMake(0, height, 320, height);

    detail.frame = CGRectMake(0, height, 320, 160);
    [UIView commitAnimations];
    self.table.scrollEnabled = YES;
}

- (IBAction) callPhone:(id)sender {
    NSString *phoneNum = [(UILabel *)[self.view viewWithTag:13] text];
    NSLog(@"%@", phoneNum);

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
}

- (IBAction)email:(id)sender {
    NSString *emailAddress = [(UILabel *)[self.view viewWithTag:15] text];
    NSLog(@"%@", emailAddress);

    NSString *emailURL = [NSString stringWithFormat:@"mailto:%@", emailAddress];
    NSURL *url = [NSURL URLWithString:emailURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)favourite:(id)sender {
    UIButton *favourBtn = (UIButton *)[self.view viewWithTag:16];
    UIImage *favour_Img = [UIImage imageNamed:@"favour"];
    UIImage *favour_sel_Img = [UIImage imageNamed:@"favour_sel"];
    UIImage *favour_star_Img = [UIImage imageNamed:@"favour_star"];
    UIImage *favour_star_sel_Img = [UIImage imageNamed:@"favour_star_sel"];

    if (consist == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"즐겨찾기에 추가되었습니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles: nil];
        [favourBtn setBackgroundImage:favour_star_Img forState:UIControlStateNormal];
        [favourBtn setBackgroundImage:favour_star_sel_Img forState:UIControlStateHighlighted];
        [self.favourArray addObject:self.selectedObject];
        consist = 1;
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"즐겨찾기에서 제외되었습니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles: nil];
        [favourBtn setBackgroundImage:favour_Img forState:UIControlStateNormal];
        [favourBtn setBackgroundImage:favour_sel_Img forState:UIControlStateHighlighted];
        [self.favourArray removeObject:self.selectedObject];
        consist = 0;
        [alert show];
    }
    NSString *filePath = [self dataFilePath];
    YAMFavourArray *FavourArray = [[YAMFavourArray alloc] init];
    FavourArray.favourArray = self.favourArray;
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:FavourArray forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
    [self.table reloadData];
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.search resignFirstResponder];
    return indexPath;
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self closeView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = [searchBar text];
    self.searched = YES;
    if (self.selectedSection != nil && SELECT)
        [self handleSearchForTerm:searchTerm InSection:self.selectedSection];
    else
        [self handleSearchForTerm:searchTerm];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        [self resetSearch];
        [self setData];
        self.searched = NO;
        [table reloadData];
        return;
    }
    self.searched = YES;
    if (self.selectedSection != nil && SELECT)
        [self handleSearchForTerm:searchText InSection:self.selectedSection];
    else
        [self handleSearchForTerm:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.search.text = @"";
    [self resetSearch];
    [self setData];
    searched = NO;
    [table reloadData];
    [searchBar resignFirstResponder];
}

@end
