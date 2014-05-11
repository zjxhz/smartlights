//
//  SecondViewController.m
//  SmartLights
//
//  Created by Xu Huanze on 9/29/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "SecondViewController.h"
#import "DemoProfileFinder.h"
#import "Profile.h"
#import "LightView.h"
#import "NewProfileViewController.h"
#import "GroupFinder.h"

@interface SecondViewController ()

@end

@implementation SecondViewController{
    NSArray* _profiles;
    NSMutableArray* _grouppedProfiles;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"情景模式";
    [self groupProfiles];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIButton* navButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [navButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn_bg"] forState:UIControlStateNormal];
    [navButton setTitle:@"新建" forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(newProfile:) forControlEvents:UIControlEventTouchUpInside];
    [navButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileAdded:) name:PROFILE_ADDED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupChanged:) name:GROUP_CHANGED_NOTIFICATION object:nil];
}

-(void)changeProfile:(UIGestureRecognizer*)reg{
    [self performSegueWithIdentifier:@"new_profile" sender:reg];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"new_profile"]) {
        NewProfileViewController* vc = segue.destinationViewController;
        UIGestureRecognizer* reg = sender;
        CGPoint point = [self.tableView convertPoint:reg.view.center fromView:reg.view.superview];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
        vc.profile = _grouppedProfiles[indexPath.section][indexPath.row];
    }
}

-(void)groupProfiles{
    _profiles = [[DemoProfileFinder sharedFinder] findProfiles];
    NSMutableDictionary* profileDict = [[NSMutableDictionary alloc] init];
    
    for (Profile* profile in _profiles) {
        if (profileDict[profile.group.name]) {
            NSMutableArray* group = profileDict[profile.group.name];
            [group addObject:profile];
        } else {
            NSMutableArray* group = [[NSMutableArray alloc] initWithArray:@[profile]];
            profileDict[profile.group.name] = group;
        }
    }
    _grouppedProfiles = [[NSMutableArray alloc] init];
    for (NSString* key in [profileDict keyEnumerator]) {
        [_grouppedProfiles addObject:profileDict[key]];
    }
}
-(void)profileAdded:(NSNotification*)notif{
    [self groupProfiles];
    [self.tableView reloadData];
}

-(void)groupChanged:(id<LightGroup>)group{
    [self groupProfiles];
    [self.tableView reloadData];
}

-(void)newProfile:(id)sender{
    [self performSegueWithIdentifier:@"group" sender:sender];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _grouppedProfiles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* profiles = _grouppedProfiles[section];
    return profiles.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Profile* profile = _grouppedProfiles[section][0];
    return profile.group.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"profile"];
	Profile* profile = _grouppedProfiles[indexPath.section][indexPath.row];
	UILabel *nameLabel = (UILabel *)[cell viewWithTag:101];
	nameLabel.text = profile.name;
    
    UIScrollView* scrollView = (UIScrollView*)[cell viewWithTag:102];
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat width = 17.5;
    CGFloat height = 23.5;
    CGFloat gap = 10;
    CGFloat contentWidth = profile.lights.count * (width + gap);
    for (int i = 0; i < profile.lights.count; ++i) {
        id<SmartLight> light  = profile.lights[i];
        LightView* lv = [[LightView alloc] initWithFrame:CGRectMake(i*(gap+width) , 0, width, height)];
        lv.light = light;
        [scrollView addSubview:lv];
    }
    scrollView.contentSize = CGSizeMake(contentWidth, scrollView.frame.size.height);
    
    UIImageView* settingsView = (UIImageView*)[cell viewWithTag:103];
    if (settingsView.gestureRecognizers.count == 0) {
        UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeProfile:)];
        [settingsView addGestureRecognizer:tap];
    }
    
    return cell;
}

@end
