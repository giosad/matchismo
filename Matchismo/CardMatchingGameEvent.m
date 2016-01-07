//
//  CardMatchingGameEvent.m
//  Matchismo
//
//  Created by Gennadi Iosad on 06/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "CardMatchingGameEvent.h"

@implementation CardMatchingGameEvent
-(NSMutableArray *)cardsParticipated
{
    if (!_cardsParticipated) _cardsParticipated = [[NSMutableArray alloc] init];
    return _cardsParticipated;
}

@end
