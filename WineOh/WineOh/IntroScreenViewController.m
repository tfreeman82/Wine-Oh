//
//  IntroScreenViewController.m
//  Winehound
//
//  Created by Tristan Freeman on 8/28/15.
//  Copyright (c) 2015 Tristan Freeman. All rights reserved.
//

#import "IntroScreenViewController.h"
#import "WineListTableViewController.h"

@interface IntroScreenViewController ()

@end

@implementation IntroScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showWineListSegue"]) {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        WineListTableViewController *wltvc = (WineListTableViewController *)[navController.viewControllers firstObject];
        wltvc.managedObjectContext = self.managedObjectContext;
    }
}

@end
