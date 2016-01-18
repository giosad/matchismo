//
//  CardMatchingGameEvent.h
//  Matchismo
//
//  Created by Gennadi Iosad on 06/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
@interface CardMatchingGameEvent : NSObject
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithScore:(NSInteger)score cardsToReport:(NSArray<Card*>*)cards NS_DESIGNATED_INITIALIZER;
@property (nonatomic,readonly) NSInteger score;
@property (strong, nonatomic, readonly) NSArray<Card* > *cardsReported;
@end
