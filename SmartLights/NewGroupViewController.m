//
//  NewGroupViewController.m
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "NewGroupViewController.h"
#import "DemoLightsFinder.h"
#import "GroupFinder.h"
@interface NewGroupViewController ()

@end

@implementation NewGroupViewController{
    NSArray* _allLights;
}

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
	_tableView.delegate = self;
    _tableView.dataSource = self;
    _allLights = [[DemoLightsFinder sharedFinder] findLights];
    _groupName.text = _group.name;
}

-(void) viewWillDisappear:(BOOL)animated {
    _group.name = _groupName.text;
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GROUP_CHANGED_NOTIFICATION object:_group];
    }
    [super viewWillDisappear:animated];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allLights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"light"];
	id<SmartLight> light = _allLights[indexPath.row];
	UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
	nameLabel.text = light.name;

	UIImageView * imgView = (UIImageView *)[cell viewWithTag:0];
    if ([_group.lights containsObject:light]) {
        imgView.image = [UIImage imageNamed:@"scene_edit_icon_checked"];
    } else {
        imgView.image = [UIImage imageNamed:@"scene_edit_icon_unchecked"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id<SmartLight> light = _allLights[indexPath.row];
    if ([_group.lights containsObject:light]) {
        [_group.lights removeObject:light];
    } else {
        [_group.lights addObject:light];
    }
    [self.tableView reloadData];
    
}

@end
