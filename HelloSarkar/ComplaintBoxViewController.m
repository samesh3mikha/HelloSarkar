//
//  ComplaintBoxViewController.m
//  HelloSarkar
//
//  Created by nepal on 26/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComplaintBoxViewController.h"

@implementation ComplaintBoxViewController

@synthesize complaintBoxTableView;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Complain" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *artists = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"COUNT --> %d", [artists count]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark ---------- UITABLEVIEW DELEGATE METHODS ----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSLog(@"[sectionInfo numberOfObjects] -> %d",[sectionInfo numberOfObjects]);

    return [sectionInfo numberOfObjects];
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
    Complain *complain = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = complain.complainText;
    cell.detailTextLabel.text = complain.complaintype;    
    //    cell.textLabel.textColor = [SharedStore store].tableViewTextFontColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark ---------- FETCHEDRESULTSCONTROLER delegate methods ----------

//override fetchedResultsController getter
- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController == nil) {		
		NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Complain" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setFetchBatchSize:20];
		[fetchRequest setEntity:entity];
        
//        NSPredicate *predicate = nil;
//        if ([[self.searchPredicate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
//            predicate = [NSPredicate predicateWithFormat:@"artist_name BEGINSWITH[cd] %@ ", searchPredicate];
//		}
//        [fetchRequest setPredicate:predicate];
        
        //        NSDictionary *entityProperties = [entity propertiesByName];
        //        [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects: [entityProperties objectForKey:@"artist"], nil]];
        //        [fetchRequest setReturnsDistinctResults:YES];        
        //        [fetchRequest setResultType:NSDictionaryResultType];
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
		fetchedResultsController.delegate = self;
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error]) {
			//handle the error...
			NSLog(@"error occured in fetched result controller");
		}
	}	
	return fetchedResultsController;
}  

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.complaintBoxTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.complaintBoxTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.complaintBoxTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch(type) {
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(UITableViewCell *)[self.complaintBoxTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[self.complaintBoxTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.complaintBoxTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeInsert:
			[self.complaintBoxTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.complaintBoxTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.complaintBoxTableView endUpdates];
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
    [complaintBoxTableView release];
    [fetchedResultsController release];
    [managedObjectContext release];
    [super dealloc];
}


@end
