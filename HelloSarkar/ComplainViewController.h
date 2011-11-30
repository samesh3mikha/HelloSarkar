//
//  ComplainViewController.h
//  HelloSarkar
//
//  Created by nepal on 26/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedStore.h"
#import "XMLReader.h"
#import "Complain.h"
#import "DistrictViewController.h"
#import "ComplainTypeViewController.h"

#define SERVER_STRING @"http://apps.mobilenepal.net"

@interface ComplainViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *districtNameTextField;
    IBOutlet UITextField *addressTextField;
    IBOutlet UITextField *mobileTextField;
    IBOutlet UITextField *complainTypeTitleTextField;
    IBOutlet UITextField *dateTextField;
    IBOutlet UITextView *complainTextView;
    UIDatePicker *pickerView;
    
    NSString *districtName;
    NSString *districtCode;
    NSString *complainTypeTitle;
    NSString *complainTypeCode;
    
    Complain *complain;
    NSURLConnection *connectionSendComplain, *connectionGetDistrictList, *connectionGetComplainTypeList;
	NSMutableData *responseDataSendComplain, *responseDataGetDistrictList, *responseDataGetComplainTypeList;

    NSManagedObjectContext *managedObjectContext;
}

//---------  PROPERTIES --------- 
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UITextField *nameTextField;
@property(nonatomic,retain) IBOutlet UITextField *districtNameTextField;
@property(nonatomic,retain) IBOutlet UITextField *addressTextField;
@property(nonatomic,retain) IBOutlet UITextField *mobileTextField;
@property(nonatomic,retain) IBOutlet UITextField *complainTypeTitleTextField;
@property(nonatomic,retain) IBOutlet UITextField *dateTextField;
@property(nonatomic,retain) IBOutlet UITextView *complainTextView;
@property(nonatomic,retain) IBOutlet UIDatePicker *pickerView;
@property(nonatomic,retain) NSString *districtName;
@property(nonatomic,retain) NSString *districtCode;
@property(nonatomic,retain) NSString *complainTypeTitle;
@property(nonatomic,retain) NSString *complainTypeCode;
@property(nonatomic,retain) Complain *complain;
@property(nonatomic,retain) NSURLConnection *connectionSendComplain;
@property(nonatomic,retain) NSURLConnection *connectionGetDistrictList;
@property(nonatomic,retain) NSURLConnection *connectionGetComplainTypeList;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

//---------  IBACTION METHODS --------- 
-(IBAction)sendComplainButtonClicked:(id)sender;
-(IBAction)selectDistrictClicked:(id)sender;
-(IBAction)selectComplainTypeClicked:(id)sender;
-(IBAction)selectDateClicked:(id)sender;

//---------  URLCONNECTION METHODS --------- 
-(void)getDistrictListFromServer;
-(void)getComplainTypeFromServer;
-(void)sendComplainToServer;

//---------  CUSTOM METHODS ---------
-(void)relocateScrollViewBounds:(NSInteger)tag;
-(void)showDistrictList;
-(void)showComplainTypeList;
-(void)fillValues;
-(void)saveComplainInDB;
-(void)deleteComplainFromDB;
-(void)updateDB;
-(void)showResendAlerView;
-(void)resetForm;

@end
