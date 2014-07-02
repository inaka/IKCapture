//
//  IKCapture.h
//  Pixter
//
//  Created by Andres on 6/26/14.
//  Copyright (c) 2014 Inaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKCapture : UIView

@property (nonatomic,readonly,getter=isFlashOn) BOOL flashON;
@property (nonatomic,strong) UIView *overlay;
+(BOOL)isCameraAvailable;
-(void)takeSnapshotWithCompletionHandler:(void (^)(UIImage *image))completion;
-(void)changeCamera;
-(void)toggleFlash;
-(void)startRunning;
-(void)stopRunning;
-(void)setOverlay:(UIView*)overlay;
-(BOOL)currentCameraHasFlash;
@end
