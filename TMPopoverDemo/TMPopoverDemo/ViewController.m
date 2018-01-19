//
//  ViewController.m
//  TMPopoverDemo
//
//  Created by Viachaslau Kastsechka on 1/18/18.
//  Copyright © 2018 Viachaslau Kastsechka. All rights reserved.
//

#import "ViewController.h"
#import "TMPopover.h"
#import "TMTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *dataItems;
}
@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataItems = @[@"1", @"2", @"3"];
}

- (IBAction)showButtonDidTap:(id)sender {

    UITableView *contentView = [UITableView new];
    contentView.delegate = self;
    contentView.dataSource = self;
    
    [contentView registerClass:[TMTableViewCell class] forCellReuseIdentifier:@"TMTableViewCell"];
    
    [TMPopover showForSender:sender withCustomView:contentView size:CGSizeMake(230.f, 150.f) dismissBlock:^{
        NSLog(@"dismissBlock");
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TMTableViewCell" forIndexPath:indexPath];
    cell.text = [NSString stringWithFormat:@"index %@", @(indexPath.row)];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataItems.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at index: %@", @(indexPath.row));
}

@end
