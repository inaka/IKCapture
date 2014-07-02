IKCapture
=========

Snapchat-Like Image Capture Library

Installation
------------
1. Copy `IKCapture.h` and `IKCapture.m` to your project.
2. Create a new `IKCapture` instance:
~~~
self.captureView = [[IKCapture alloc] initWithFrame:self.view.frame];
~~~

3. Start capture:
~~~
[self.captureView startRunning];
~~~

4. Add `IKCapture` to your view:
~~~
[self.view addSubview:self.captureView];
~~~ 

After finishing this steps you will have a view showing the camera preview. 

Properties
----------
~~~
@property (nonatomic,readonly,getter=isFlashOn) BOOL flashON;
~~~

This property lets you know if the flash is on in the current `AVCaptureDevice`

~~~
@property (nonatomic,strong) UIView *overlay;
~~~

This property lets you add an overlay to the camera view.

Methods
-------
~~~
+(BOOL)isCameraAvailable;
~~~
This lets you know if a camera is available. If you are using the simulator or an old iphone this will return NO.

~~~
-(void)takeSnapshotWithCompletionHandler:(void (^)(UIImage 
*image))completion;
~~~
To snap a picture just call this method. The image will be returned in the completion handler.
~~~
-(void)changeCamera;
~~~
This methods allows you to swap cameras.
~~~
-(void)toggleFlash;
~~~
This methods allows you to turn on/off the camera flash if available.
~~~
-(void)startRunning;
~~~
This method starts the `AVCaptureSession`
~~~
-(void)stopRunning;
~~~
This method stops the `AVCaptureSession`
~~~
-(void)setOverlay:(UIView*)overlay;
~~~
This lets you know if the current camera owns a flash.
~~~
-(BOOL)currentCameraHasFlash;
~~~


