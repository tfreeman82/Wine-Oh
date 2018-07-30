//
//  AddEditWineViewController.m
//  Winehound
//
//  Created by Tristan Freeman on 8/28/15.
//  Copyright (c) 2015 Tristan Freeman. All rights reserved.
//

#import "AddEditWineViewController.h"
#import "HCSStarRatingView.h"

@interface AddEditWineViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UITextField *retailerTextField;
@property (weak, nonatomic) IBOutlet UITextField *volumeTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
//@property (nonatomic)HCSStarRatingView *ratingView;
//@property (weak, nonatomic) IBOutlet AXRatingView *ratingView;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *ratingView;


@end

@implementation AddEditWineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.757 green:0.259 blue:0.463 alpha:1]];/*#c14276*/
     [[UINavigationBar appearance]setTranslucent:NO];
    
    self.formNavbar.title = ([self.type isEqualToString:@"add"]) ? @"Add New Wine" : @"Edit Wine";
//    self.ratingView = [[HCSStarRatingView alloc]init];
//    [[self ratingView]setMaximumValue:5];
//    [[self ratingView]setMinimumValue:0];
//    //[[self ratingView]setValue:0];
//    [[self ratingView]setAllowsHalfStars:YES];
//    [[self ratingView]setBackgroundColor:[UIColor colorWithRed:0.929 green:0.91 blue:0.694 alpha:1]];/*#ede8b1*/
//    [[self ratingView]setTintColor:[UIColor colorWithRed:0.757 green:0.259 blue:0.463 alpha:1]];/*#c14276*/
    
    

    //[[self ratingView]sizeToFit];
//    [[self ratingView]setCenter:self.ratingContainer.center];
//    [[self ratingContainer]addSubview:[self ratingView]];
    //[[self view]addSubview:[self ratingView]];
    
    // determine rating view scale depending on device
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [[self ratingView] setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 2, 2)];
    } else {
        [[self ratingView] setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.25, 1.25)];
    }
    float rating = [[self.currentWine rating]floatValue];
    self.ratingView.value = rating;
    //[[self ratingView]setValue:[[_currentWine rating]floatValue]];
    self.nameTextField.text = self.currentWine.name;
    self.brandTextField.text = self.currentWine.brand;
    self.retailerTextField.text = self.currentWine.retailer;
    self.volumeTextField.text = [self.currentWine.volume  isEqual: @0] ? @"" : [self.currentWine.volume stringValue];
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc]init];
    [priceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [priceFormatter setRoundingMode:NSNumberFormatterRoundUp];
    [priceFormatter setMaximumFractionDigits:2];
    
    self.priceTextField.text = [self.currentWine.price isEqual: @0] ? @"" : [priceFormatter stringFromNumber:self.currentWine.price];
    self.notesTextField.text = self.currentWine.notes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)cancel:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveCanceledNotification" object:nil];
}

- (IBAction)save:(id)sender {
NSNumber *rating = [NSNumber numberWithFloat:[[self ratingView]value]];
    self.currentWine.rating = rating;
    self.currentWine.name = self.nameTextField.text;
    self.currentWine.brand = self.brandTextField.text;
    self.currentWine.retailer = self.retailerTextField.text;
    self.currentWine.volume = [NSNumber numberWithFloat:[self.volumeTextField.text floatValue]];
    self.currentWine.price = [NSNumber numberWithDouble:[self.priceTextField.text doubleValue]];
    self.currentWine.notes = self.notesTextField.text;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SavePressedNotification" object:nil];
}

@end
