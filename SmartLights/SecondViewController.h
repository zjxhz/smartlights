//
//  SecondViewController.h
//  SmartLights
//
//  Created by Xu Huanze on 9/29/13.
//  Copyright (c) 2013 Wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) IBOutlet UITableView* tableView;
@end
