// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
@import UIKit;
NS_ASSUME_NONNULL_BEGIN
typedef void (^anim_block)(void);
typedef void (^  __nullable completion_block)(BOOL finished);
typedef BOOL (^condition_block)(void);

/// Imitates the UIView API but executes animations in a sequential order
@interface ViewAnimationQueue : NSObject


-(void)animateWithDuration:(NSTimeInterval)duration
                animations:(anim_block)animations;


-(void)animateWithDuration:(NSTimeInterval)duration
                     delay:(NSTimeInterval)delay
                   options:(UIViewAnimationOptions)options
                animations:(anim_block)animations
                completion:(completion_block)completion;


-(void)transitionWithView:(UIView *)view
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
               animations:(anim_block)animations
               completion:(completion_block)completion;

/// \c conditions - to be checked when the item is dequeued and before the animation block is executed
-(void)transitionWithView:(UIView *)view
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
      animationConditions:(condition_block)conditions
               animations:(anim_block)animations
               completion:(completion_block)completion;


@end

NS_ASSUME_NONNULL_END
