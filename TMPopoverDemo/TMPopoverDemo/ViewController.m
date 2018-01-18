//
//  ViewController.m
//  TMPopoverDemo
//
//  Created by Viachaslau Kastsechka on 1/18/18.
//  Copyright © 2018 Viachaslau Kastsechka. All rights reserved.
//

#import "ViewController.h"
#import "TMPopover.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *showButton;

@end

@implementation ViewController

- (IBAction)showButtonDidTap:(id)sender {

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300.f, 150.f)];
    contentView.backgroundColor = [UIColor purpleColor];
    
    [TMPopover showForSender:sender withCustomView:contentView doneBlock:^(NSInteger selectedIndex) {
        
    } dismissBlock:^{
        
    }];
    
}


@end
