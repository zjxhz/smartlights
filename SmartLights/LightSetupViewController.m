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
#import "math.h"
#import "AppDelegate.h"

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

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
    
}

-(void)findColor{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    double pointColorTime = 0.0;
    double diffTime = 0.0;
    CGFloat diff = 1.0;
    CGPoint point = CGPointZero;
    NSInteger count = 0;

//    for (int i = 0; i < _colorView.frame.size.width; i+=10) {
//        for (int j = 0; j < _colorView.frame.size.height; j+=10){
//            CFAbsoluteTime t1 = CFAbsoluteTimeGetCurrent();
////             UIColor* color = [_colorView colorOfPoint:CGPointMake(i, j)];
//            UIColor* color = [self getColorAtPoint:CGPointMake(i, j)];
//            pointColorTime += CFAbsoluteTimeGetCurrent() - t1;
//            const float* colors = CGColorGetComponents( color.CGColor );
//            if (colors[3] == 1.0 ) {
//                count++;
////                NSLog(@"(%d,%d): (%.2f, %.2f, %.2f - %.2f)", i, j, colors[0], colors[1], colors[2], colors[3] );
//                CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
//                CGFloat temp = [self colorDiff:color withColor:_light.color];
//                diffTime += CFAbsoluteTimeGetCurrent() - t2;
//                if(temp < diff){
//                    diff = temp;
//                    point = CGPointMake(i, j);
//                }
//            }
//        }
//    }
    
    
    for (float angle = 0; angle < 2 * M_PI; angle += 0.01) {
        CGPoint centerOfColorView = [_colorView convertPoint:_colorView.center fromView:_colorView.superview];
        CGFloat x = centerOfColorView.x + 65 * cos(angle);
        CGFloat y = centerOfColorView.y - 65 * sin(angle);
        CGPoint p = CGPointMake(x, y);
        UIColor* color = [self getColorAtPoint:p];
        const CGFloat* colors = CGColorGetComponents( color.CGColor );
        if (colors[3] == 1.0 ) {
            count++;
            CFAbsoluteTime t2 = CFAbsoluteTimeGetCurrent();
            CGFloat temp = [self colorDiff:color withColor:_light.color];
            diffTime += CFAbsoluteTimeGetCurrent() - t2;
            if(temp < diff){
                diff = temp;
                point = p;
            }
        }
    }
    
    
    NSLog(@"found diff at (%.0f, %.0f): %.2f, took %f seconds, checked %ld points", point.x, point.y, diff, CFAbsoluteTimeGetCurrent() - start, (long)count);
    NSLog(@"t1: %f, t2: %f",pointColorTime, diff);
    UIImage* touch = [UIImage imageNamed:@"color_touch"];
    UIImageView* touchView = [[UIImageView alloc] initWithImage:touch];
    touchView.userInteractionEnabled = YES;
    UIGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchPanned:)];
    [touchView addGestureRecognizer:pan];
    [self.view addSubview:touchView];//add a subview of self.view as it should be on top of other views to receive events
    CGPoint newPoint = [self.view convertPoint:point fromView:_colorView];
    touchView.center = newPoint;
}

-(UIColor*)getColorAtPoint:(CGPoint)point{
    if (!_colorData) {
        _colorData = [_colorView getImageData];
    }
    CGFloat scale = [UIScreen mainScreen].scale;
    point = CGPointMake(point.x * scale, point.y * scale);
    CGImageRef inImage = _colorView.image.CGImage;
    size_t w = CGImageGetWidth(inImage);
	if (_colorData != NULL) {
		//offset locates the pixel in the data from x,y.
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int offset = 4*((w*round(point.y))+round(point.x));
		int red = _colorData[offset];
		int green = _colorData[offset+1];
		int blue = _colorData[offset+2];
		int alpha =  _colorData[offset+3];
        //		NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
		return  [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
	}

	return nil;
}

-(void)touchPanned:(UIGestureRecognizer*)reg{
    CGPoint tapLocation = [reg locationInView:_colorView];
	switch (reg.state) {
		case UIGestureRecognizerStateChanged: {
            CGPoint newPoint = [self.view convertPoint:tapLocation fromView:_colorView];
//            CGPoint centerOfSlider = CGPointMake(_slider.bounds.size.width / 2, _slider.bounds.si)
            CGPoint centerOfSlider = [_slider convertPoint:_slider.center fromView:_slider.superview];
            CGPoint newPointInSlider = [_slider convertPoint:newPoint fromView:self.view];
            CGFloat angle = angleBetweenThreePoints(centerOfSlider, CGPointZero, newPointInSlider) +  M_PI * 5 /4; // M_PI / 2 is hack
            
            CGFloat x = centerOfSlider.x + 65 * cos(angle);
            CGFloat y = centerOfSlider.y - 65 * sin(angle);
//            NSLog(@"angle: %.2f - (%.0f, %.0f)", angle, x, y);
			reg.view.center = [self.view convertPoint: CGPointMake(x, y) fromView:_slider];// newPoint;
            CGPoint validTapLocation = [_colorView convertPoint:reg.view.center fromView:self.view];
            UIColor* color = [self getColorAtPoint:validTapLocation];
            _light.color = color;
            
            //set color to device
            CGFloat redFloat,greenFloat,blueFloat;
            [color getRed:&redFloat green:&greenFloat blue:&blueFloat alpha:nil];
            Byte  LEDdata[4];
            LEDdata[0] = (Byte)(255*blueFloat);
            LEDdata[1] = (Byte)(255*greenFloat);
            LEDdata[2] = (Byte)(255*redFloat);
            LEDdata[3] = 0x00;
            [self sendData:LEDdata];
            
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
    const CGFloat* colors1 = CGColorGetComponents( color1.CGColor );
    const CGFloat* colors2 = CGColorGetComponents( color2.CGColor );
    return sqrtf(  powf(colors1[0] - colors2[0], 2)
                 + powf(colors1[1] - colors2[1], 2)
                 + powf(colors1[2] - colors2[2], 2) );
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _slider.value = _light.brightness;// * (_slider.maximumValue - _slider.minimumValue) / 100;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self findColor];
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
        [self sendOnOff:0];
        _slider.value = 0;
    } else {
        _light.on = YES;
        _slider.value = 100;
        [self sendOnOff:1];
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

//颜色
-(void)sendData:(Byte[]) bytes
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSData *data = [[NSData alloc]initWithBytes:bytes length:4];
    [appDelegate.bleManager writeValue:0xFFB0
                    characteristicUUID:0xFFB2
                                     p:appDelegate.bleManager.activePeripheral
                                  data:data];
}


//控制灯的开关
-(void)sendOnOff:(int)flag
{
    Byte       messageByte[1];
    NSData *data = nil;
    switch (flag) {
        case 0:  //关
            messageByte[0] = 0x00;
            data = [[NSData alloc]initWithBytes:messageByte length:1];
            break;
        case 1:   //开
            messageByte[0] = 0x01;
            data = [[NSData alloc]initWithBytes:messageByte length:1];
            break;
        case 2:   //改颜色
            messageByte[0] = 0x02;
            data = [[NSData alloc]initWithBytes:messageByte length:1];
            break;
        default:
            break;
    }
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.bleManager writeValue:0xFFB0
                    characteristicUUID:0xFFB1
                                     p:appDelegate.bleManager.activePeripheral
                                  data:data];
}


@end
