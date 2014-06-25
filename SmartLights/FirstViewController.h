//
//  FirstViewController.h
//  SmartLights
//
//  Created by Xu Huanze on 9/29/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartLight.h"
#import "LightsFinderDelegate.h"

@interface FirstViewController : UIViewController<LightsFinderDelegate>
@property(nonatomic, strong) NSArray* lights;

@property(nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property(nonatomic, weak) IBOutlet UIButton* onOffAllButton;

@end
