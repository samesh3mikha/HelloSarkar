//
//  ComplainViewController.m
//  HelloSarkar
//
//  Created by nepal on 26/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComplainViewController.h"

@implementation ComplainViewController

@synthesize scrollView;
@synthesize nameTextField, districtNameTextField, addressTextField, mobileTextField, complainTypeTitleTextField, dateTextField, complainTextView;
@synthesize pickerView;
@synthesize districtName;
@synthesize districtCode;
@synthesize complainTypeTitle;
@synthesize complainTypeCode;
@synthesize connectionSendComplain;
@synthesize connectionGetDistrictList;
@synthesize connectionGetComplainTypeList;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pickerView = [[UIDatePicker alloc] init];
        districtName = [[NSString alloc] init];
        districtCode = [[NSString alloc] init];
        complainTypeTitle = [[NSString alloc] init];
        districtName = @"";
        districtCode = @"";
        complainTypeTitle = @"";
        complainTypeCode = @"";
        responseDataSendComplain = [[NSMutableData data] retain];
        responseDataGetDistrictList = [[NSMutableData data] retain];
        responseDataGetComplainTypeList = [[NSMutableData data] retain];
    }
    return self;
}


-(id) initWithComplain:(Complain *)_complain inEditingMode:(BOOL)editable{
	if((self = [super init])){
        pickerView = [[UIDatePicker alloc] init];
        districtName = [[NSString alloc] init];
        districtCode = [[NSString alloc] init];
        complainTypeTitle = [[NSString alloc] init];
        districtName = @"";
        districtCode = @"";
        complainTypeTitle = @"";
        complainTypeCode = @"";
        responseDataSendComplain = [[NSMutableData data] retain];
        responseDataGetDistrictList = [[NSMutableData data] retain];
        responseDataGetComplainTypeList = [[NSMutableData data] retain];        
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.view.backgroundColor = [SharedStore store].backColorForViews;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *now = [NSDate date];    
    NSString *date = [dateFormat stringFromDate:now];
    [dateFormat release];
    dateTextField.text = date;
    
    [self getDistrictListFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    scrollView.contentSize = CGSizeMake(320, 640);
    CGRect scrollBounds = scrollView.bounds;
    scrollBounds.origin.y = 0;
    [scrollView scrollRectToVisible:scrollBounds animated:YES];

    if(![districtName isEqualToString:[SharedStore store].districtName] || ![complainTypeTitle isEqualToString:[SharedStore store].complainTypeTitle]){
        districtName = [SharedStore store].districtName;
        districtCode = [SharedStore store].districtCode;
        complainTypeTitle = [SharedStore store].complainTypeTitle;
        complainTypeCode = [SharedStore store].complainTypeCode;

        [self fillValues];
    }    
//    NSLog(@"complainTypeTitle --> %@", complainTypeTitle);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark ---------- IBACTION METHODS ----------

-(void)sendComplainButtonClicked:(id)sender{
    [self saveComplainInDB];
    [self sendComplainToServer]; 
}

-(void)selectDistrictClicked:(id)sender{
    [self showDistrictList];
}

-(void)selectComplainTypeClicked:(id)sender{
    [self showComplainTypeList];
}

-(IBAction)selectDateClicked:(id)sender{
    UIActionSheet *menu = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];

    // Add the picker
    pickerView.datePickerMode = UIDatePickerModeDate;
    [menu addSubview:pickerView];
    [menu showInView:self.navigationController.tabBarController.view];        
    [menu setBounds:CGRectMake(0,0,320, 516)];
    [pickerView setFrame:CGRectMake(0, 85, 320, 216)];
}


#pragma mark -
#pragma mark ---------- UITEXTFIELD DELEGATE METHODS ----------
- (void)textFieldDidBeginEditing:(UITextField *)tf {
    [self relocateScrollViewBounds:tf.tag];
}

- (void)textViewDidBeginEditing:(UITextField *)tf {
    [self relocateScrollViewBounds:tf.tag];
}

    
-(BOOL)textFieldShouldReturn:(UITextField *)textField {	
    NSLog(@"textFieldShouldReturn");
    [nameTextField resignFirstResponder];
    [addressTextField resignFirstResponder];
    [mobileTextField resignFirstResponder];
    [complainTextView resignFirstResponder];
    
    return YES;
}

-(BOOL)textViewShouldReturn:(UITextField *)textField {	
    [complainTextView resignFirstResponder];

    return YES;
}

#pragma mark -
#pragma mark ---------- UIACTIONSHEET DELEGATE METHODS ----------

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"ACTIONS HHET");
	if (buttonIndex == 0)
	{	
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd"];
        NSDate *now = [pickerView date];    
        NSString *date = [dateFormat stringFromDate:now];
        [dateFormat release];
        dateTextField.text = date;
    }
}

