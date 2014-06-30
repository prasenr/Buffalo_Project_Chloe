//
//  ContactSearchCell.m
//  Buffalo Project 2
//
//  Created by Christopher Fisher on 8/20/13.
//  Copyright (c) 2013 Christopher Fisher. All rights reserved.
//

#import "ContactSearchCell.h"

@implementation ContactSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if(selected)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:personModel forKey:@"person"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"contactClickedFromSearch" object:nil userInfo:userInfo];
    }
}

-(void) setPerson:(PersonModel *)person {
    personModel = person;
}

@end
