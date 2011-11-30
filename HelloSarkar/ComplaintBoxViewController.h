//
//  ComplaintBoxViewController.h
//  HelloSarkar
//
//  Created by nepal on 26/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Complain.h"

@interface ComplaintBoxViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate>{
   IBOutlet UITableView *complaintBoxTableView;
    
    NSFetchedResultsController *fetchedResultsController;
    
    NSManagedObjectContext *managedObjectContext;
}

//---------  PROPERTIES --------- 
@property (nonatomic, retain) IBOutlet UITableView *complaintBoxTableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

//---------  IBACTION METHODS --------- 

//---------  URLCONNECTION METHODS --------- 

//---------  CUSTOM METHODS ---------
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
