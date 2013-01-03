//
//  EZForm
//
//  Copyright 2011-2013 Chris Miles. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EZFormInvalidIndicatorTriangleExclamationView.h"

@implementation EZFormInvalidIndicatorTriangleExclamationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    #pragma unused(rect)
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    
    /* Draw triangle
     */
    CGFloat padding = floorf(CGRectGetWidth(bounds) * 0.05f);
    CGFloat lineWidth = floorf(CGRectGetWidth(bounds) * 0.075f);
    
    CGContextMoveToPoint(c, CGRectGetMinX(bounds) + padding, CGRectGetMaxY(bounds) - padding);
    CGContextAddLineToPoint(c, floorf(CGRectGetMidX(bounds)), CGRectGetMinY(bounds) + padding);
    CGContextAddLineToPoint(c, CGRectGetMaxX(bounds) - padding, CGRectGetMaxY(bounds) - padding);
    CGContextClosePath(c);
    
    CGContextSetLineWidth(c, lineWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
    CGContextStrokePath(c);
    
    /* Draw exclamation point
     */
    CGFloat canvasWidth = bounds.size.width;
    CGFloat canvasHeight = bounds.size.height;
    CGFloat bangTopWidth = canvasWidth*0.15f;
    CGFloat bangBotWidth = canvasWidth*0.08f;
    
    // Draw top
    CGContextMoveToPoint(c, canvasWidth/2.0f - bangTopWidth/2.0f, canvasHeight*0.3f);
    CGContextAddQuadCurveToPoint(c, canvasWidth/2.0f, canvasHeight*0.2f,  canvasWidth/2.0f + bangTopWidth/2.0f, canvasHeight*0.3f);
    CGContextAddLineToPoint(c, canvasWidth/2.0f + bangBotWidth/2.0f, canvasHeight*0.65f);
    CGContextAddQuadCurveToPoint(c, canvasWidth/2.0f, canvasHeight*0.7f, canvasWidth/2.0f - bangBotWidth/2.0f, canvasHeight*0.65f);
    CGContextClosePath(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillPath(c);

    // Draw dot
    CGFloat radius = bangBotWidth;
    CGFloat centerX = canvasWidth/2;
    CGFloat centerY = canvasHeight*0.8f;
    CGContextAddEllipseInRect(c, CGRectMake(centerX - radius, centerY - radius, radius*2, radius*2));
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillPath(c);
}

@end
