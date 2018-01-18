//
//  TMPopoverUtils.h
//  PopUp
//
//  Created by Viachaslau Kastsechka on 1/18/18.
//  Copyright © 2018 Viachaslau Kastsechka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TMPopoverDoneBlock)(NSInteger selectedIndex);
typedef void (^TMPopoverDismissBlock)(void);

typedef NS_ENUM(NSUInteger, TMPopOverMenuArrowDirection) {
    /**
     *  Up
     */
    TMPopOverMenuArrowDirectionUp,
    /**
     *  Down
     */
    TMPopOverMenuArrowDirectionDown,
};

#define TM_DEFAULT_ARROW_HEIGHT 10.f
#define TM_DEFAULT_ARROW_ROUND_RADIUS 4.f
#define TM_DEFAULT_ARROW_WIDTH 8.f
#define TM_DEFAULT_CORNER_RADIUS 15.f
#define TM_DEFAULT_BORDER_WIDTH 0.8

#define TM_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define TM_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define TM_DEFAULT_MARGIN 4.f

#define TM_DEFAULT_ANIMATION_DURATION 0.2
