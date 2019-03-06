//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 28/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"

@interface ThemesViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *firstButton;
@property (nonatomic, weak) IBOutlet UIButton *secondButton;
@property (nonatomic, weak) IBOutlet UIButton *thirdButton;
@property (nonatomic, weak) IBOutlet UIButton *randomButton;

@property (nonatomic, strong, getter=getModel, setter=setModel:) Themes *model;
@property (nonatomic, assign, getter=getDelegate, setter=setDelegate:) id<ThemesViewControllerDelegate> delegate;
@end
