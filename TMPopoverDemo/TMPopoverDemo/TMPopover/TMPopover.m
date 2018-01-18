//
//  TMPopover.m
//  PopUp
//
//  Created by Viachaslau Kastsechka on 1/18/18.
//  Copyright © 2018 Viachaslau Kastsechka. All rights reserved.
//

#import "TMPopover.h"
#import "TMPopUpView.h"

@interface TMPopover() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) TMPopUpView *popUpView;
@property (nonatomic, copy) TMPopoverDoneBlock doneBlock;
@property (nonatomic, copy) TMPopoverDismissBlock dismissBlock;

@property (nonatomic, strong) UIView *sender;
@property (nonatomic, assign) CGRect senderFrame;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign) CGSize menuSize;

@property (nonatomic, assign) BOOL isCurrentlyOnScreen;

@property (nonatomic, strong) UIColor *backgroundViewColor;

@end

@implementation TMPopover

#pragma mark - Lifecycle

+ (TMPopover *)sharedInstance
{
    static dispatch_once_t once = 0;
    static TMPopover *shared;
    dispatch_once(&once, ^{
        shared = [TMPopover new];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangeStatusBarOrientationNotification:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        _backgroundViewColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

+ (void)showForSender:(UIView *)sender withCustomView:(UIView *)contentView size:(CGSize)size doneBlock:(TMPopoverDoneBlock)doneBlock dismissBlock:(TMPopoverDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:sender size:size contentView:contentView doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void)dismiss
{
    [[self sharedInstance] dismiss];
}

#pragma mark - Notifications handlers

- (void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    if (self.isCurrentlyOnScreen) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self adjustPopOverMenu];
        });
    }
}

#pragma mark - Private

- (void) showForSender:(UIView *)sender size:(CGSize)size contentView:(UIView *)contentView doneBlock:(TMPopoverDoneBlock)doneBlock dismissBlock:(TMPopoverDismissBlock)dismissBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.backgroundView addSubview:self.popUpView];
        [[self backgroundWindow] addSubview:self.backgroundView];
        
        self.sender = sender;
        self.senderFrame = CGRectNull;
        self.menuSize = size;
        self.contentView = contentView;
        [self.popUpView.contentView addSubview:self.contentView];
        
        //Bottom
        NSLayoutConstraint *bottom = [NSLayoutConstraint
                                     constraintWithItem:self.contentView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.popUpView.contentView
                                     attribute:NSLayoutAttributeBottom
                                     multiplier:1.0f
                                     constant:0.f];
        //Top
        NSLayoutConstraint *top = [NSLayoutConstraint
                                  constraintWithItem:self.contentView
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self.popUpView.contentView
                                  attribute:NSLayoutAttributeTop
                                  multiplier:1.0f
                                  constant:TM_DEFAULT_ARROW_HEIGHT];
        //Left
        NSLayoutConstraint *left = [NSLayoutConstraint
                                   constraintWithItem:self.contentView
                                   attribute:NSLayoutAttributeLeft
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.popUpView.contentView
                                   attribute:NSLayoutAttributeLeft
                                   multiplier:1.0f
                                   constant:0.f];
        //Right
        NSLayoutConstraint *right = [NSLayoutConstraint
                                   constraintWithItem:self.contentView
                                   attribute:NSLayoutAttributeRight
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.popUpView.contentView
                                   attribute:NSLayoutAttributeRight
                                   multiplier:1.0f
                                   constant:0.f];
        [self.popUpView.contentView addConstraints:@[top, left, bottom, right]];
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        self.doneBlock = doneBlock;
        self.dismissBlock = dismissBlock;
        
        [self adjustPopOverMenu];
    });
}

#pragma mark - dismiss animation

- (void)dismiss
{
#warning NOT IMPLEMENTED
    self.isCurrentlyOnScreen = NO;
    [self doneActionWithSelectedIndex:-1];
}

#pragma mark - Private properties

- (UIWindow *)backgroundWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if (window == nil && [delegate respondsToSelector:@selector(window)]){
        window = [delegate performSelector:@selector(window)];
    }
    return window;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
        _backgroundView.backgroundColor = self.backgroundViewColor;
    }
    return _backgroundView;
}

