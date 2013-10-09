//
//  LightCopier.h
//  SmartLights
//
//  Created by Xu Huanze on 10/8/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Light.h"

@interface LightCopier : NSObject
+(Light*)copy:(Light*)light;
@end
