//
//  UIView+frameOperations.m
//
//  Created by Matt Rankin on 4/03/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import "UIView+frameOperations.h"

@implementation UIView (frameOperations)

- (BOOL)frameIsEqualToFrame:(CGRect)frame
{
    return
    frame.origin.x == self.frame.origin.x &&
    frame.origin.y == self.frame.origin.y &&
    frame.size.width == self.frame.size.width &&
    frame.size.height == self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setFrameWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setFrameX:(CGFloat)X
{
    CGRect frame = self.frame;
    frame.origin.x = X;
    self.frame = frame;
}

- (void)setFrameY:(CGFloat)Y
{
    CGRect frame = self.frame;
    frame.origin.y = Y;
    self.frame = frame;
}

- (void)printFrame
{
    NSLog(@"(%@) %.2f, %.2f, %.2f, %.2f", [self class], self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

+ (void)printFrame:(CGRect)frame
{
    NSLog(@"(Frame) %.2f, %.2f, %.2f, %.2f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);    
}

@end
