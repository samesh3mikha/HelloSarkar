//
//  DistrictViewController.m
//  HelloSarkar
//
//  Created by nepal on 26/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DistrictViewController.h"

@implementation DistrictViewController

@synthesize districtListTableView;
@synthesize districtCodeListArray;
@synthesize districtListArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        districtCodeListArray =[[NSMutableArray alloc] init];
        districtListArray =[[NSMutableArray alloc] init];        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	districtListTableView.backgroundColor = [UIColor clearColor];

    [self prepareDistrictList];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark ---------- UITABLEVIEW DELEGATE METHODS ----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return [districtListArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell..
    [self configureCell:cell atIndexPath:indexPath];
    
	return cell;
}

// Configure CELL
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    cell.textLabel.text = (NSString *)[districtListArray objectAtIndex:indexPath.row];
    if (indexPath.row == [SharedStore store].districtTableIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
//    cell.textLabel.textColor = [SharedStore store].tableViewTextFontColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if ([SharedStore store].districtTableIndex >= 0) {
        NSIndexPath *formalIndexPath = [NSIndexPath indexPathForRow:[SharedStore store].districtTableIndex inSection:0];
        cell = [tableView cellForRowAtIndexPath:formalIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    [SharedStore store].districtTableIndex = indexPath.row;
    [SharedStore store].districtName = [districtListArray objectAtIndex:indexPath.row];
    [SharedStore store].districtCode = [districtCodeListArray objectAtIndex:indexPath.row];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark ---------- CUSTOM METHODS ----------
-(void)prepareDistrictList{    
    NSDictionary *districtDictionary = [[[NSDictionary alloc] init] autorelease];
    for (int i = 0; i < [SharedStore store].districtArray.count; i++) {
        districtDictionary = (NSDictionary *)[[SharedStore store].districtArray objectAtIndex:i];
        
        [districtCodeListArray addObject:[districtDictionary valueForKey:@"code"]];
        [districtListArray addObject:[districtDictionary valueForKey:@"text"]];
    }    
    
    NSLog(@"COde --> %@", districtCodeListArray);
    NSLog(@"DISTRICTS --> %@", districtListArray);
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
    [districtListTableView release];
    [districtCodeListArray release];
    [districtListArray release];
    
    [super dealloc];
}

@end
