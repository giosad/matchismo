//
//  ViewController.h
//  Matchismo
//
//  Created by Gennadi Iosad on 04/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardView.h"
#import "CardGameTableViewController.h"
#import "CardMatchingGame.h"

NS_ASSUME_NONNULL_BEGIN

/// The abstract card game controller
@interface CardGameViewController : UIViewController

/// Return a new deck of cards that follow a certain match rule
//protected abstract//
- (Deck *)createDeck;

/// Given the \card returns a view that can represent the card markings
//protected abstract//
-(CardView*) newCardViewForCard:(Card*)card;

/// Do initial game setup - configure game table etc. called once.
//protected//
-(void) setupGameTable;

/// Start new game, remove all cards present, reset score, match rule, redeal initial amount of cards
//protected//
-(void) startNewGame;

/// Game table controller getter to be used by child classes
//protected//
@property (weak, nonatomic, readonly) CardGameTableViewController *gameTableController;

/// Game model getter to be used by child classes
//protected//
@property (strong, nonatomic, readonly, nullable) CardMatchingGame *game;
@end
NS_ASSUME_NONNULL_END
