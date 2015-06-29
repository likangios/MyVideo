//
//  ViewController.m
//  MyVideo
//
//  Created by 哈哈哈 on 15/6/27.
//  Copyright (c) 2015年 likang.com. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    BOOL _isVedio;
    BOOL _isCamera;
}
@property (nonatomic,strong) UIImagePickerController *imagePicker;

@property (nonatomic,strong) UIImageView *imageview;

@property (nonatomic,strong) AVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageview=  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _imageview.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_imageview];

    _isVedio = YES;
    UIButton *Camera = [UIButton buttonWithType:UIButtonTypeCustom];
    [Camera setTitle:@"Camera" forState:UIControlStateNormal];
    Camera.center  =CGPointMake(self.view.center.x, self.view.center.y);
    [Camera setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    Camera.backgroundColor = [UIColor blackColor];
    Camera.bounds = CGRectMake(0, 0, 100, 50);
    [Camera addTarget:self action:@selector(TakeVieo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Camera];
    
    UIButton *Library = [UIButton buttonWithType:UIButtonTypeCustom];
    [Library setTitle:@"Library" forState:UIControlStateNormal];
    Library.tag = 10001;
    Library.center  =CGPointMake(self.view.center.x, self.view.center.y+100);
    [Library setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    Library.backgroundColor = [UIColor blackColor];
    Library.bounds = CGRectMake(0, 0, 100, 50);
    [Library addTarget:self action:@selector(TakeVieo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Library];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)TakeVieo:(UIButton *)but{
    _isCamera = (but.tag == 10001)?NO:YES;
    
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        
        if (_isCamera) {
            
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

        }else{
            
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        if (_isVedio) {
            
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.mediaTypes=@[@"public.movie"];
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
            _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;

        }
        
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"info %@",info);
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    NSString *path = [url path];
    
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSURL *url=[NSURL fileURLWithPath:videoPath];
    _player=[AVPlayer playerWithURL:url];
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame=self.imageview.frame;
    [self.imageview.layer addSublayer:playerLayer];
    [_player play];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
