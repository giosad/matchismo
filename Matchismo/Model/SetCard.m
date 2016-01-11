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
- (int)match:(NSArray *) otherCards
{
    int totalScore = 0;
    for (SetCard *otherCard in otherCards) {
        int score = 0;
        //TODO(gena): implement
        totalScore += score;
        
    }
    
    return totalScore;
}


- (NSString *) contents
{
   
    return nil;
}

@end
