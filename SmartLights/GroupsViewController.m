//
//  GroupsViewController.m
//  SmartLights
//
//  Created by Xu Huanze on 10/7/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "GroupsViewController.h"
#import "DemoGroupFinder.h"
#import "NewGroupViewController.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

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
	self.title = @"灯组";
    _groups = [[DemoGroupFinder sharedFinder] findGroups];
    UIButton* navButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [navButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn_bg"] forState:UIControlStateNormal];
    [navButton setTitle:@"编辑" forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(editGroups:) forControlEvents:UIControlEventTouchUpInside];
    [navButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navButton];
//    [self buildGroups];
}

-(void)editGroups:(id)sender{
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self buildGroups];
}


-(void)buildGroups{
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat contentHeight = 0;
    for (int i = 0; i <= _groups.count; ++i) {
        int row = i / 3;
        int column = i % 3;
        UIImage* bg = [UIImage imageNamed:@"lamp_item_bg"];
        CGFloat x = 10 + column*(bg.size.width+9);
        CGFloat y = 10 + row * (bg.size.height+9);
        if (i == _groups.count) {
            bg = [UIImage imageNamed:@"groups_add_new"];
        }
        
        UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, bg.size.width, bg.size.height)];
        view.userInteractionEnabled = YES;
        view.tag = i;
        UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(groupTapped:)];
        [view addGestureRecognizer:tap];
        view.image = bg;
        [_scrollView addSubview:view];
        
        if (i < _groups.count) {
            id<LightGroup> group = _groups[i];
            UIImage* onImg = [UIImage imageNamed:@"group_icon_on"];
            UIImageView* onView = [[UIImageView alloc] initWithImage:onImg];
            [_scrollView addSubview:onView];
            onView.center = view.center;
            
            
            UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, bg.size.width, 15)];
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont systemFontOfSize:12];
            nameLabel.text = group.name;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:nameLabel];
        }

        if (i == _groups.count) {
            contentHeight = y + bg.size.height;
        }
    }
    _scrollView.contentSize = CGSizeMake(320, 10 + contentHeight);
    
    [self.view addSubview:_scrollView];
}

-(void)groupTapped:(UIGestureRecognizer*)reg{
    [self performSegueWithIdentifier:@"add_group" sender:reg];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIGestureRecognizer* reg = sender;
    if (reg.view.tag < _groups.count) {
        NewGroupViewController* controller = segue.destinationViewController;
        id<LightGroup> group = _groups[reg.view.tag];
        controller.group = group;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
