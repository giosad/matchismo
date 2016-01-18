//
//  PlayingCard.h
//  Matchismo
//
//  Created by Gennadi Iosad on 05/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithRank:(NSUInteger)rank suit:(NSString*)suit NS_DESIGNATED_INITIALIZER;
@property (strong, nonatomic, readonly) NSString *suit;
@property (nonatomic, readonly) NSUInteger rank;

+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;

@end
