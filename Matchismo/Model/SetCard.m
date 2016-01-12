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
const static int MISMATCH_PENALTY = -2;
// Find the total score for all matches in the cards array.
-(int) match:(NSArray *)cards
{
    NSArray *allCards = [cards arrayByAddingObject:self];
    int totalScore = 0;
      
    if (totalScore > 0) {
        // /2 since we counted each match twice, / count for score normalization.
        totalScore = totalScore / 2 / [allCards count];
    } else {
        totalScore = MISMATCH_PENALTY;
    }
    return totalScore;
}

- (NSString *) contents
{
   
    return nil;
}

@end
