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

    UIView *contentView = [UIView new];
    contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    
    [TMPopover showForSender:sender withCustomView:contentView size:CGSizeMake(230.f, 150.f) doneBlock:^(NSInteger selectedIndex) {
        
    } dismissBlock:^{
        
    }];
    
}


@end
