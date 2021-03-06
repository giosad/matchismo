// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "ViewAnimationQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewAnimationQueue()
//NSDictionary<id, NSValue*>* animationQueues;
@property (nonatomic) NSMutableArray<anim_block> *animationQueue;
@property (nonatomic) BOOL animationInProgress;
@end

@implementation ViewAnimationQueue
- (NSMutableArray<anim_block> *)animationQueue
{
  if (!_animationQueue) {
    _animationQueue = [[NSMutableArray<anim_block> alloc] init];
  }
  return _animationQueue;
}


-(void) tryRunNextAnimation
{
  if (self.animationInProgress) {
    return;
  }
  if (![self.animationQueue count]) {
    return;
  }
  
  anim_block nextBlockToRun = [self.animationQueue firstObject];
  [self.animationQueue removeObjectAtIndex:0];
  self.animationInProgress = YES;
//  NSLog(@"tryRunNextAnimation qCount %d", (int)[self.animationQueue count]);
  nextBlockToRun();

  
}


-(void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(anim_block)animations completion:(completion_block)completion
{
//  NSLog(@"animateWithDuration qCount %d", (int)[self.animationQueue count]);

  __weak ViewAnimationQueue* blockSelf = self;
  [self.animationQueue addObject: ^() {
//    NSLog(@"animateWithDuration anim block RUNS");
    [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:^(BOOL finished) {
      if (completion) completion(finished);
      blockSelf.animationInProgress = NO;
      [blockSelf tryRunNextAnimation];
    }];
  }];
  
    [self tryRunNextAnimation];
  
}


-(void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations
{
  [self animateWithDuration:duration
                      delay:0 options:UIViewAnimationOptionCurveEaseInOut || UIViewAnimationOptionTransitionNone
                 animations:animations
                 completion:NULL];
}


- (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(anim_block)animations completion:(completion_block)completion
{
  __weak ViewAnimationQueue* blockSelf = self;
  [self.animationQueue addObject: ^() {
    [UIView transitionWithView:view duration:duration options:options animations:animations completion:^(BOOL finished) {
      if (completion) completion(finished);
      blockSelf.animationInProgress = NO;
      [blockSelf tryRunNextAnimation];
    }];}];
  
  
  [self tryRunNextAnimation];
}

- (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animationConditions:(condition_block)conditions animations:(anim_block)animations completion:(completion_block)completion
{
  __weak ViewAnimationQueue* blockSelf = self;
  [self.animationQueue addObject: ^() {
    if (conditions && conditions()) {
      [UIView transitionWithView:view duration:duration options:options animations:animations completion:^(BOOL finished) {
        if (completion) completion(finished);
        blockSelf.animationInProgress = NO;
        [blockSelf tryRunNextAnimation];
      }];
    } else {
      blockSelf.animationInProgress = NO;
      [blockSelf tryRunNextAnimation];
    }
  }];
  
  
  [self tryRunNextAnimation];



}
@end

NS_ASSUME_NONNULL_END
