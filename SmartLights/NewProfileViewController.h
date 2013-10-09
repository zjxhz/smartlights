//
//  NewProfileViewController.h
//  SmartLights
//
//  Created by Xu Huanze on 10/8/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LightGroup.h"
#import "Profile.h"

@interface NewProfileViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak) IBOutlet UITextField* textField;
@property(nonatomic, strong) id<LightGroup> group;
@property(nonatomic, strong) Profile* profile;
@end
