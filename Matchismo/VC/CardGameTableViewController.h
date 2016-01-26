// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
#import <UIKit/UIKit.h>
#import "CardView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^CardTapEventHandlerType)(CardView*);


/// Card game table controller of the embedded game table view
@interface CardGameTableViewController : UIViewController

/// The handler should that is called when a card is tapped
@property (strong, nonatomic) CardTapEventHandlerType cardTapEventHandler;

/// Return an array of cardViews added to the game table
@property (nonatomic, readonly) NSArray<CardView*> *cardViews;

/// Tell if to realign cards after a card is removed
/// Should be set in a child class
//protected//
@property (nonatomic)BOOL closeGapsWhenCardsRemoved;


/// Specifies a card choose animation played when user taps a card etc.
/// Should be set in a child class
//protected//
@property (nonatomic) UIViewAnimationOptions cardChooseAnimation;


/// Choose animation duration time.
/// Should be set in a child class
//protected//
@property (nonatomic) CGFloat cardChooseAnimationTime;

/// Add a card view to the game table (animated) - it will be automatically placed where appropriate
- (void) addCardView:(CardView*)cardView;

/// Remove all card views from the table (animated)
- (void) removeAllCardViews;

/// Remove a specific cardView from the table (animated)
- (void) removeCardView:(CardView*)cardView;

/// Update \c cardView chosen property
- (void) updateCardView:(CardView*)cardView chosen:(BOOL)ischosen;

/// Max amount of the cards the table can hold simultaneously
- (NSUInteger) maxNumOfCardViews;

@end

NS_ASSUME_NONNULL_END
