//
//  WineListTableViewController.h
//  Winehound
//
//  Created by Tristan Freeman on 8/28/15.
//  Copyright (c) 2015 Tristan Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface WineListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
