//
//  Deck.h
//  Matchismo
//
//  Created by Gennadi Iosad on 05/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
@interface Deck : NSObject
- (void) addCard:(Card *)card atTop:(BOOL) atTop;
- (void) addCard:(Card *)card;
- (Card *) drawRandomCard;
- (NSUInteger) cardsCount;
@end
