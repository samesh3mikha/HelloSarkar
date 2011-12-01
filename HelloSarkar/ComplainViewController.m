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
@synthesize complainsTableView;
@synthesize pickerView;
@synthesize complainTextView;
@synthesize districtCode;
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
        actionMode = COMPLAIN_CREATING;
        districtCode = [[NSString alloc] init];
        districtCode = @"";
        complainTypeCode = @"";
        responseDataSendComplain = [[NSMutableData data] retain];
        responseDataGetDistrictList = [[NSMutableData data] retain];
        responseDataGetComplainTypeList = [[NSMutableData data] retain];
    }
    return self;
}


-(id) initWithComplain:(Complain *)_complain inEditingMode:(BOOL)editable{
	if((self = [super init])){
        districtCode = [[NSString alloc] init];
        districtCode = @"";
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
    self.complainsTableView.backgroundColor = [UIColor clearColor];
    
    pickerView = [[UIDatePicker alloc] init];
    pickerView.datePickerMode = UIDatePickerModeDate;
    [pickerView setFrame:CGRectMake(0, 85, 320, 216)];
    
    complainTextView.layer.borderWidth = 1.0f;
	complainTextView.layer.borderColor = [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] CGColor];
//	[complainTextView.layer setMasksToBounds:YES];
	[complainTextView.layer setCornerRadius:5.0];
    
    [self loadInitialvalues];
    
    [self getDistrictListFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self resetScrollContent];
    
    NSLog(@"COMPLAIN ------> %@", complain);

    if(![complain.district isEqualToString:[SharedStore store].districtName] || ![complain.complaintype isEqualToString:[SharedStore store].complainTypeTitle]){
        complain.district = [SharedStore store].districtName;
        districtCode = [SharedStore store].districtCode;

        complain.complaintype = [SharedStore store].complainTypeTitle;
        complainTypeCode = [SharedStore store].complainTypeCode;

        [self.complainsTableView reloadData];
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
    complain.complainText = complainTextView.text;
    
    if ([self validateData]) {
        [self saveComplainInDB];
        [self sendComplainToServer];         
    }
}


#pragma mark -
#pragma mark ---------- UITABLEVIEW DELEGATE METHODS ----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return 6;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	EditFieldCell *cell = (EditFieldCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];  
    if (cell == nil){  
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EditFieldCell" owner:nil options:nil];  
        for(id currentObject in topLevelObjects) {  
            if([currentObject isKindOfClass:[EditFieldCell class]]) {  
                cell = (EditFieldCell *) currentObject;  
                break;  
            }  
        }  
    }  
	
	// Next line is very important ...   
    // you have to set the delegate from the cell back to this class  
    [cell setDelegate:self];
    
	// Configure the cell..
    [self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}

// Configure CELL
-(void)configureCell:(EditFieldCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
//    cell.textLabel.text = (NSString *)[districtListArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.textField setFont:[UIFont systemFontOfSize:15]];
    cell.textField.tag = indexPath.row;

    if (indexPath.row == 1 || indexPath.row == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 5) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    else {
        cell.userInteractionEnabled  = YES;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
    }
    
    if (indexPath.row == 0) {
        cell.fieldLabel.text = @"Name :";
        cell.textField.placeholder = @"NAME";
        cell.textField.text =complain.name;
    }
    else if (indexPath.row == 1) {
        cell.fieldLabel.text = @"District :";
        cell.textField.placeholder = @"DISTRICT";
        cell.textField.text =complain.district;
    }
    else if (indexPath.row == 2) {
        cell.fieldLabel.text = @"Address :";
        cell.textField.placeholder = @"ADDRESS";
        cell.textField.text =complain.address;
    }
    else if (indexPath.row == 3) {
        cell.fieldLabel.text = @"Mobile :";
        cell.textField.placeholder = @"MOBILE";
        cell.textField.text =complain.mobile;
    }
    else if (indexPath.row == 4) {
        cell.fieldLabel.text = @"Complain :";
        cell.textField.placeholder = @"COMPLAIN CATEGORY";
        cell.textField.text = complain.complaintype;
    }
    else if (indexPath.row == 5) {
        cell.fieldLabel.text = @"Date :";
        cell.textField.placeholder = @"DATE";
        [self fillDate:cell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EditFieldCell *cell = (EditFieldCell *)[self.complainsTableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 1) {
        [self showDistrictList];
    }
    else if (indexPath.row == 4) {
        [self showComplainTypeList];
    }
    else if (indexPath.row == 5) {
        [self showDatePicker];
    }
    else {
        [cell assignAsFirstResponder];
    }

}

#pragma mark -
#pragma mark ---------- EDITFIELDCELL DELEGATE METHODS ----------

- (void)relocateScrollView:(CGRect)cellFrame{
    [self relocateScrollViewBounds:0];
}

-(void)resignResponder:(NSInteger)tag withText:(NSString *)text{
    [self resetScrollContent];
    
    if (tag == 0) {
        complain.name = text;
    }
    else if (tag == 2) {
        complain.address = text;        
    }
    else if (tag == 3) {
        complain.mobile = text;        
    }
}

#pragma mark -
#pragma mark ---------- UITEXTFIELD DELEGATE METHODS ----------
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self relocateScrollViewBounds:textField.tag];
}
    
-(BOOL)textFieldShouldReturn:(UITextField *)textField {	
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];

    
    return YES;
}

