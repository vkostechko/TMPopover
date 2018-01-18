//
//  TMPopUpView.m
//  PopUp
//
//  Created by Viachaslau Kastsechka on 1/18/18.
//  Copyright © 2018 Viachaslau Kastsechka. All rights reserved.
//

#import "TMPopUpView.h"

@interface TMPopUpView()

@property (nonatomic, assign) TMPopOverMenuArrowDirection arrowDirection;
@property (nonatomic, strong) TMPopoverDoneBlock doneBlock;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end

@implementation TMPopUpView

#pragma mark - Public

- (void)showWithFrame:(CGRect)frame
           anglePoint:(CGPoint)anglePoint
       arrowDirection:(TMPopOverMenuArrowDirection)arrowDirection
            doneBlock:(TMPopoverDoneBlock)doneBlock
{
    self.frame = frame;
    
    _arrowDirection = arrowDirection;
    self.doneBlock = doneBlock;
    
    CGRect menuRect = CGRectMake(0, self.menuArrowHeight, self.frame.size.width, self.frame.size.height - self.menuArrowHeight);
    if (_arrowDirection == TMPopOverMenuArrowDirectionDown) {
        menuRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.menuArrowHeight);
    }
    
    [self drawBackgroundLayerWithAnglePoint:anglePoint];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self constructUI];
    }
    return self;
}

#pragma mark - Private

- (void)constructUI
{
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = TM_DEFAULT_CORNER_RADIUS;
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    
    /*
     // Add constraints
     */
    
    //Bottom
    NSLayoutConstraint *bottom = [NSLayoutConstraint
                                  constraintWithItem:self.contentView
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:self
                                  attribute:NSLayoutAttributeBottom
                                  multiplier:1.0f
                                  constant:0.f];
    //Top
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self.contentView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:TM_DEFAULT_ARROW_HEIGHT];
    //Left
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:self.contentView
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self
                                attribute:NSLayoutAttributeLeft
                                multiplier:1.0f
                                constant:0.f];
    //Right
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self
                                 attribute:NSLayoutAttributeRight
                                 multiplier:1.0f
                                 constant:0.f];
    [self addConstraints:@[top, left, bottom, right]];
}

- (void)drawBackgroundLayerWithAnglePoint:(CGPoint)anglePoint
{
    if (_backgroundLayer) {
        [_backgroundLayer removeFromSuperlayer];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat offset = 2.f * TM_DEFAULT_ARROW_ROUND_RADIUS * sinf(M_PI_4 / 2.f);
    CGFloat roundcenterHeight = offset + TM_DEFAULT_ARROW_ROUND_RADIUS * sqrtf(2.f);
    CGPoint roundcenterPoint = CGPointMake(anglePoint.x, roundcenterHeight);
    
    switch (_arrowDirection) {
        case TMPopOverMenuArrowDirectionUp: {
            [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight)];
            [path addLineToPoint:anglePoint];
            [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth, self.menuArrowHeight)];

            [path addLineToPoint:CGPointMake(TM_DEFAULT_CORNER_RADIUS, self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(TM_DEFAULT_CORNER_RADIUS, self.menuArrowHeight + TM_DEFAULT_CORNER_RADIUS) radius:TM_DEFAULT_CORNER_RADIUS startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
            [path addLineToPoint:CGPointMake(0, self.bounds.size.height - TM_DEFAULT_CORNER_RADIUS)];
            [path addArcWithCenter:CGPointMake(TM_DEFAULT_CORNER_RADIUS, self.bounds.size.height - TM_DEFAULT_CORNER_RADIUS) radius:TM_DEFAULT_CORNER_RADIUS startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake( self.bounds.size.width - TM_DEFAULT_CORNER_RADIUS, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - TM_DEFAULT_CORNER_RADIUS, self.bounds.size.height - TM_DEFAULT_CORNER_RADIUS) radius:TM_DEFAULT_CORNER_RADIUS startAngle:M_PI_2 endAngle:0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , TM_DEFAULT_CORNER_RADIUS + self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - TM_DEFAULT_CORNER_RADIUS, TM_DEFAULT_CORNER_RADIUS + self.menuArrowHeight) radius:TM_DEFAULT_CORNER_RADIUS startAngle:0 endAngle:-M_PI_2 clockwise:NO];
            [path closePath];
         
            break;
        }
        case TMPopOverMenuArrowDirectionDown: {
            roundcenterPoint = CGPointMake(anglePoint.x, anglePoint.y - roundcenterHeight);
            
            [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
            [path addLineToPoint:anglePoint];
            [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
            
            [path addLineToPoint:CGPointMake(TM_DEFAULT_CORNER_RADIUS, anglePoint.y - self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(TM_DEFAULT_CORNER_RADIUS, anglePoint.y - self.menuArrowHeight - TM_DEFAULT_CORNER_RADIUS) radius:TM_DEFAULT_CORNER_RADIUS startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [path addLineToPoint:CGPointMake(0, TM_DEFAULT_CORNER_RADIUS)];
            [path addArcWithCenter:CGPointMake(TM_DEFAULT_CORNER_RADIUS, TM_DEFAULT_CORNER_RADIUS) radius:TM_DEFAULT_CORNER_RADIUS startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width - TM_DEFAULT_CORNER_RADIUS, 0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - TM_DEFAULT_CORNER_RADIUS, TM_DEFAULT_CORNER_RADIUS) radius:TM_DEFAULT_CORNER_RADIUS startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width, anglePoint.y - (TM_DEFAULT_CORNER_RADIUS + self.menuArrowHeight))];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width - TM_DEFAULT_CORNER_RADIUS, anglePoint.y - (TM_DEFAULT_CORNER_RADIUS + self.menuArrowHeight)) radius:TM_DEFAULT_CORNER_RADIUS startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [path closePath];
            
            break;
        }
        default:
            break;
    }
    
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.path = path.CGPath;
    _backgroundLayer.lineWidth = TM_DEFAULT_BORDER_WIDTH;
    _backgroundLayer.fillColor = [UIColor whiteColor].CGColor;
    _backgroundLayer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.layer insertSublayer:_backgroundLayer atIndex:0];
    
    self.layer.cornerRadius = TM_DEFAULT_CORNER_RADIUS;
    
}

- (CGFloat)menuArrowHeight
{
    return TM_DEFAULT_ARROW_HEIGHT;
}

- (CGFloat)menuArrowWidth
{
    return TM_DEFAULT_ARROW_WIDTH;
}

@end
