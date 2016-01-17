//
//  SetDeck.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"
@implementation SetCardDeck
- (instancetype) init
{
    if (self = [super init]) {
        for (int shape = 0; shape < SetCardShapeCount; shape++) {
            for (int color = 0; color < SetCardColorCount; color++) {
                for (int shading = 0; shading < SetCardShadingCount; shading++) {
                    for (NSUInteger count = 1; count <= [SetCard maxCount]; count++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = (SetCardShape)shape;
                        card.color = (SetCardColor)color;
                        card.shading = (SetCardShading)shading;
                        card.count = count;
                        
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end
