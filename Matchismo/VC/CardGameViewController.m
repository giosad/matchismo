//
//  ViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 04/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "GameHistoryViewController.h"
#import "CardMatchingGame.h"
#import "CardView.h"
#import "CardGameViewController.h"
#import "PlayingCardView.h"
#import "CardGameTableViewController.h"
@interface CardGameViewController ()

@property (strong, nonatomic) NSMutableAttributedString *gameHistory;
@property (strong, nonatomic) CardMatchingGame *game;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameEventInfoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;
@property (weak, nonatomic) CardGameTableViewController *gameTableController;
@end

@implementation CardGameViewController


- (CardMatchingGame*)game //lazy init
{
  if (!_game) {
    _game = [[CardMatchingGame alloc] initWithDeck:[self createDeck]];
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
  [self.gameTableController addCardView:[[PlayingCardView alloc] initWithSuit:@"♦︎" Rank:11]];
  [self updateUI];

  self.gameModeControl.enabled = YES;
  [self touchGameModeControl:nil]; //reset matchNumRule
}




- (IBAction)touchGameModeControl:(UISegmentedControl *)sender {
  if (self.gameModeControl.selectedSegmentIndex == 0) {
    self.gameModeLabel.text = @"2 card match mode";
    self.game.matchNumRule = 2; //TODO(gena) check range in setter
  } else {
    self.gameModeLabel.text = @"3 card match mode";
    self.game.matchNumRule = 3;
  }
  
}

-(void)updateUI
{
  for (CardView *cardView in self.gameTableController.cardViews) {
    Card *card = [self.game cardWithId:cardView.cardId];
    if (card.isMatched) {
      [self.gameTableController removeCardView:cardView];
    }
  }
  
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
  self.gameEventInfoLabel.attributedText = [self textInfoFromGameEvent:self.game.lastEvent];
  
  if (self.game.lastEvent.score != 0) {
    [self.gameHistory appendAttributedString:self.gameEventInfoLabel.attributedText];
    [self.gameHistory appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
  }
  
  
}

-(CardView*) newCardViewForCard:(Card*)card //abstract
{
  return nil;
}

-(void) setupGameTable
{
  self.gameTableController.cardTapEventHandler = ^(CardView* cardView) {
    [self.game chooseCardWithId:cardView.cardId];
    [self updateUI];
    self.gameModeControl.enabled = NO;
  };
  NSArray<Card*> *cards = [self.game dealCards:1];
  CardView* cview = [self newCardViewForCard:cards[0]];
  cview.cardId = cards[0];
  [self.gameTableController addCardView:cview];
}

-(void) viewWillAppear:(BOOL)animated
{
  NSLog(@"CardGameViewController::viewDidAppear");
   [self setupGameTable];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"history"]) {
    if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
      GameHistoryViewController *ghCtrl = (GameHistoryViewController *)segue.destinationViewController;
      ghCtrl.gameHistory = self.gameHistory;
    }
  } else if ([segue.identifier isEqualToString:@"gameTable"]) {
    if ([segue.destinationViewController isKindOfClass:[CardGameTableViewController class]]) {
      self.gameTableController = (CardGameTableViewController *)segue.destinationViewController;
     

    }
  }
  
  
}

-(NSAttributedString *)textInfoFromGameEvent:(CardMatchingGameEvent *)event
{
  NSMutableAttributedString* result = [[NSMutableAttributedString alloc] init];
  //todo(gena): fix or remove
  //
  //    NSMutableAttributedString* cardsStr = [[NSMutableAttributedString alloc] init];
  //    for (Card *card in event.cardsParticipated) {
  //        [cardsStr appendAttributedString:[self titleForCard:card]];
  //        [cardsStr appendAttributedString: [[NSMutableAttributedString alloc] initWithString:@" "]];
  //    }
  //    if (event.score == 0) {
  //        [result appendAttributedString:cardsStr];
  //    } else if (event.score > 0) {
  //
  //        NSMutableAttributedString* part1 = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
  //        NSMutableAttributedString* part2 = [[NSMutableAttributedString alloc]
  //                                            initWithString:[NSString stringWithFormat:@"for %d points.",
  //                                                            (int)event.score]];
  //
  //        [result appendAttributedString:part1];
  //        [result appendAttributedString:cardsStr];
  //        [result appendAttributedString:part2];
  //
  //    } else { //if negative score
  //        NSMutableAttributedString* part2 = [[NSMutableAttributedString alloc]
  //                                            initWithString:[NSString stringWithFormat:@"don't match! %d point penalty.",(int)-event.score]];
  //        [result appendAttributedString:cardsStr];
  //        [result appendAttributedString:part2];
  //
  //    }
  //
  //    [result addAttribute:NSFontAttributeName
  //                   value:[UIFont systemFontOfSize:13]
  //                   range:NSMakeRange(0, [result length])];
  return result;
}
@end

