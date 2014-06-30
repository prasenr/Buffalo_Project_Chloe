//
//  TwitterEditorViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 6/23/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterAccountHistoryModel.h"

@interface TwitterEditorViewController : UIViewController <UITextFieldDelegate>
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end
