//
//  ViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 04/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()


@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *gameModeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *gameModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameEventInfoLabel;
@end

@implementation CardGameViewController


- (CardMatchingGame*)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                          usingDeck:[self createDeck]];
    }
    return _game;
}


- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)startNewGame:(UIButton *)sender {

    self.game = nil;  //will reset the game state
    
    [self updateUI];
    self.gameModeSwitch.enabled = YES;
    [self touchGameModeSwitch:nil]; //reset matchNumRule
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
    self.gameModeSwitch.enabled = NO;
}



- (IBAction)touchGameModeSwitch:(UISwitch *)sender
{
    if (self.gameModeSwitch.on) {
        self.gameModeLabel.text = @"2 card match mode";
        self.game.matchNumRule = 2; //@ggg check range in setter
    } else {
        self.gameModeLabel.text = @"3 card match mode";
        self.game.matchNumRule = 3;
    }
}

-(void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState: UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score %d", (int)self.game.score];
    
    self.gameEventInfoLabel.text = [self textInfoFromGameEvent:self.game.lastEvent];

}

-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed: card.isChosen ? @"cardfront" : @"cardback"];
}

-(NSString *)textInfoFromGameEvent:(CardMatchingGameEvent *)event {
    NSMutableString* cardsStr = [[NSMutableString alloc] init];
    for (Card *card in event.cardsParticipated) {
        [cardsStr appendString:card.contents];
        [cardsStr appendString:@" "];
    }
    if (event.score == 0) {
        return cardsStr;
    } else if (event.score > 0) {
        return [NSString stringWithFormat:@"Matched %@for %d points.", cardsStr, (int)event.score];
    } else { //if negative score
        return [NSString stringWithFormat:@"%@don't match! %d point penalty.", cardsStr, (int)-event.score];
    }
}
@end
