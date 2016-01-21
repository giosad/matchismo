// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
@import UIKit;
NS_ASSUME_NONNULL_BEGIN

@interface ViewAnimationQueue : NSObject
-(void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;
-(void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations;

- (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^ __nullable)(void))animations completion:(void (^ __nullable)(BOOL finished))completion;


@end

NS_ASSUME_NONNULL_END
