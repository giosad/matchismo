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

-(NSArray*) mapArray:(NSArray*)arr withBlock:(id(^)(id))mapFunc
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[arr count]];
    for (id arrElem in arr) {
        [result addObject:mapFunc(arrElem)];
    }
    return result;
}

-(int) match:(NSArray *)cards
{
    NSArray<SetCard*> *allCards = [cards arrayByAddingObject:self];
    assert([cards count] == 2);
    
    int score = MISMATCH_PENALTY;
    
    NSArray* shapes = [self mapArray:allCards withBlock:^(id elem) {
        SetCard *card = (SetCard*)elem;
        return [[NSNumber alloc] initWithInt:card.shape];
    }];
    NSArray* shadings = [self mapArray:allCards withBlock:^(id elem) {
        SetCard *card = (SetCard*)elem;
        return [[NSNumber alloc] initWithInt:card.shading];
    }];
    NSArray* colors = [self mapArray:allCards withBlock:^(id elem) {
        SetCard *card = (SetCard*)elem;
        return [[NSNumber alloc] initWithInt:card.color];
    }];
    NSArray* counts = [self mapArray:allCards withBlock:^(id elem) {
        SetCard *card = (SetCard*)elem;
        return [[NSNumber alloc] initWithInt:(int)card.count];
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
