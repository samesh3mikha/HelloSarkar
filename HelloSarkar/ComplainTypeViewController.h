//
//  ComplainTypeViewController.h
//  HelloSarkar
//
//  Created by nepal on 26/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedStore.h"

@interface ComplainTypeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *complainTypeListTableView;
    
    NSMutableArray *complainTypeCodeListArray;   
    NSMutableArray *complainTypeListArray;   
}
//---------  PROPERTIES --------- 
@property (nonatomic, retain) IBOutlet UITableView *complainTypeListTableView;
@property (nonatomic, retain) NSMutableArray *complainTypeCodeListArray;
@property (nonatomic, retain) NSMutableArray *complainTypeListArray;

//---------  CUSTOM METHODS ---------
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)prepareComplainTypeList;

@end
