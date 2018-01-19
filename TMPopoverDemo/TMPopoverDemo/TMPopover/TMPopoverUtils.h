//
//  TMPopoverUtils.h
//  PopUp
//
//  Created by Viachaslau Kastsechka on 1/18/18.
//  Copyright © 2018 Viachaslau Kastsechka. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TMPopoverDoneBlock)(void);
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

#define TM_DEFAULT_ARROW_HEIGHT 6.f
#define TM_DEFAULT_ARROW_ROUND_RADIUS 4.f
#define TM_DEFAULT_ARROW_WIDTH 8.f
#define TM_DEFAULT_CORNER_RADIUS 4.f
#define TM_DEFAULT_BORDER_WIDTH 0.5f

#define TM_POPOVER_BACKGROUND_COLOR [UIColor whiteColor]
#define TM_POPOVER_BORDER_COLOR [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.f]

#define TM_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define TM_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define TM_DEFAULT_MARGIN 4.f

#define TM_DEFAULT_ANIMATION_DURATION 0.2
