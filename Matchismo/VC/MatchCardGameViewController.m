//
//  MatchGameViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "MatchCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"
@implementation MatchCardGameViewController

- (Deck *)createDeck //override
{
  return [[PlayingCardDeck alloc] init];
}

-(CardView*) newCardViewForCard:(Card*)card //override
{
  PlayingCard *playingCard = (PlayingCard*)card;
  return [[PlayingCardView alloc] initWithSuit:playingCard.suit Rank:playingCard.rank];
}

@end
