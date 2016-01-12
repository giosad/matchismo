//
//  SetCard.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
+(int)maxCount {
    return 3;
}
const static int MISMATCH_PENALTY = -3;
const static int MATCH_BONUS = 10;

-(BOOL) allEqualOrDifferent:(NSArray*)array
{
    NSSet *uniqueSet = [NSSet setWithArray:array];
    return ([uniqueSet count] == 1) || ([uniqueSet count] == [array count]);
}

-(NSArray*) mapCardsArray:(NSArray*)arr withBlock:(int(^)(SetCard*))mapFunc
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[arr count]];
    for (SetCard *card in arr) {
        [result addObject:[NSNumber numberWithInt:mapFunc(card)]];
    }
    return result;
}

-(int) match:(NSArray *)cards
{
    NSArray<SetCard*> *allCards = [cards arrayByAddingObject:self];
    int score = MISMATCH_PENALTY;
    
    NSArray* shapes = [self mapCardsArray:allCards withBlock:^(SetCard* card) {
        return (int)card.shape;
    }];
    NSArray* shadings = [self mapCardsArray:allCards withBlock:^(SetCard* card) {
        return (int)card.shading;
    }];
    NSArray* colors = [self mapCardsArray:allCards withBlock:^(SetCard* card) {
        return (int)card.color;
    }];
    NSArray* counts = [self mapCardsArray:allCards withBlock:^(SetCard* card) {
        return (int)card.count;
    }];
    

    if ([self allEqualOrDifferent:shapes] &&
        [self allEqualOrDifferent:shadings] &&
        [self allEqualOrDifferent:colors] &&
        [self allEqualOrDifferent:counts]) {
        score = MATCH_BONUS;
    }
    
    return score;
}




- (NSString *) contents
{
   
    return nil;
}

@end
