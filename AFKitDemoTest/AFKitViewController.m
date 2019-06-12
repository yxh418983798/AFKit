//
//  AFKitViewController.m
//  AFKitDemoTest
//
//  Created by alfie on 2019/6/12.
//  Copyright © 2019 Alfie. All rights reserved.
//

#import "AFKitViewController.h"
#import "AFTimerViewController.h"

#define ScreenWidth         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight        [[UIScreen mainScreen] bounds].size.height


@interface AFKitViewController () <UITableViewDelegate, UITableViewDataSource>

/** tableView */
@property (nonatomic, strong) UITableView                *tableView;

/** 数据源 */
@property (nonatomic, strong) NSMutableArray             *dataSource;

@end

@implementation AFKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = [NSMutableArray array];

    self.tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    self.tableView.rowHeight = 45;
    self.tableView.sectionFooterHeight = 0.001;
    self.tableView.sectionHeaderHeight = 0.001;
    
    //控制器数据源
    [self addDataSourceWithText:@"定时器" class:@"AFTimerViewController"];
}


- (void)addDataSourceWithText:(NSString *)text class:(NSString *)className {
    NSDictionary *data = @{
                           @"text" : text,
                           @"class" : className
                           };
    [self.dataSource addObject:data];
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"UITableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *data = self.dataSource[indexPath.row];
    cell.textLabel.text = [data valueForKey:@"text"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:[NSClassFromString([data valueForKey:@"class"]) new] animated:YES];
}




@end
