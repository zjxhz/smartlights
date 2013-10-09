//
//  NewGroupViewController.h
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightGroup.h"
#import "SmartLight.h"

@interface NewGroupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) IBOutlet UITableView* tableView;
@property(nonatomic, weak) IBOutlet UITextField* groupName;
@property(nonatomic, strong) id<LightGroup> group;
@end
