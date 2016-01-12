//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 11/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController()
@end
@implementation SetCardGameViewController


- (Deck *)createDeck //override
{
    return [[SetCardDeck alloc] init];
}

//▲ ● ■
-(NSAttributedString* ) titleForCard:(Card *)card
{
    SetCard *setCard = (SetCard*)card;
    
    NSMutableString *titleStr = [[NSMutableString alloc] init];
    NSString *shapeStr = nil;
    switch (setCard.shape){
        case SetCardShapeCircle:
            shapeStr = @"●";
            //shapeStr = @"A";
            break;
        case SetCardShapeRectangle:
            shapeStr = @"■";
            //shapeStr = @"B";
            break;
        case SetCardShapeTriangle:
            shapeStr = @"▲";
            //shapeStr = @"C";
            break;
        default:
            shapeStr = @"?";
            break;
    }

    for (int i = 0; i < setCard.count; i++) {
        [titleStr appendString:shapeStr];
     }
    
    
    UIColor *fillColor = [UIColor blackColor];
    UIColor *strokeColor = [UIColor blackColor];
    
    switch (setCard.color) {
        case SetCardColorRed:
            strokeColor = [UIColor redColor];
            break;
        case SetCardColorGreen:
            strokeColor = [UIColor greenColor];
            break;
        case SetCardColorBlue:
            strokeColor = [UIColor blueColor];
            break;
    }
    
    switch (setCard.shading) {
        case SetCardShadingEmpty:
            fillColor = [strokeColor colorWithAlphaComponent:0];
            break;
        case SetCardShadingStripes:
            fillColor = [strokeColor colorWithAlphaComponent:0.3];
            break;
        case SetCardShadindFull:
            fillColor = strokeColor;
            break;
    }
    
    
    NSDictionary* titleAttribs = @{
    NSStrokeWidthAttributeName : @-10,
    NSStrokeColorAttributeName : strokeColor,
    NSForegroundColorAttributeName: fillColor,
    NSFontAttributeName: [UIFont systemFontOfSize:10]};
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]
                                        initWithString:titleStr
                                        attributes:titleAttribs];
    


    //
    //    [title addAttribute:NSFontAttributeName
    //                 value:[UIFont systemFontOfSize:11]
    //                  range:NSMakeRange(0, [title length])];
    return title;
}

-(NSAttributedString *)titleForCardInCurrentState:(Card *)card //override
{
    return [self titleForCard:card];
}




-(UIImage *)backgroundImageForCardInCurrentState:(Card *)card //override
{
    return [UIImage imageNamed: card.isChosen ? @"cardfrontselected" : @"cardfront"];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self startNewGame];
}

@end
