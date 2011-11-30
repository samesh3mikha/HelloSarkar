//
//  DistrictViewController.h
//  HelloSarkar
//
//  Created by nepal on 26/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedStore.h"

@interface DistrictViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *districtListTableView;
    
    NSMutableArray *districtCodeListArray;
    NSMutableArray *districtListArray;
}

//---------  PROPERTIES --------- 
@property (nonatomic, retain) IBOutlet UITableView *districtListTableView;
@property (nonatomic, retain) NSMutableArray *districtCodeListArray;
@property (nonatomic, retain) NSMutableArray *districtListArray;

//---------  CUSTOM METHODS ---------
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)prepareDistrictList;

@end
