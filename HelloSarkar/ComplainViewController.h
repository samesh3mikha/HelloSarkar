//
//  ComplainViewController.h
//  HelloSarkar
//
//  Created by nepal on 26/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SharedStore.h"
#import "XMLReader.h"
#import "Complain.h"
#import "EditFieldCell.h"
#import "DistrictViewController.h"
#import "ComplainTypeViewController.h"

@interface ComplainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,  UITextViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, EditFieldCellDelegate>{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *complainsTableView;
    IBOutlet UITextView *complainTextView;
    IBOutlet UIButton *reportBUtton;
    UIDatePicker *pickerView;
    
    NSInteger actionMode;
    NSString *districtCode;
    NSString *complainTypeCode;
    
    Complain *complain;
    NSURLConnection *connectionSendComplain, *connectionGetDistrictList, *connectionGetComplainTypeList;
	NSMutableData *responseDataSendComplain, *responseDataGetDistrictList, *responseDataGetComplainTypeList;

    NSManagedObjectContext *managedObjectContext;
}

//---------  PROPERTIES --------- 
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITableView *complainsTableView;
@property(nonatomic,retain) IBOutlet UITextView *complainTextView;
@property(nonatomic,retain) IBOutlet UIDatePicker *pickerView;
@property(nonatomic,retain) NSString *districtCode;
@property(nonatomic,retain) NSString *complainTypeCode;
@property(nonatomic,retain) NSURLConnection *connectionSendComplain;
@property(nonatomic,retain) NSURLConnection *connectionGetDistrictList;
@property(nonatomic,retain) NSURLConnection *connectionGetComplainTypeList;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

//---------  SELF METHODS ---------
-(id)initWithComplain:(Complain *)_complain inMode:(NSInteger)mode;

//---------  IBACTION METHODS --------- 
-(IBAction)sendComplainButtonClicked:(id)sender;

//---------  URLCONNECTION METHODS --------- 
-(void)getDistrictListFromServer;
-(void)getComplainTypeFromServer;
-(void)sendComplainToServer;

//---------  CUSTOM METHODS ---------
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)loadInitialvalues;
-(void)fillDate:(EditFieldCell *)cell;
-(void)resetScrollContent;
-(void)relocateScrollViewBounds:(NSInteger)tag;
-(void)showDistrictList;
-(void)showComplainTypeList;
-(void)showDatePicker;
-(void)showResendAlerView;
-(BOOL)validateData;
-(void)saveComplainInDB;
-(void)deleteComplainFromDB;
-(void)updateDB;

@end
