//
//  AppDelegate.h
//  ImportContactByGdata
//
//  Created by Nilesh on 07/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define gmailID ""
#define gmailpass ""

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIView *loadView;
    UIView *viewBack;
    
    UIActivityIndicatorView *spinningWheel;
}

@property (retain, nonatomic) UIWindow *window;

@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void) showLoadingView;
-(void) hideLoadingView;


@property (retain, nonatomic) UINavigationController *navigationController;

@end
