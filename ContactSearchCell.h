//
//  ContactSearchCell.h
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/20/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+PersonModel.h"

@interface ContactSearchCell : UITableViewCell {
    PersonModel *personModel;
}
@property (nonatomic, weak) IBOutlet UILabel *fromLabelValue;
@property (nonatomic, weak) IBOutlet UIImageView *fromImage;
-(void) setPerson:(PersonModel *)person;
@end
