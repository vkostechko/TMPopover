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

#pragma mark - Private

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
    _backgroundLayer.fillColor = [UIColor greenColor].CGColor;
    _backgroundLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer insertSublayer:_backgroundLayer atIndex:0];
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
