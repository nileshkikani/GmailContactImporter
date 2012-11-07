//
//  MasterViewController.m
//  ImportContactByGdata
//
//  Created by Nilesh on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@implementation MasterViewController

AppDelegate *appDelegate;

@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Import";
    }
    return self;
}

- (void)dealloc
{
    [_detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithTitle:@"Get Contact" style:UIBarButtonItemStylePlain target:self action:@selector(getContact)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
    
    arrData = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)getContact
{
    NSLog(@">>>>>>>>>> get Contact Pressed");
    [appDelegate showLoadingView];
    GDataServiceGoogleContact *service = [self contactService];
    GDataServiceTicket *ticket;
    
    BOOL shouldShowDeleted = TRUE;
    
    // request a whole buncha contacts; our service object is set to
    // follow next links as well in case there are more than 2000
    const int kBuncha = 2000;
    
    NSURL *feedURL = [GDataServiceGoogleContact contactFeedURLForUserID:kGDataServiceDefaultUser];
    
    GDataQueryContact *query = [GDataQueryContact contactQueryWithFeedURL:feedURL];
    [query setShouldShowDeleted:shouldShowDeleted];
    [query setMaxResults:kBuncha];
    
    ticket = [service fetchFeedWithQuery:query
                                delegate:self
                       didFinishSelector:@selector(contactsFetchTicket:finishedWithFeed:error:)];
    
    [self setContactFetchTicket:ticket];
}

- (GDataServiceGoogleContact *)contactService 
{
    static GDataServiceGoogleContact* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleContact alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    // update the username/password each time the service is requested
    
    [service setUserCredentialsWithUsername:gmailID
                                   password:gmailpass];
    
    return service;
}

// contacts fetched callback
- (void)contactsFetchTicket:(GDataServiceTicket *)ticket
           finishedWithFeed:(GDataFeedContact *)feed
                      error:(NSError *)error {
    
    if (error) {
        NSLog(@">>>>>>>>>>>>>>>> Fetch error :%@", [error description]);
    }
    
    NSArray *contacts = [feed entries];
    [arrData removeAllObjects];
    for (int i = 0; i < [contacts count]; i++) {
        GDataEntryContact *contact = [contacts objectAtIndex:i];
        NSLog(@">>>>>>>>>>>>>>>> elementname contact :%@", [[[contact name] fullName] contentStringValue]);
        NSString *ContactName = [[[contact name] fullName] contentStringValue];
        GDataEmail *email = [[contact emailAddresses] objectAtIndex:0];
        NSLog(@">>>>>>>>>>>>>>>> Contact's email id :%@", [email address]);
        NSString *ContactEmail = [email address];
        
        if (!ContactName || !ContactEmail) {
            NSLog(@">>>>>>>>>>>>> in if loop\n\n");
        }
        else
        {
            NSArray *keys = [[NSArray alloc] initWithObjects:@"name", @"emailId", nil];
            NSArray *objs = [[NSArray alloc] initWithObjects:ContactName, ContactEmail, nil];
            NSDictionary *dict = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
            [arrData addObject:dict];
        }
    }
    [arrData retain];
    [appDelegate hideLoadingView];
    [self.tableView reloadData];
}

- (NSArray *)sortedEntries:(NSArray *)entries 
{
    NSSortDescriptor *sortDesc;
    SEL sel = @selector(caseInsensitiveCompare:);
    
    sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"title" 
                                            ascending:YES
                                             selector:sel] autorelease];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDesc];
    entries = [entries sortedArrayUsingDescriptors:sortDescriptors];
    return entries;
}

- (void)setContactFetchTicket:(GDataServiceTicket *)ticket
{
    [mContactFetchTicket release];
    mContactFetchTicket = [ticket retain];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([arrData count] != 0) {
        NSDictionary *dict = [arrData objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", [dict objectForKey:@"name"], [dict objectForKey:@"emailId"]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
