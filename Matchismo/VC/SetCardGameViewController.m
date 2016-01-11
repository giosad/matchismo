//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@implementation SetCardGameViewController
- (Deck *)createDeck //override
{
    return [[SetCardDeck alloc] init];
}

-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed: card.isChosen ? @"cardfrontselected" : @"cardfront"];
}

@end
