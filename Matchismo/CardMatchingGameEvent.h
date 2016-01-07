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
@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSMutableArray *cardsParticipated;
@end
