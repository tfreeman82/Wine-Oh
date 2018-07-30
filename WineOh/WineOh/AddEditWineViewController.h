//
//  AddEditWineViewController.h
//  Winehound
//
//  Created by Tristan Freeman on 8/28/15.
//  Copyright (c) 2015 Tristan Freeman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wine.h"

@interface AddEditWineViewController : UIViewController
@property (strong, nonatomic) IBOutlet UINavigationItem *formNavbar;
@property (strong, nonatomic) NSString *type;
@property (nonatomic, strong) Wine *currentWine;

@end
