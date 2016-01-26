//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Gennadi Iosad on 06/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
NS_ASSUME_NONNULL_BEGIN


/// Card matching game model
@interface CardMatchingGame : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDeck:(Deck*)deck NS_DESIGNATED_INITIALIZER;

/// Tell the game that used chose the card with a specific \c cardId
- (void)chooseCardWithId:(id)cardId;

/// Returns the Card class instance associated with the given \c cardId handle
- (Card*)cardWithId:(id)cardId;

/// Draws \c count cards from the deck the game was inited with and returns them
/// May return less than \c count cards or even zero if the deck is out cards
- (NSArray<Card*>*) dealCards:(NSUInteger)count;
@property (nonatomic) NSUInteger matchNumRule;

/// Current game score
@property (nonatomic, readonly) NSInteger score;

@end
NS_ASSUME_NONNULL_END