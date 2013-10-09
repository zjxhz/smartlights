//
//  NewProfileViewController.m
//  SmartLights
//
//  Created by Xu Huanze on 10/8/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "NewProfileViewController.h"
#import "LightView.h"
#import "LightSetupViewController.h"
#import "Profile.h"
#import "DemoProfileFinder.h"

@interface NewProfileViewController ()
@end

@implementation NewProfileViewController

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
    _textField.delegate = self;
    _textField.text = _profile.name;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveProfile:)];
}

-(void)saveProfile:(id)sender{
    if (!_profile.name && !_textField.text) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入名称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    _profile.name = _textField.text;
    [[DemoProfileFinder sharedFinder] addProfile:_profile];
    self.navigationController.viewControllers = @[self.navigationController.viewControllers[0]];
}

-(void)setGroup:(id<LightGroup>)group{
    _group = group;
    _profile = [[Profile alloc] init];
    _profile.group = group;
    _profile.name = nil;
}

-(void)setProfile:(Profile *)profile{
    _profile = profile;
    _group = _profile.group;
    _textField.text = profile.name;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildLights];
}


-(void)buildLights{
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat contentHeight = 0;
    NSMutableOrderedSet* lights = _profile.lights;
    for (int i = 0; i < lights.count; ++i) {
        id<SmartLight> light = lights[i];
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
        
        if (i == lights.count - 1) {
            contentHeight = y + bg.size.height;
        }
    }
    _scrollView.contentSize = CGSizeMake(320, 10 + contentHeight);
}

-(void)lightTapped:(UIGestureRecognizer*)reg{
    [self performSegueWithIdentifier:@"setup_light" sender:reg];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"setup_light"]) {
        LightSetupViewController* controller = segue.destinationViewController;
        UIGestureRecognizer* reg = sender;
        NSMutableOrderedSet* lights = _profile.lights;
        id<SmartLight> light = lights[reg.view.tag];
        controller.light = light;
    }
}

#pragma mark UITextFieldDelete
- (void)textFieldDidEndEditing:(UITextField *)textField{
    _profile.name = textField.text;
}

@end
