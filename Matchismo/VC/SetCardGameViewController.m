//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
@implementation SetCardGameViewController


- (Deck *)createDeck //override
{
    return [[SetCardDeck alloc] init];
}

//▲ ● ■
-(NSAttributedString* ) titleForCard:(Card *)card
{
    SetCard *setCard = (SetCard*)card;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] init];
    
    //"♣︎", @"♠︎", @"♦︎", @"♥︎"
#if 0
    NSMutableAttributedString *suitStr = [[NSMutableAttributedString alloc]
                                          initWithString:setCard.suit];
    
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
#endif
    //
    //    [title addAttribute:NSFontAttributeName
    //                 value:[UIFont systemFontOfSize:11]
    //                  range:NSMakeRange(0, [title length])];
    return title;
}

-(NSAttributedString *)titleForCardInCurrentState:(Card *)card //override
{
    return [self titleForCard:card];
}




-(UIImage *)backgroundImageForCardInCurrentState:(Card *)card //override
{
    return [UIImage imageNamed: card.isChosen ? @"cardfrontselected" : @"cardfront"];
}



@end
