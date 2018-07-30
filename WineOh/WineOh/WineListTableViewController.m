//
//  WineListTableViewController.m
//  Winehound
//
//  Created by Tristan Freeman on 8/28/15.
//  Copyright (c) 2015 Tristan Freeman. All rights reserved.
//

#import "WineListTableViewController.h"
#import "Wine.h"
#import "AddEditWineViewController.h"
#import "HCSStarRatingView.h"
#import "CustomTableViewCell.h"

@interface WineListTableViewController ()

@end

@implementation WineListTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCanceled:) name:@"SaveCanceledNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savePressed:) name:@"SavePressedNotification" object:nil];
    
    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.757 green:0.259 blue:0.463 alpha:1]];/*#c14276*/
    [[UINavigationBar appearance]setTranslucent:NO];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> secInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [secInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Wine *wine = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    //set the rating view to the accessory view of cell
   
    cell.cellLabel.text = wine.name;
    //cell.detailTextLabel.text = wine.brand;
    
    //set rating view in cell
    cell.cellRating.value = [[wine rating]floatValue];

    
    
      
    
    return cell;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[[[self fetchedResultsController] sections] objectAtIndex:section] name];
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = self.managedObjectContext;
        Wine *wineToDelete = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [context deleteObject:wineToDelete];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error! %@", error);
        }
    }
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Wine" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    // set sectionNameKeyPath to nil if you don't want it to be sectioned by brand
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"retailer" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
    [self.tableView reloadData];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate: {
            Wine *changedWine = [self.fetchedResultsController objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changedWine.name;
        }
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    UITableView *tableView = self.tableView;
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addWineSegue"]) {
        AddEditWineViewController *aewvc = (AddEditWineViewController *)[segue destinationViewController];
        //aewvc.navigationController.title = @"Add New Wine";
        aewvc.type = @"add";
        Wine *newWine = (Wine *) [NSEntityDescription insertNewObjectForEntityForName:@"Wine" inManagedObjectContext:self.managedObjectContext];
        aewvc.currentWine = newWine;
        
    } else if ([[segue identifier] isEqualToString:@"editWineSegue"]) {
        NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
        AddEditWineViewController *aewvc = (AddEditWineViewController *)[segue destinationViewController];
        aewvc.type = @"edit";
        Wine *selectedWine = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        aewvc.currentWine = selectedWine;
    }
}

#pragma mark - NotificationCenter

- (void)saveCanceled:(NSNotification *)notification {
    NSManagedObjectContext *context = self.managedObjectContext;
    [context rollback];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePressed:(NSNotification *)notification {
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (![context save:&error]) {
        NSLog(@"Error! %@", error);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
