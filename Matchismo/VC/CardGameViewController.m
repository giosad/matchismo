//
//  ViewController.m
//  Matchismo
//
//  Created by Gennadi Iosad on 04/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//


#import "CardMatchingGame.h"
#import "CardView.h"
#import "CardGameViewController.h"
#import "CardGameTableViewController.h"

@interface CardGameViewController ()

@property (strong, nonatomic) NSMutableAttributedString *gameHistory;


@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameModeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;

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

- (IBAction)dealMoreCards:(UIButton *)sender {
    [self dealCards:3];
}

-(void) startNewGame {
  
  self.game = nil;  //will reset the game state
  self.gameHistory = nil; //will reset the history log
  
  [self.gameTableController removeAllCardViews];
  
  [self dealCards:12];

  self.gameModeControl.enabled = YES;
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
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
  
  //first - flip cards to faces
  for (CardView *cardView in self.gameTableController.cardViews) {
    Card *card = [self.game cardWithId:cardView.cardId];
    if (card.chosen) {
      [self.gameTableController updateCardView:cardView chosen:card.chosen];
    }
  }
  
  
  //second - flip cards to card's back
  for (CardView *cardView in self.gameTableController.cardViews) {
    Card *card = [self.game cardWithId:cardView.cardId];
    if (!card.chosen) {
      [self.gameTableController updateCardView:cardView chosen:card.chosen];
    }
  }
  
  
  //third - remove matched cards
  for (CardView *cardView in self.gameTableController.cardViews) {
    Card *card = [self.game cardWithId:cardView.cardId];
    if (card.isMatched) {
      [self.gameTableController removeCardView:cardView];
    }
  }
  
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", (int)self.game.score];
}

-(CardView*) newCardViewForCard:(Card*)card //abstract
{
  return nil;
}


-(void) dealCards:(NSUInteger)cardsAmount
{
  if ([self.gameTableController.cardViews count] < [self.gameTableController maxNumOfCardViews])
  {
    NSArray<Card*> *cards = [self.game dealCards:cardsAmount];
    for (Card* card in cards) {
      CardView* cview = [self newCardViewForCard:card];
      cview.cardId = card;
      [self.gameTableController addCardView:cview];
    }
  }
}

-(void) setupGameTable
{
  self.gameTableController.cardTapEventHandler = ^(CardView* cardView) {
    if (cardView.cardId) {
      [self.game chooseCardWithId:cardView.cardId];
      [self updateUI];
    }
    self.gameModeControl.enabled = NO;
  };

}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  NSLog(@"CardGameViewController::viewWillAppear");
    [self setupGameTable];
  
}
-(void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

  NSLog(@"CardGameViewController::viewDidAppear");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"gameTable"]) {
    if ([segue.destinationViewController isKindOfClass:[CardGameTableViewController class]]) {
      self.gameTableController = (CardGameTableViewController *)segue.destinationViewController;
    }
  }
  
  
}

@end

