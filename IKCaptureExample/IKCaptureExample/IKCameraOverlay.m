//
//  IKCameraOverlay.m
//  IKCaptureExample
//
//  Created by Andres on 7/2/14.
//  Copyright (c) 2014 Inaka. All rights reserved.
//

#import "IKCameraOverlay.h"

@interface IKCameraOverlay(){
    BOOL flashStatus;
}
@property (nonatomic, strong) UIButton *takePictureButton;
@property (nonatomic, strong) UIButton *changeCameraButton;
@end

@implementation IKCameraOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
    
        self.takePictureButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            100,
                                                                            30)];

        self.takePictureButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 40);
        [self.takePictureButton setTitle:@"Take Picture" forState:UIControlStateNormal];
        
        [self.takePictureButton addTarget:self
                                   action:@selector(takePicture)
                         forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.takePictureButton];
        
        self.changeCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 170,
                                                                             20,
                                                                             180,
                                                                             20)];
        
        [self.changeCameraButton addTarget:self
                                    action:@selector(changeCamera)
                          forControlEvents:UIControlEventTouchUpInside];
        [self.changeCameraButton setTitle:@"Change Camera" forState:UIControlStateNormal];
        
        [self addSubview:self.changeCameraButton];
    }
    return self;
}

-(void)takePicture{
    if([self.delegate respondsToSelector:@selector(takePicture)]){
        [self.delegate takePicture];
    }
}

-(void)changeCamera{
    if([self.delegate respondsToSelector:@selector(changeCamera)]){
        [self.delegate changeCamera];
    }
}

@end
