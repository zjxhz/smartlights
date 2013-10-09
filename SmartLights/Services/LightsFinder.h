//
//  LightsFinder.h
//  SmartLights
//
//  Created by Xu Huanze on 9/30/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LightsFinder <NSObject>
@required
-(NSArray*) findLights;
@end
