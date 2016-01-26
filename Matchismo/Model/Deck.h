//
//  Deck.h
//  Matchismo
//
//  Created by Gennadi Iosad on 05/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

/// Abstract class for deck object, should be subclassed to handle a certain card type.
@interface Deck : NSObject


/// Add a new card \c card to the deck, atTop: if YES - adds at index 0
- (void) addCard:(Card *)card atTop:(BOOL) atTop;

/// Add a new card to the end of the deck
- (void) addCard:(Card *)card;

/// Returns a random cards which is removed from the deck.
- (Card *) drawRandomCard;


/// Current cards amount in the deck
- (NSUInteger) cardsCount;


@end
