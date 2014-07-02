//
//  IKMainViewController.m
//  IKCaptureExample
//
//  Created by Andres on 7/2/14.
//  Copyright (c) 2014 Inaka. All rights reserved.
//

#import "IKMainViewController.h"
#import "IKCapture.h"
#import "IKCameraOverlay.h"

@interface IKMainViewController () <IKCameraOverlayDelegate>
@property IKCapture *captureView;
@property (strong, nonatomic) IBOutlet UILabel *noCameraLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation IKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([IKCapture isCameraAvailable]) {
        IKCameraOverlay *cameraOverlay = [[IKCameraOverlay alloc] initWithFrame:self.view.frame];
        cameraOverlay.delegate = self;
        
        
        self.captureView = [[IKCapture alloc] initWithFrame:self.view.frame];
        self.captureView.overlay = cameraOverlay;
        [self.captureView startRunning];
        
        [self.view addSubview:self.captureView];
    }else{
        self.noCameraLabel.hidden = NO;
    }
}

#pragma mark Camera Overlay Delegates

-(void) takePicture{
    [self.captureView takeSnapshotWithCompletionHandler:^(UIImage *image) {
        [self.captureView removeFromSuperview];
        [self.captureView stopRunning];
        
        self.imageView.image = image;
        self.imageView.hidden = NO;
    }];
}

-(void) changeCamera{
    [self.captureView changeCamera];
}


@end
