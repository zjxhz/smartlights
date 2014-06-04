//
//  FirstViewController.m
//  SmartLights
//
//  Created by Xu Huanze on 9/29/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "FirstViewController.h"
#import "DemoLightsFinder.h"
#import "LightSetupViewController.h"
#import "ImageService.h"
#import "GroupsViewController.h"
#import "LightView.h"
#import "ScanViewController.h"
#import "Light.h"

@interface FirstViewController (){
    UIGestureRecognizer* _reg;
}

@end

@implementation FirstViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"灯控列表";
    _lights = [[DemoLightsFinder sharedFinder] findLights];
    UIButton* navButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [navButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn_bg"] forState:UIControlStateNormal];
    [navButton setTitle:@"灯组" forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(showGroups:) forControlEvents:UIControlEventTouchUpInside];
    [navButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    UIBarButtonItem *scanDeviceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(refreshBlEDevice:)];
    self.navigationItem.leftBarButtonItem = scanDeviceItem;
    
}

-(void)initNotification
{
    //设定通知
    //发现BLE外围设备
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //成功连接到指定外围BLE设备
    [nc addObserver: self
           selector: @selector(didConectedbleDevice:)
               name: @"DIDCONNECTEDBLEDEVICE"
             object: nil];
}

//连接成功
-(void)didConectedbleDevice:(CBPeripheral *)peripheral {
    NSLog(@" BLE 设备连接成功   ！\r\n");
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.bleManager.activePeripheral discoverServices:nil];
    [self performSegueWithIdentifier:@"setup_light" sender:_reg];
}


-(IBAction)refreshBlEDevice:(id)sender{
    
    ScanViewController  *scanView = [ScanViewController new];
    [self.navigationController pushViewController:scanView animated:YES];
}
-(void)showGroups:(id)sender{
    [self performSegueWithIdentifier:@"group" sender:sender];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildLights];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if(delegate.bleManager.peripherals){
         NSMutableArray* lights = [[NSMutableArray alloc] init];
        for (CBPeripheral * p in delegate.bleManager.peripherals) {
            Light* l = [[Light alloc] init];
            l.name = p.name;
            
            l.on = arc4random() % 2;
            l.brightness = arc4random() % 101;
            //        CGFloat red = (arc4random() % 255) / 255.0;
            //        CGFloat green = (arc4random() % 255) / 255.0;
            //        CGFloat blue = (arc4random() % 255) / 255.0;
            l.color = [self randomColor];
            [lights addObject:l];
        }
        _lights = lights;
        [self buildLights];
    }
}

-(UIColor*)randomColor{
    int r = arc4random() % 5;
    switch (r) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor yellowColor];
        case 2:
            return [UIColor purpleColor];
        case 3:
            return [UIColor greenColor];
        case 4:
            return [UIColor blueColor];
        default:
            return [UIColor whiteColor];
    }
}

-(void)buildLights{
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self updateOnOffAllButton];
    CGFloat contentHeight = 0;
    for (int i = 0; i < _lights.count; ++i) {
        id<SmartLight> light = _lights[i];
        int row = i / 3;
        int column = i % 3;
        UIImage* bg = [UIImage imageNamed:@"lamp_item_bg"];
        CGFloat x = 10 + column*(bg.size.width+9);
        CGFloat y = 10 + row * (bg.size.height+9);
        UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, bg.size.width, bg.size.height)];
        view.userInteractionEnabled = YES;
        view.tag = i;
        UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(lightTapped:)];
        [view addGestureRecognizer:tap];
        view.image = bg;
        [_scrollView addSubview:view];
        
//        if (light.on) {
////            UIImage* onTop = [UIImage imageNamed:@"icon_lamp_on_top"];
////            onTop = [ImageService fillImage:onTop withColor:light.color];
//            UIImage* onBottom = [UIImage imageNamed:@"icon_lamp_on_bottom"];
////            UIImageView* topView = [[UIImageView alloc] initWithImage:onTop];
//            LightView* topView = [[LightView alloc] initWithFrame:CGRectMake(0, 0, onBottom.size.width, onBottom.size.height) ];
//            topView.color = light.color;
//            UIImageView* bottomView = [[UIImageView alloc] initWithImage:onBottom];
//            [_scrollView addSubview:topView];
//            [_scrollView addSubview:bottomView];
//            topView.center = view.center;
//            CGRect frame = topView.frame;
//            topView.frame = CGRectMake(frame.origin.x, frame.origin.y - 5, frame.size.width, frame.size.height);
//            bottomView.center = view.center;
//        } else {
//            UIImage* off = [UIImage imageNamed:@"icon_lamp_off"];
//            UIImageView* offView = [[UIImageView alloc] initWithImage:off];
//            [_scrollView addSubview:offView];
//            offView.center = view.center;
//        }
        LightView* lightView = [[LightView alloc] initWithFrame:CGRectMake(0, 0, 35, 47) ];
        lightView.light = light;
        [_scrollView addSubview:lightView];
        lightView.center = view.center;
        
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, bg.size.width, 15)];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.text = light.name;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:nameLabel];
        
        if (i == _lights.count - 1) {
            contentHeight = y + bg.size.height;
        }
    }
    _scrollView.contentSize = CGSizeMake(320, 10 + contentHeight);
}

-(void)lightTapped:(UIGestureRecognizer*)reg{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.bleManager.peripherals) {
        CBPeripheral * p = delegate.bleManager.peripherals[reg.view.tag];
        if (!p.isConnected) {
            [delegate.bleManager.activeCharacteristics removeAllObjects];
            [delegate.bleManager.activeDescriptors removeAllObjects];
            delegate.bleManager.activePeripheral = nil;
            delegate.bleManager.activeService = nil;
            
            //发出通知新页面，对指定外围设备进行连接
            [delegate.bleManager connectPeripheral:p];
            _reg = reg;
        } else {
            [self performSegueWithIdentifier:@"setup_light" sender:reg];
        }
    } else {
        [self performSegueWithIdentifier:@"setup_light" sender:reg];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"setup_light"]) {
        LightSetupViewController* controller = segue.destinationViewController;
        UIGestureRecognizer* reg = sender;
        id<SmartLight> light = _lights[reg.view.tag];
        controller.light = light;
    }
}



-(void)updateOnOffAllButton{
    if ([self anyLightOn]) {
        [_onOffAllButton setBackgroundImage:[UIImage imageNamed:@"close_all_bg"] forState:UIControlStateNormal];
        [_onOffAllButton setTitle:@"关闭所有" forState:UIControlStateNormal];
    } else {
        [_onOffAllButton setBackgroundImage:[UIImage imageNamed:@"open_all_bg"] forState:UIControlStateNormal];
        [_onOffAllButton setTitle:@"打开所有" forState:UIControlStateNormal];
    }
}

-(BOOL)anyLightOn{
    for (id<SmartLight> light in _lights) {
        if (light.on) {
            return YES;
        }
    }
    return NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onOffAll:(id)sender{
    if ([self anyLightOn]) {
        for (id<SmartLight> l in _lights) {
            l.on = NO;
        }
    } else {
        for (id<SmartLight> l in _lights) {
            l.on = YES;
        }
    }
    [self updateOnOffAllButton];
    [self buildLights];
}


@end
