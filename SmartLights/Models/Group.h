//
//  Group.h
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightGroup.h"

@interface Group : NSObject<LightGroup>
@property(nonatomic, strong) NSMutableArray* lights;
@property(nonatomic, strong) NSString* name;
@property(nonatomic) BOOL on;
@property(nonatomic, strong) UIColor* color;
@property(nonatomic) CGFloat brightness;
@end
