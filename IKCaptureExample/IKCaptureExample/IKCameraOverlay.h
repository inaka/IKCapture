//
//  IKCameraOverlay.h
//  IKCaptureExample
//
//  Created by Andres on 7/2/14.
//  Copyright (c) 2014 Inaka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IKCameraOverlayDelegate <NSObject>
-(void) takePicture;
-(void) changeCamera;
@end

@interface IKCameraOverlay : UIView
@property (strong, nonatomic) id <IKCameraOverlayDelegate> delegate;
@end
