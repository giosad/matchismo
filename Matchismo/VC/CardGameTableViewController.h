// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
#import <UIKit/UIKit.h>
#import "CardView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^CardTapEventHandlerType)(CardView*);

@interface CardGameTableViewController : UIViewController


@property (strong, nonatomic) CardTapEventHandlerType cardTapEventHandler;
@property (nonatomic, readonly) NSArray<CardView*> *cardViews;

//protected//
@property (nonatomic)BOOL closeGapsWhenCardsRemoved;

//protected//
@property (nonatomic) UIViewAnimationOptions cardChooseAnimation;

//protected//
@property (nonatomic) CGFloat cardChooseAnimationTime;

- (void) addCardView:(CardView*)cardView;
- (void) removeAllCardViews;
- (void) removeCardView:(CardView*)cardView;
- (void) updateCardView:(CardView*)cardView chosen:(BOOL)ischosen;
- (NSUInteger) maxNumOfCardViews;


@end

NS_ASSUME_NONNULL_END