#pragma mark -
#pragma mark ---------- UIALERTVIEW DELEGATE METHODS ----------


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
        }
    }
}

#pragma mark -
#pragma mark ---------- URLCONNECTION METHODS ----------

-(void)getDistrictListFromServer{
    NSString *connectionString = [NSString stringWithFormat:@"%@/hellosarkar/data/districts.xml", SERVER_STRING];
	NSURL* url = [NSURL URLWithString:connectionString];
	NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[urlRequest setHTTPMethod:@"GET"];
	connectionGetDistrictList = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	if (connectionGetDistrictList) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}	
}

-(void)getComplainTypeFromServer{
    NSString *connectionString = [NSString stringWithFormat:@"%@/hellosarkar/data/categories.xml", SERVER_STRING];
	NSURL* url = [NSURL URLWithString:connectionString];
	NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[urlRequest setHTTPMethod:@"GET"];
	connectionGetComplainTypeList = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	if (connectionGetComplainTypeList) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}	   
}

-(void)sendComplainToServer{
    NSString *name = nameTextField.text;
    NSString *address = addressTextField.text;
    NSString *mobile = mobileTextField.text;
    NSString *complainText = complainTextView.text;
    NSString *date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *now = [pickerView date];    
    date = [dateFormat stringFromDate:now];
    [dateFormat release];
    [now release];

    name = @"sam";
    districtCode = @"ee";
    address = @"bb";
    mobile = @"ff";
    complainTypeCode = @"2";
    complainText =@"dsdsa";
        
    NSString *encodedname = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)name, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedDistrict = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)districtCode, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedAddress = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)address, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedMobile = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)mobile, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedComplainCode = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)complainTypeCode, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedDate = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)date, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedComplainText = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)complainText, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    
	NSString *content = [NSString stringWithFormat: @"name=%@&district_id=%@&address=%@&mobile=%@&complain_type=%@&complain_text=%@&mobile_info=%@&gps=&date=%@", encodedname, encodedDistrict, encodedAddress, encodedMobile, encodedComplainCode, encodedComplainText, @"Iphone", encodedDate];
	[encodedname release];
	[encodedDistrict release];
	[encodedAddress release];
	[encodedMobile release];
	[encodedComplainCode release];
	[encodedComplainText release];
	
    NSLog(@"PAARAMS -> %@", content);    
    
	NSString *connectionString = [NSString stringWithFormat:@"%@/hellosarkar/public/complain/receive", SERVER_STRING];
	NSURL* url = [NSURL URLWithString:connectionString];
	NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];
	self.connectionSendComplain = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
	if (connectionSendComplain) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
    
}

