//
//  TMPopover.h
//  PopUp
//
//  Created by Viachaslau Kastsechka on 1/18/18.
//  Copyright © 2018 Viachaslau Kastsechka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMPopoverUtils.h"

@interface TMPopover : NSObject

+ (void)showForSender:(UIView *)sender withCustomView:(UIView *)contentView size:(CGSize)size dismissBlock:(TMPopoverDismissBlock)dismissBlock;

+ (void)dismiss;

+ (BOOL)isVisible;

@end
