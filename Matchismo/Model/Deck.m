//
//  Deck.m
//  Matchismo
//
//  Created by Gennadi Iosad on 05/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation Deck

- (NSMutableArray *) cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}


- (void) addCard:(Card*) card atTop:(BOOL) atTop
{
  if (atTop) {
    [self.cards insertObject:card atIndex:0];
  } else {
    [self.cards addObject:card];
  }
}


- (void) addCard:(Card*) card
{
  [self addCard:card atTop:NO];
}


- (Card *) drawRandomCard
{
  Card *randomCard = nil;
  if ([self.cards count]) {
    unsigned index = arc4random() % [self.cards count];
    //index = 0;
    randomCard = self.cards[index];
    [self.cards removeObjectAtIndex:index];
  }
  
  return randomCard;
}

- (NSUInteger) cardsCount
{
  return [self.cards count];
}
@end
