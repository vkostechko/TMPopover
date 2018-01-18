//
//  TMPopUpView.h
//  PopUp
//
//  Created by Viachaslau Kastsechka on 1/18/18.
//  Copyright © 2018 Viachaslau Kastsechka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMPopoverUtils.h"

@interface TMPopUpView : UIView

@property (nonatomic, strong, readonly) UIView *contentView;

@property (nonatomic, strong) UIColor *popUpBackgroundColor;
@property (nonatomic, strong) UIColor *popUpBorderColor;

- (void)showWithFrame:(CGRect)frame
           anglePoint:(CGPoint)anglePoint
       arrowDirection:(TMPopOverMenuArrowDirection)arrowDirection
            doneBlock:(TMPopoverDoneBlock)doneBlock;

@end
