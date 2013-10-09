//
//  ProfileGroupViewController.m
//  SmartLights
//
//  Created by Xu Huanze on 10/8/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import "ProfileGroupViewController.h"
#import "DemoGroupFinder.h"
#import "LightGroup.h"
#import "NewProfileViewController.h"

@interface ProfileGroupViewController ()

@end

@implementation ProfileGroupViewController

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
    _groups = [[DemoGroupFinder sharedFinder] findGroups];
    [self buildGroups];
}

-(void)newProfile:(id)sender{
    
}


-(void)buildGroups{
    [[_scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat contentHeight = 0;
    for (int i = 0; i < _groups.count; ++i) {
        int row = i / 3;
        int column = i % 3;
        UIImage* bg = [UIImage imageNamed:@"lamp_item_bg"];
        CGFloat x = 10 + column*(bg.size.width+9);
        CGFloat y = 10 + row * (bg.size.height+9);

        
        UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, bg.size.width, bg.size.height)];
        view.userInteractionEnabled = YES;
        view.tag = i;
        UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(groupTapped:)];
        [view addGestureRecognizer:tap];
        view.image = bg;
        [_scrollView addSubview:view];
        

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

        
        if (i == _groups.count - 1) {
            contentHeight = y + bg.size.height;
        }
    }
    _scrollView.contentSize = CGSizeMake(320, 10 + contentHeight);
    
    [self.view addSubview:_scrollView];
}

-(void)groupTapped:(UIGestureRecognizer*)reg{
    [self performSegueWithIdentifier:@"new_profile" sender:reg];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NewProfileViewController* controller = segue.destinationViewController;
    UIGestureRecognizer* reg = sender;
    controller.group = _groups[reg.view.tag];
}


@end
