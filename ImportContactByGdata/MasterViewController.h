//
//  MasterViewController.h
//  ImportContactByGdata
//
//  Created by Nilesh on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>
#import "GData.h"
#import "GDataFeedContact.h"
#import "GDataContacts.h"

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    NSMutableArray *arrData;
    
    GDataFeedContact *mContactFeed;
    GDataServiceTicket *mContactFetchTicket;
    NSError *mContactFetchError;
    
    NSString *mContactImageETag;
    
    GDataFeedContactGroup *mGroupFeed;
    GDataServiceTicket *mGroupFetchTicket;
    NSError *mGroupFetchError;
}

@property (retain, nonatomic) DetailViewController *detailViewController;

- (void)setContactFetchTicket:(GDataServiceTicket *)ticket;
- (GDataServiceGoogleContact *)contactService;
- (NSArray *)sortedEntries:(NSArray *)entries;

@end
