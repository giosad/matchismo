//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Gennadi Iosad on 06/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "CardMatchingGame.h"
#import "CardMatchingGameEvent.h"
@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray<Card*> *cards;
@property (nonatomic, strong) Deck *deck;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

- (instancetype)init
{
  return nil;
}

- (instancetype)initWithDeck:(Deck *)deck
{
  if (self = [super init]) {
    self.deck = deck;
    self.matchNumRule = 2;
  }
  
  return self;
}

-(NSArray<Card*>* ) drawNewCards:(NSUInteger)count
{
  NSMutableArray<Card*>* newCards = [[NSMutableArray<Card*> alloc] init];
  for (int i = 0; i < count; i++) {
    Card *card = [self.deck drawRandomCard];
    if (!card) {
      break;
    }
    [self.cards addObject: card];
    [newCards addObject: card];
  }
  return newCards;
}


-(NSArray<Card*>* )getCardsChosenAndNotMatched
{
  NSMutableArray* chosenCards = [[NSMutableArray alloc] init];
  for (Card *card in self.cards) {
    if (card.isChosen && !card.isMatched) {
      [chosenCards addObject:card];
    }
  }
  return chosenCards;
}

-(void)checkMatchesToCard:(Card *)card
{
  int cardsToCheckNum = (int)self.matchNumRule - 1; //minus the card we clicked on now
  NSInteger matchScore = 0;
  
  NSArray<Card*> *cardsChosen = [self getCardsChosenAndNotMatched];

  
  //if didn't finish choosing cards up to the policy amount
  if ([cardsChosen count] < cardsToCheckNum) {
    matchScore = 0;
  } else {
    matchScore = [card match:cardsChosen];
    if (matchScore > 0) {
      card.matched = YES;
    }
    
    for (Card *otherCard in cardsChosen) {
      otherCard.chosen = matchScore > 0 ? YES : NO;
      otherCard.matched = matchScore > 0 ? YES : NO;
    }
  }
  self.score += matchScore;
  
  
  NSMutableArray<Card*> *cardsReported = [cardsChosen mutableCopy];
  [cardsReported addObject:card];
  CardMatchingGameEvent* ev = [[CardMatchingGameEvent alloc] initWithScore:matchScore cardsToReport:cardsReported];
  self.lastEvent = ev;
}

static const int COST_TO_CHOOSE = 1;
-(void)chooseCardWithId:(id)cardId
{
  Card *card = [self cardWithId:cardId];
  if (!card.isMatched) {
    if (card.isChosen) {
      card.chosen = NO;
    } else {
      [self checkMatchesToCard:card];
      self.score -= COST_TO_CHOOSE;
      card.chosen = YES;
    }
  }
}

-(Card*) cardWithId:(id)cardId
{
  return (Card*)cardId;
}
@end
