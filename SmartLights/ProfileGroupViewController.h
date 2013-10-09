//
//  ProfileGroupViewController.h
//  SmartLights
//
//  Created by Xu Huanze on 10/8/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileGroupViewController : UIViewController
@property(nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property(nonatomic, strong) NSArray* groups;
@end
