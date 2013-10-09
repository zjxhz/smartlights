//
//  LightSetupViewController.m
//  SmartLights
//
//  Created by Xu Huanze on 10/2/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "LightSetupViewController.h"
#import "ImageService.h"
#import "UIView+ColorOfPoint.h"

@interface LightSetupViewController ()

@end

@implementation LightSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_slider setMinimumValue:0.0];
    [_slider setMaximumValue:134.0];
    [_slider setMinimumTrackTintColor:_light.color];
    [_slider addTarget:self action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
    [self findColor];
    
}

-(void)findColor{
    CGFloat diff = 1.0;
    CGPoint point = CGPointZero;
    for (int i = 0; i < _colorView.frame.size.width; i+=10) {
        for (int j = 0; j < _colorView.frame.size.height; j+=5){
            UIColor* color = [_colorView colorOfPoint:CGPointMake(i, j)];
            const float* colors = CGColorGetComponents( color.CGColor );
            if (colors[3] != 0.0 ) {
                CGFloat temp = [self colorDiff:color withColor:_light.color];
                if(temp < diff){
                    diff = temp;
                    point = CGPointMake(i, j);
                }
            }
        }
    }
    NSLog(@"diff at (%.0f, %.0f): %.2f", point.x, point.y, diff);
    UIImage* touch = [UIImage imageNamed:@"color_touch"];
    UIImageView* touchView = [[UIImageView alloc] initWithImage:touch];
    touchView.userInteractionEnabled = YES;
    UIGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchPanned:)];
    [touchView addGestureRecognizer:pan];
    [self.view addSubview:touchView];//add a subview of self.view as it should be on top of other views to receive events
    CGPoint newPoint = [self.view convertPoint:point fromView:_colorView];
    touchView.center = newPoint;
}

-(void)touchPanned:(UIGestureRecognizer*)reg{
    CGPoint tapLocation = [reg locationInView:_colorView];
	switch (reg.state) {
		case UIGestureRecognizerStateChanged: {
            CGPoint newPoint = [self.view convertPoint:tapLocation fromView:_colorView];
			reg.view.center = newPoint;
            UIColor* color = [_colorView colorOfPoint:tapLocation];
            _light.color = color;
            _slider.minimumTrackTintColor = color;
            [self updateOnOffImage];
//			self.value = translateValueFromSourceIntervalToDestinationInterval(angle, 0, 2*M_PI, self.minimumValue, self.maximumValue);
			break;
		}
		default:
			break;
	}
}

-(CGFloat)colorDiff:(UIColor*)color1 withColor:(UIColor*)color2{
    const float* colors1 = CGColorGetComponents( color1.CGColor );
    const float* colors2 = CGColorGetComponents( color2.CGColor );
    return sqrtf(  powf(colors1[0] - colors2[0], 2)
                 + powf(colors1[1] - colors2[1], 2)
                 + powf(colors1[2] - colors2[2], 2) );
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _slider.value = _light.brightness;// * (_slider.maximumValue - _slider.minimumValue) / 100;
}

-(void)brightnessChanged:(id)sender{
    _light.brightness = _slider.value;
    if (_slider.value > 0) {
        _light.on = YES;
    } else {
        _light.on = NO;
    }
    [self updateOnOffImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onOff:(id)sender{
    if (_light.on == YES) {
        _light.on = NO;
        _slider.value = 0;
    } else {
        _light.on = YES;
        _slider.value = 100;
    }
    [self updateOnOffImage];
}

-(void)updateOnOffImage{
    if (_light.on) {
        UIImage* onImage = [UIImage imageNamed:@"brightness_panel_icon_mask"];
        onImage = [ImageService fillImage:onImage withColor:_light.color];
        [_onOffButton setBackgroundImage:onImage forState:UIControlStateNormal];
        
    } else {
        UIImage* offImage = [UIImage imageNamed:@"brightness_panel_icon"];
        [_onOffButton setBackgroundImage:offImage forState:UIControlStateNormal];
    }
}

@end
