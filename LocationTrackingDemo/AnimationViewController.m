//
//  AnimationViewController.m
//  LocationTrackingDemo
//
//  Created by Doan Van Vu on 9/6/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "AnimationViewController.h"

@interface AnimationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) CGPoint point;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _point = _image.center;
    [_image setUserInteractionEnabled:YES];
    UITapGestureRecognizer* singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [_image addGestureRecognizer:singleTap];
}

- (void)singleTapping:(UIGestureRecognizer *)recognizer {
   
    NSTimeInterval durationUp = 2.5;
    [UIView animateWithDuration:durationUp delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _image.center = self.view.center;
    } completion:nil];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        _image.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished){
        
         [UIView animateWithDuration:2.0 animations:^{
             _image.transform = CGAffineTransformMakeScale(1, 1);
         }];
    }];
    
   
    
//    [UIView animateWithDuration:1.5 delay:durationUp options:UIViewAnimationOptionCurveEaseIn animations:^{
//
//        _image.center = _point;
//    } completion:nil];
    
}


@end
