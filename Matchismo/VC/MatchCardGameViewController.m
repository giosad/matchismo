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

@implementation MatchCardGameViewController

- (Deck *)createDeck //override
{
    return [[PlayingCardDeck alloc] init];
}

-(NSAttributedString* ) titleForCard:(Card *)card //override
{
    NSArray *rankStrings = @[@"A",@"2",@"3",@"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    PlayingCard *playingCard = (PlayingCard*)card;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
    
    //"♣︎", @"♠︎", @"♦︎", @"♥︎"
    NSMutableAttributedString *suitStr = [[NSMutableAttributedString alloc]
                                          initWithString:playingCard.suit];
    
    UIColor *suitColor = [@[ @"♦︎", @"♥︎"] containsObject:playingCard.suit] ? [UIColor redColor] : [UIColor blackColor];
    
    [suitStr addAttribute:NSForegroundColorAttributeName
                    value:suitColor
                    range:NSMakeRange(0, [suitStr length])];
    
    NSMutableAttributedString *rankStr = [[NSMutableAttributedString alloc]
                                          initWithString:rankStrings[playingCard.rank]];
    
    [rankStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:NSMakeRange(0, [rankStr length])];
    
    [title appendAttributedString: suitStr];
    [title appendAttributedString: rankStr];
    
//    
//    [title addAttribute:NSFontAttributeName
//                 value:[UIFont systemFontOfSize:11]
//                  range:NSMakeRange(0, [title length])];
    return title;
}

-(NSAttributedString *)titleForCardInCurrentState:(Card *)card //override
{
    return card.isChosen ?  [self titleForCard:card] : [[NSAttributedString alloc] init];
}

-(UIImage *)backgroundImageForCardInCurrentState:(Card *)card //override
{
    return [UIImage imageNamed: card.isChosen ? @"cardfront" : @"cardback"];
}


@end
