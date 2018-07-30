//
//  CustomTableViewCell.h
//  WineOh
//
//  Created by Tristan Freeman on 2/17/16.
//  Copyright © 2016 Archon Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) IBOutlet HCSStarRatingView *cellRating;

@end
