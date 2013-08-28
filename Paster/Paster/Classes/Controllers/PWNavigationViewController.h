//
//  PWNavigationViewController.h
//  Paster
//
//  Created by mac on 13-6-25.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PWNavigationViewController : UIViewController{
    AVAudioPlayer * audioPlayer;
    AVAudioPlayer * jumpPlayer;
}

@property(retain,nonatomic)AVAudioPlayer * audioPlayer;
@property(retain,nonatomic)AVAudioPlayer * jumpPlayer;

-(IBAction)pressAboutBtn:(id)sender;
-(IBAction)pressThemeBtn:(id)sender;
@end
