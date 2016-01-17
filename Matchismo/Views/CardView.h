// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CardView : UIView

@property (nonatomic, weak) id cardId;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) CGFloat faceCardScaleFactor;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)drawFace;
- (void)pushContextAndRotateUpsideDown;
- (void)popContext;

@end
NS_ASSUME_NONNULL_END