#pragma mark -
#pragma mark ---------- UITEXTVIEW DELEGATE METHODS ----------

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self relocateScrollViewBounds:textView.tag];
}


-(BOOL)textViewShouldReturn:(UITextView *)textView {	
    NSLog(@"textViewShouldReturn");
    [textView resignFirstResponder];
    [self resetScrollContent];    
    
    return YES;
}

#pragma mark -
#pragma mark ---------- UIACTIONSHEET DELEGATE METHODS ----------

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"ACTIONS HHET");
	if (buttonIndex == 0)
	{	
        complain.sendDate = [pickerView date];    
        
        [self.complainsTableView reloadData];
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
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [dateFormat stringFromDate:complain.sendDate];

    NSString *encodedname = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)complain.name, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedDistrict = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)districtCode, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedAddress = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)complain.address, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedMobile = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)complain.mobile, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedComplainCode = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)complainTypeCode, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedDate = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)dateString, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
	NSString *encodedComplainText = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)complain.complainText, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    
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
        self.connectionSendComplain = nil;        

        [complain release];
        [self loadInitialvalues];
        [self.complainsTableView reloadData];        
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
        
//        NSLog(@"responseStringSendComplain STRING -->%@", responseStringGetDistrictList);
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

//        NSLog(@"responseStringSendComplain STRING -->%@", responseStringGetComplainTypeList);
    }
}


#pragma mark -
#pragma mark ---------- CUSTOM METHODS ----------

-(void)loadInitialvalues{
    if (actionMode == COMPLAIN_CREATING) {
        complain = [[NSEntityDescription insertNewObjectForEntityForName:@"Complain" inManagedObjectContext:self.managedObjectContext] retain];
        complain.name = @"";
        complain.district = @"";
        complain.address = @"";
        complain.mobile = @"";
        complain.complaintype = @"";
        complain.sendDate = [NSDate date];
        complain.latitude = @"85.34";
        complain.longitude = @"22.45";
        complain.complainText = @"";
        complain.status = STATUS_UNREPORTED;
        
        complainTextView.text = complain.complainText;
    }
    else if (actionMode == COMPLAIN_EDITING) {
        
    }
    else if (actionMode == COMPLAIN_DISPLAYING) {
        
    }
}

-(void)fillDate:(EditFieldCell *)cell{   
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"MMMM-dd-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:complain.sendDate];
    
    cell.textField.text = dateString;
}

-(void)resetScrollContent{
    scrollView.contentSize = CGSizeMake(320, 481);
}

-(void)relocateScrollViewBounds:(NSInteger)tag{
    scrollView.contentSize = CGSizeMake(320, 645);
    
	CGRect scrollBounds = scrollView.bounds;
    if (tag == 0) {
        scrollBounds.origin.y = 0;
    }
    else if(tag == 1){        
        scrollBounds.origin.y = 180;
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

-(void)showDatePicker{
    UIActionSheet *menu = [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Done" destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
    
    // Add the picker
    [menu addSubview:pickerView];
    [menu showInView:self.navigationController.tabBarController.view];        
    [menu setBounds:CGRectMake(0,0,320, 516)];
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

-(BOOL)validateData{
    BOOL dataValid = YES;
    
    if ([complain.name isEqualToString:@""] || [complain.district isEqualToString:@""] || [complain.address isEqualToString:@""] || [complain.mobile isEqualToString:@""] || [complain.complaintype isEqualToString:@""] || [complain.complainText isEqualToString:@""]) {
        dataValid = NO;
        
        UIAlertView *alert = [[[UIAlertView alloc] init] autorelease];
        [alert setTitle:@"Data Invalid"];
        [alert setMessage:@"One or more field has invalid or null data"];
        [alert addButtonWithTitle:@"OK"];
        [alert setDelegate:nil];
        [alert show];
    }
    
    return dataValid;
}

-(void)saveComplainInDB{
    // CHECK IF ATIST IS ALREADY CREATED
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Complain" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *complains = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    complain.ID = [NSNumber numberWithInt:complains.count];
    complain.complainText = complainTextView.text;
    
    [self updateDB];
    
    NSLog(@"COMPLAIN ------> %@", complain);
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
    [complainsTableView release];
    [complainTextView release];
    [pickerView release];
    [districtCode release];
    [complainTypeCode release];
    [complain release];
    [responseDataSendComplain release];
    [managedObjectContext release];
    [super dealloc];
}
@end
