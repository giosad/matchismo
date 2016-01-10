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
@property (nonatomic, strong) NSMutableArray *cards;  //of Card

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

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject: card];
            } else {
                self = nil;
                break;
            }
        }
    }
    self.matchNumRule = 2;
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 2;
static const int COST_TO_CHOOSE = 1;

-(NSArray* )getCardsChosenAndNotMatched
{
    NSMutableArray* chosenCards = [[NSMutableArray alloc] init];
    for (Card *card in self.cards) {
        if (card.isChosen && !card.isMatched) {
            [chosenCards addObject:card];
        }
    }
    return chosenCards;
}

//find the total score for all matches in the cards array
-(int) calcMatchScore:(NSArray *)cards
{
    int totalScore = 0;
    //go over all card pairs (twice)
    for (Card *c1 in cards) {
        for (Card *c2 in cards) {
            if (c1 != c2) {
                totalScore += [c1 match:@[c2]];
            }
        }
    }
    return totalScore / 2; //since we counted each match twice
}

-(void)checkMatchesToCard:(Card *)card
{
    int cardsToCheckNum = self.matchNumRule - 1; //minus the card we clicked on now
    CardMatchingGameEvent* ev = [[CardMatchingGameEvent alloc] init];
    self.lastEvent = ev;

    NSArray* cardsChosen = [self getCardsChosenAndNotMatched];
    [ev.cardsParticipated addObjectsFromArray:cardsChosen];
    [ev.cardsParticipated addObject:card];
    
    if ([cardsChosen count] < cardsToCheckNum) {
        ev.score = 0;
    } else {
        int matchScore = [self calcMatchScore:ev.cardsParticipated];
        if (matchScore) {
            card.matched = YES;
            ev.score = matchScore * MATCH_BONUS / cardsToCheckNum; //normalize for difficulty
            
        } else {
            ev.score = -MISMATCH_PENALTY;
        }
        
        for (Card *otherCard in cardsChosen) {
            otherCard.chosen = ev.score > 0 ? YES : NO;
            otherCard.matched = ev.score > 0 ? YES : NO;
        }
    }
    self.score += ev.score;
    
    self.lastEvent = ev;
    }

-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
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
@end
