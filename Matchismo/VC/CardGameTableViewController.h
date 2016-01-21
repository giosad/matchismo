// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
#import <UIKit/UIKit.h>
#import "CardView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^CardTapEventHandlerType)(CardView*);

@interface CardGameTableViewController : UIViewController
@property (nonatomic, readonly) NSArray<CardView*> *cardViews;
@property (strong, nonatomic) CardTapEventHandlerType cardTapEventHandler;
@property (nonatomic)BOOL closeGapsWhenCardsRemoved;

- (void) addCardView:(CardView*)cardView;
- (void) removeAllCardViews;
- (void) removeCardView:(CardView*)cardView;
- (void) updateCardView:(CardView*)cardView choosen:(BOOL)isChoosen;


@end

NS_ASSUME_NONNULL_END
