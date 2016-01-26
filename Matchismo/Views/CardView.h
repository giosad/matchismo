// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

//Common base class for CardViews
@interface CardView : UIView

@property (nonatomic, weak) id cardId;
@property (nonatomic) BOOL chosen; 
@property (nonatomic) CGFloat faceCardScaleFactor;


/// should be implemented by a child class to draw the card markings and indicate chosen state
/// abstract and protected ///
- (void)drawCardInners;


@end
NS_ASSUME_NONNULL_END
