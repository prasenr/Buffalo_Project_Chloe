//
//  ConversationsViewController.h
//  Buffalo_Project_Chloe
//
//  Created by Chris Fisher on 4/30/14.
//  Copyright (c) 2014 Buffalo Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
-(void)reloadConversations;
@end
