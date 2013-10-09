//
//  GroupsViewController.h
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightGroup.h"

@interface GroupsViewController : UIViewController
@property(nonatomic, strong) NSArray* groups;
@property(nonatomic, weak) IBOutlet UIScrollView* scrollView;
@end