- (TMPopUpView *)popUpView
{
    if (!_popUpView) {
        _popUpView = [[TMPopUpView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _popUpView.alpha = 0;
    }
    return _popUpView;
}

#pragma mark - Helpers

- (void)adjustPopOverMenu
{
    [self.backgroundView setFrame:CGRectMake(0, 0, TM_SCREEN_WIDTH, TM_SCREEN_HEIGHT)];
    
    CGRect senderRect;
    
    if (self.sender) {
        senderRect = [self.sender.superview convertRect:self.sender.frame toView:self.backgroundView];
        /*
         // if run into touch problems on nav bar, use the fowllowing line.
         // senderRect.origin.y = MAX(64-senderRect.origin.y, senderRect.origin.y);
         */
    } else {
        senderRect = self.senderFrame;
    }
    if (senderRect.origin.y > TM_SCREEN_HEIGHT) {
        senderRect.origin.y = TM_SCREEN_HEIGHT;
    }
    
    CGFloat menuHeight = self.menuSize.height;
    CGFloat menuWidth = self.menuSize.width;
    CGPoint menuArrowPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width) / 2, 0);
    CGFloat menuX = 0;
    CGRect menuRect = CGRectZero;
    
    TMPopOverMenuArrowDirection arrowDirection;
    
    if (senderRect.origin.y + senderRect.size.height / 2  < TM_SCREEN_HEIGHT / 2) {
        arrowDirection = TMPopOverMenuArrowDirectionUp;
        menuArrowPoint.y = 0;
    } else {
        arrowDirection = TMPopOverMenuArrowDirectionDown;
        menuArrowPoint.y = menuHeight;
        
    }
    
    if (menuArrowPoint.x + menuWidth / 2 + TM_DEFAULT_MARGIN > TM_SCREEN_WIDTH) {
        menuArrowPoint.x = MIN(menuArrowPoint.x - (TM_SCREEN_WIDTH - menuWidth - TM_DEFAULT_MARGIN), menuWidth - self.menuArrowWidth - TM_DEFAULT_MARGIN);
        menuX = TM_SCREEN_WIDTH - menuWidth - TM_DEFAULT_MARGIN;
    } else if ( menuArrowPoint.x - menuWidth/2 - TM_DEFAULT_MARGIN < 0) {
        menuArrowPoint.x = MAX( TM_DEFAULT_CORNER_RADIUS + self.menuArrowWidth, menuArrowPoint.x - TM_DEFAULT_MARGIN);
        menuX = TM_DEFAULT_MARGIN;
    }else{
        menuArrowPoint.x = menuWidth / 2;
        menuX = senderRect.origin.x + (senderRect.size.width) / 2 - menuWidth / 2;
    }
    
    if (arrowDirection == TMPopOverMenuArrowDirectionUp) {
        menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), menuWidth, menuHeight);
        /*
         // if too long and is out of screen
         */
        if (menuRect.origin.y + menuRect.size.height > TM_SCREEN_HEIGHT) {
            menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), menuWidth, TM_SCREEN_HEIGHT - menuRect.origin.y - TM_DEFAULT_MARGIN);
        }
    } else {
        menuRect = CGRectMake(menuX, (senderRect.origin.y - menuHeight), menuWidth, menuHeight);
        /*
         // if too long and is out of screen
         */
        if (menuRect.origin.y  < 0) {
            menuRect = CGRectMake(menuX, TM_DEFAULT_MARGIN, menuWidth, senderRect.origin.y - TM_DEFAULT_MARGIN);
            menuArrowPoint.y = senderRect.origin.y;
        }
    }
    
    [self prepareToShowWithMenuRect:menuRect
                     menuArrowPoint:menuArrowPoint
                     arrowDirection:arrowDirection];
    
    [self show];
}

- (void)prepareToShowWithMenuRect:(CGRect)menuRect menuArrowPoint:(CGPoint)menuArrowPoint arrowDirection:(TMPopOverMenuArrowDirection)arrowDirection
{
    CGPoint anchorPoint = CGPointMake(menuArrowPoint.x / menuRect.size.width, 0);
    if (arrowDirection == TMPopOverMenuArrowDirectionDown) {
        anchorPoint = CGPointMake(menuArrowPoint.x / menuRect.size.width, 1);
    }
    _popUpView.transform = CGAffineTransformMakeScale(1, 1);
    
    [_popUpView showWithFrame:menuRect
                   anglePoint:menuArrowPoint
               arrowDirection:arrowDirection
                    doneBlock:^(NSInteger selectedIndex) {
                        [self doneActionWithSelectedIndex:selectedIndex];
                    }];
    
    [self setAnchorPoint:anchorPoint forView:_popUpView];
    
    _popUpView.transform = CGAffineTransformMakeScale(0.1, 0.1);
}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

- (void)show
{
    self.isCurrentlyOnScreen = YES;
    [UIView animateWithDuration:TM_DEFAULT_ANIMATION_DURATION
                     animations:^{
                         _popUpView.alpha = 1;
                         _popUpView.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

- (void)doneActionWithSelectedIndex:(NSInteger)selectedIndex
{
    [UIView animateWithDuration:TM_DEFAULT_ANIMATION_DURATION
                     animations:^{
                         _popUpView.alpha = 0;
                         _popUpView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self.popUpView removeFromSuperview];
                             [self.backgroundView removeFromSuperview];
                             if (selectedIndex < 0) {
                                 if (self.dismissBlock) {
                                     self.dismissBlock();
                                 }
                             } else {
                                 if (self.doneBlock) {
                                     self.doneBlock(selectedIndex);
                                 }
                             }
                         }
                     }];
}

- (CGFloat)menuArrowWidth
{
    return TM_DEFAULT_ARROW_WIDTH;
}

- (CGFloat)menuArrowHeight
{
    return TM_DEFAULT_ARROW_HEIGHT;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:_popUpView];
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        return NO;
    }
    return YES;
}

#pragma mark - onBackgroundViewTapped

-(void)onBackgroundViewTapped:(UIGestureRecognizer *)gesture
{
    [self dismiss];
}

@end
