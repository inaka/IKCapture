//
//  IKCapture.m
//  Pixter
//
//  Created by Andres on 6/26/14.
//  Copyright (c) 2014 Inaka. All rights reserved.
//

#import "IKCapture.h"
#import <AVFoundation/AVFoundation.h>

@interface IKCapture(){
}
@property (strong, nonatomic) AVCaptureStillImageOutput *outputStillImage;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic, readonly) NSInteger currentCameraPosition;

@end


@implementation IKCapture

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _flashON = NO;
        
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        
        self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        self.captureVideoPreviewLayer.frame = self.bounds;
        self.captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [self.layer addSublayer:self.captureVideoPreviewLayer];
        
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input) {
            NSLog(@"ERROR IKCapture:: trying to open camera: %@", error);
        }
        
        if([self.session canAddInput:input]){
            [self.session addInput:input];
        }else{
            NSLog(@"ERROR IKCapture: can't add input");
        }
    
        self.outputStillImage = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
        [self.outputStillImage setOutputSettings:outputSettings];
        
        if ([self.session canAddOutput:self.outputStillImage]) {
            [self.session addOutput:self.outputStillImage];
        }else{
            NSLog(@"ERROR IKCapture: can't add output");
        }
    }
    return self;
}

-(void)toggleFlash{
    AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
    AVCaptureDevice *currentCaptureDevice = ((AVCaptureDeviceInput*)currentCameraInput).device;
    
    if ([currentCaptureDevice hasFlash]){
        [currentCaptureDevice lockForConfiguration:nil];
        
        if (_flashON) {
            [currentCaptureDevice setFlashMode:AVCaptureFlashModeOff];
            _flashON = NO;
        }else{
            [currentCaptureDevice setFlashMode:AVCaptureFlashModeOn];
            _flashON = YES;
        }

        [currentCaptureDevice unlockForConfiguration];
    }
}

-(void)changeCamera{
    AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
    [self.session beginConfiguration];

    AVCaptureDevice *newCamera = nil;
    if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack){
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }else{
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
    }
    
    [self.session removeInput:currentCameraInput];
    
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
    [self.session addInput:newVideoInput];
    [self.session commitConfiguration];
}

- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

-(BOOL)currentCameraHasFlash{
    AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
    AVCaptureDevice *currentCaptureDevice = ((AVCaptureDeviceInput*)currentCameraInput).device;
    
    return [currentCaptureDevice hasFlash];
}

-(void)setOverlay:(UIView*)overlay{
    _overlay = overlay;
    [self addSubview:overlay];
}

-(void)startRunning{
    [self.session startRunning];
}

-(void)stopRunning{
    [self.session stopRunning];
}

+(BOOL)isCameraAvailable{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return (devices.count >=1);
}

-(void)takeSnapshotWithCompletionHandler:(void (^)(UIImage *image))completion{
    AVCaptureInput* currentCameraInput = [self.session.inputs objectAtIndex:0];
    
    [self.outputStillImage captureStillImageAsynchronouslyFromConnection:	[self.outputStillImage connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];

        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionFront){
            image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];
        }

        if (completion) {
            completion(image);
        }
    }];
}

@end
