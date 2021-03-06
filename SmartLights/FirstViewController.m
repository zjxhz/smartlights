//
//  FirstViewController.m
//  SmartLights
//
//  Created by Xu Huanze on 9/29/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "FirstViewController.h"
#import "BluetoothLightsFinder.h"
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
    UIButton* navButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [navButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn_bg"] forState:UIControlStateNormal];
    [navButton setTitle:@"灯组" forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(showGroups:) forControlEvents:UIControlEventTouchUpInside];
    [navButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    [BluetoothLightsFinder sharedFinder].delegate = self;
    [[BluetoothLightsFinder sharedFinder] scanLights];
    _statusLabel.adjustsFontSizeToFitWidth = NO;
    _statusLabel.numberOfLines = 0;
}

-(void)didFindLights:(NSArray*)lights{
    [DeviceManager sharedInstance].delegate = self;
    _lights = lights;
    [self buildLights];
}

-(void)didFailedToConnectToPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error{
    _statusLabel.text = [NSString stringWithFormat:@"Failed to connect to %@", [peripheral.name substringFromIndex:10]];
}

-(IBAction)refreshBlEDevice:(id)sender{
    
    ScanViewController  *scanView = [ScanViewController new];
    [self.navigationController pushViewController:scanView animated:YES];
}

-(void)showGroups:(id)sender{
    [self performSegueWithIdentifier:@"group" sender:sender];
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
    id<SmartLight> light = _lights[reg.view.tag];
    CBPeripheral* p = light.peripheral;
    if (p) {
        _connected = NO;
        _statusLabel.text = [NSString stringWithFormat:@"Connecting to %@...", [p.name substringFromIndex:10]];
        _reg = reg;
        [[DeviceManager sharedInstance] connectPeripheral:p];
//        [self performSegueWithIdentifier:@"setup_light" sender:reg];
    } else {
        [self performSegueWithIdentifier:@"setup_light" sender:reg];
    }
}

-(void)didConnectToPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"CONNECTED TO PERIPHERAL: %@", peripheral.name);
//    if(!_connected){
    _statusLabel.text = [NSString stringWithFormat:@"Connected to %@", [peripheral.name substringFromIndex:10]];
    _connected = YES;
    [self performSegueWithIdentifier:@"setup_light" sender:_reg];
//    }
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
