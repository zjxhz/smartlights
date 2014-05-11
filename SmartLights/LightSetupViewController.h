//
//  LightSetupViewController.h
//  SmartLights
//
//  Created by Xu Huanze on 10/2/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICircularSlider.h"
#import "SmartLight.h"

@protocol LightSettingsDelegate <NSObject>

-(void)brightnessDidChange:(NSInteger)brightness;

@end
@interface LightSetupViewController : UIViewController
@property(nonatomic, weak) IBOutlet UICircularSlider* slider;
@property(nonatomic, weak) IBOutlet UIButton* onOffButton;
@property(nonatomic, weak) IBOutlet UIImageView* colorView;
@property(nonatomic, strong) id<SmartLight> light;
@property(nonatomic) unsigned char* colorData;
@end
