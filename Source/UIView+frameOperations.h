//
//  UIView+frameOperations.h
//
//  Created by Matt Rankin on 4/03/2014.
//  Copyright (c) 2014 Matt Rankin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frameOperations)

- (BOOL)frameIsEqualToFrame:(CGRect)frame;
- (void)setFrameHeight:(CGFloat)height;
- (void)setFrameWidth:(CGFloat)width;
- (void)setFrameX:(CGFloat)X;
- (void)setFrameY:(CGFloat)Y;
- (void)printFrame;
+ (void)printFrame:(CGRect)frame;

@end