#pragma mark -
#pragma mark ---------- NSURLCONNECTION DELEGATE METHODS ----------

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {	
    if (connection == connectionSendComplain) {
        [responseDataSendComplain setLength:0];        
    }
    else if (connection == connectionGetDistrictList){
        [responseDataGetDistrictList setLength:0];
    }
    else if (connection == connectionGetComplainTypeList){
        [responseDataGetComplainTypeList setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == connectionSendComplain) {
        [responseDataSendComplain appendData:data];        
    }
    else if (connection == connectionGetDistrictList){
        [responseDataGetDistrictList appendData:data];                
    }
    else if (connection == connectionGetComplainTypeList){
        [responseDataGetComplainTypeList appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {		
    if (connection == connectionSendComplain) {
        self.connectionSendComplain = nil;     
        
        [self showResendAlerView];
    }
    else if (connection == connectionGetDistrictList){
        self.connectionGetDistrictList = nil;
    }
    else if (connection == connectionGetComplainTypeList){
        self.connectionGetComplainTypeList = nil;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSLog(@"connection didFailWithError ------------");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (connection == connectionSendComplain) {
        NSString *responseStringSendComplain = [[[NSString alloc] initWithData:responseDataSendComplain encoding:NSUTF8StringEncoding] autorelease];
        
        NSLog(@"responseStringSendComplain STRING -->%@", responseStringSendComplain);
        if (responseStringSendComplain.length == 6) {
            complain.serverID = responseStringSendComplain;
            complain.status = STATUS_REPORTED;
            [self updateDB];
        }
        else {
            
        }
        NSLog(@"COMPLIAIN --> %@",complain);
        [complain release];
        
        self.connectionSendComplain = nil;        
    }
    else if (connection == connectionGetDistrictList){
        NSString *responseStringGetDistrictList = [[[NSString alloc] initWithData:responseDataGetDistrictList encoding:NSUTF8StringEncoding] autorelease];
        
        NSDictionary *responseDictionary = [[NSDictionary alloc] init];
        NSError *error;
        responseDictionary = [XMLReader dictionaryForXMLString:responseStringGetDistrictList error:&error];
        
        [SharedStore store].districtArray = (NSMutableArray *)[[responseDictionary valueForKey:@"districts"] valueForKey:@"district"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[SharedStore store].districtArray forKey:@"districtArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.connectionGetDistrictList = nil;
        
        NSLog(@"responseStringSendComplain STRING -->%@", responseStringGetDistrictList);
        [self getComplainTypeFromServer];
    }    
    else if (connection == connectionGetComplainTypeList){
        NSString *responseStringGetComplainTypeList = [[[NSString alloc] initWithData:responseDataGetComplainTypeList encoding:NSUTF8StringEncoding] autorelease];
        
        NSDictionary *responseDictionary = [[NSDictionary alloc] init];
        NSError *error;
        responseDictionary = [XMLReader dictionaryForXMLString:responseStringGetComplainTypeList error:&error];

        [SharedStore store].complainTypeArray = (NSMutableArray *)[[responseDictionary valueForKey:@"categories"] valueForKey:@"category"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[SharedStore store].complainTypeArray forKey:@"complainTypeArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        self.connectionGetComplainTypeList = nil;

        NSLog(@"responseStringSendComplain STRING -->%@", responseStringGetComplainTypeList);
    }
}


#pragma mark -
#pragma mark ---------- CUSTOM METHODS ----------

-(void)relocateScrollViewBounds:(NSInteger)tag{
    scrollView.contentSize = CGSizeMake(320, 640);
    
	CGRect scrollBounds = scrollView.bounds;
    if (tag == 1) {
        scrollBounds.origin.y = 0;
    }
    else if(tag == 2){        
        scrollBounds.origin.y = 60;
    }
    else if(tag == 3){        
        scrollBounds.origin.y = 80;
    }
    else if(tag == 4){        
        scrollBounds.origin.y = 120;
    }
    [scrollView scrollRectToVisible:scrollBounds animated:YES];
}

-(void)showDistrictList{
    DistrictViewController *districtViewController = [[[DistrictViewController alloc] initWithNibName:@"DistrictViewController" bundle:nil] autorelease];
    districtViewController.title = @"District List";
    [self.navigationController pushViewController:districtViewController animated:YES];
}

-(void)showComplainTypeList{
    ComplainTypeViewController *complainTypeViewController = [[[ComplainTypeViewController alloc] initWithNibName:@"ComplainTypeViewController" bundle:nil] autorelease];
    complainTypeViewController.title = @"Complain Categories";
    [self.navigationController pushViewController:complainTypeViewController animated:YES];
}

-(void)fillValues{
    districtNameTextField.text = districtName;
    if ([districtName isEqualToString:@""]) {
        districtNameTextField.text =@"N/A";
    }
    
    complainTypeTitleTextField.text = complainTypeTitle;
    if ([complainTypeTitle isEqualToString:@""]) {
        complainTypeTitleTextField.text =@"N/A";
    }
}

-(void)saveComplainInDB{
    // CHECK IF ATIST IS ALREADY CREATED
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Complain" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *complains = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    districtName =@"BKT";
    complainTypeTitle = @"General";
    
    complain = [[NSEntityDescription insertNewObjectForEntityForName:@"Complain" inManagedObjectContext:self.managedObjectContext] retain];
    
    complain.ID = [NSNumber numberWithInt:(complains.count + 1)];
    complain.name = nameTextField.text;
    complain.district = districtName;
    complain.address = addressTextField.text;
    complain.mobile = mobileTextField.text;
    complain.complaintype = complainTypeTitle;
    complain.sendDate = [pickerView date];
    complain.latitude = @"85.34";
    complain.longitude = @"22.45";
    complain.complainText = complainTextView.text;
    complain.status = STATUS_UNREPORTED;
    
    [self updateDB];
}

-(void)deleteComplainFromDB{
    [self.managedObjectContext deleteObject:complain];	
    [self updateDB];
}

-(void)updateDB{
	NSError *error = nil;
	if ([self.managedObjectContext save:&error]) {
	}
}

-(void)showResendAlerView{
    UIAlertView *alert = [[[UIAlertView alloc] init] autorelease];
    [alert setTitle:@"Save complain"];
    [alert setMessage:@"Want to save this complain for sending it later??"];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert setDelegate:self];
    [alert setTag:1];
    [alert show]; 
}

-(void)resetForm{
    
}


#pragma mark - 
#pragma mark ---------- MEMORY MANAGEMENT ----------

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [scrollView release];
    [nameTextField release];
    [districtNameTextField release];
    [addressTextField release];
    [mobileTextField release];
    [complainTypeTitleTextField release];
    [dateTextField release];
    [complainTextView release];
    [pickerView release];
    [districtName release];
    [districtCode release];
    [complainTypeTitle release];
    [complain release];
    [responseDataSendComplain release];
    [managedObjectContext release];
    [super dealloc];
}
@end
