//
//  LightView.h
//  SmartLights
//
//  Created by Xu Huanze on 10/8/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartLight.h"
@interface LightView : UIView
@property(nonatomic, strong) id<SmartLight> light;
@end
