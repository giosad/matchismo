//
//  ViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 04/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameHistoryViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) NSMutableAttributedString *gameHistory;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *gameModeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *gameModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameEventInfoLabel;
@end

@implementation CardGameViewController


- (CardMatchingGame*)game //lazy init
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                          usingDeck:[self createDeck]];
    }
    return _game;
}
			

- (Deck *)createDeck //abstract
{
    return nil;
}

- (NSMutableAttributedString *)gameHistory //lazy init
{
    if (!_gameHistory) {
        _gameHistory = [[NSMutableAttributedString alloc] init];
    }
    return _gameHistory;
}

- (IBAction)startNewGameButton:(UIButton *)sender {
    [self startNewGame];
}


-(void) startNewGame {
    
    self.game = nil;  //will reset the game state
    self.gameHistory = nil; //will reset the history log
    
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
        self.game.matchNumRule = 2; //TODO(gena) check range in setter
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
        [cardButton setAttributedTitle:[self titleForCardInCurrentState:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCardInCurrentState:card] forState: UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
    self.gameEventInfoLabel.attributedText = [self textInfoFromGameEvent:self.game.lastEvent];
    
    if (self.game.lastEvent.score != 0) {
        [self.gameHistory appendAttributedString:self.gameEventInfoLabel.attributedText];
        [self.gameHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }


}

-(NSAttributedString *)titleForCard:(Card *)card //abstract
{
    return nil;
}


-(NSAttributedString *)titleForCardInCurrentState:(Card *)card //abstract
{
    return nil;
}



-(UIImage *)backgroundImageForCardInCurrentState:(Card *)card //abstract
{
    return nil;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"history"]) {
        if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
            GameHistoryViewController *ghCtrl = (GameHistoryViewController *)segue.destinationViewController;
            ghCtrl.gameHistory = self.gameHistory;
        }
    }
}

-(NSAttributedString *)textInfoFromGameEvent:(CardMatchingGameEvent *)event
{
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString* cardsStr = [[NSMutableAttributedString alloc] init];
    for (Card *card in event.cardsParticipated) {
        [cardsStr appendAttributedString:[self titleForCard:card]];
        [cardsStr appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@" "]];
    }
    if (event.score == 0) {
        [result appendAttributedString:cardsStr];
    } else if (event.score > 0) {
        
        NSMutableAttributedString* part1 = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
        NSMutableAttributedString* part2 = [[NSMutableAttributedString alloc]
                                            initWithString:[NSString stringWithFormat:@"for %d points.",
                                                            (int)event.score]];
        
        [result appendAttributedString:part1];
        [result appendAttributedString:cardsStr];
        [result appendAttributedString:part2];
        
    } else { //if negative score
        NSMutableAttributedString* part2 = [[NSMutableAttributedString alloc]
                                            initWithString:[NSString stringWithFormat:@"don't match! %d point penalty.",(int)-event.score]];
        [result appendAttributedString:cardsStr];
        [result appendAttributedString:part2];
        
    }
    
    [result addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:13]
                   range:NSMakeRange(0, [result length])];
    return result;
}
@end

