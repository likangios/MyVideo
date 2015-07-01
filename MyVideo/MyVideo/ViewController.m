//
//  ViewController.m
//  MyVideo
//
//  Created by 哈哈哈 on 15/6/27.
//  Copyright (c) 2015年 likang.com. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SAVideoRangeSlider.h"

#import "KCView.h"


@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SAVideoRangeSliderDelegate>

{
    BOOL _isVedio;
    BOOL _isCamera;
    
    UIButton *Camera;
    
    UIButton *Library;
    
    UITextField *_netAddress;
    
    UIButton *_play;
    
    SAVideoRangeSlider *_videoSlider;
    
    
    UIImageView *_showImageView;
    
    float current;
    
    float totalBuffer;
    
    float total;
}
@property (nonatomic,strong) UIImagePickerController *imagePicker;


@property (nonatomic,strong) UIImageView *imageview;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong)UIProgressView *progress;
@end

@implementation ViewController


- (void)initSliderViewWithURL:(NSURL *)url{
    
    if (_videoSlider) {
        [_videoSlider removeFromSuperview];
        _videoSlider.delegate = nil;
        _videoSlider = nil;
    }
    
    _videoSlider = [[SAVideoRangeSlider alloc]initWithFrame:CGRectMake(10, 165, self.view.frame.size.width, 70) videoUrl:url];
    _videoSlider.delegate = self;
    [self.view addSubview:_videoSlider];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KCView *view = [[KCView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    return;
    
    _isVedio = YES;
    
    UISegmentedControl *segmen = [[UISegmentedControl alloc]init];
    segmen.center = CGPointMake(self.view.frame.size.width/2.0, 250);
    segmen.bounds = CGRectMake(0, 0, 200, 40);
    [segmen insertSegmentWithTitle:@"video" atIndex:0 animated:YES];
    [segmen insertSegmentWithTitle:@"image" atIndex:1 animated:YES];
    [segmen insertSegmentWithTitle:@"net" atIndex:2 animated:YES];

    segmen.selectedSegmentIndex = 0;
    [segmen addTarget:self action:@selector(segmentedChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmen];
    
    _showImageView = [[UIImageView alloc]init];
    _showImageView.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height-100);
    _showImageView.layer.borderColor = [UIColor redColor].CGColor;
    _showImageView.layer.borderWidth = 2.0;
    [self.view addSubview:_showImageView];
    
    _imageview=  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    _imageview.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:_imageview];
    
    [self setuiUI];

    
    _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_imageview.frame)-30, CGRectGetWidth(_imageview.frame)-40, 20)];
    
    _progress.tintColor = [UIColor blueColor];
    
    [_imageview addSubview:_progress];
    
    _netAddress = [[UITextField alloc]initWithFrame:CGRectMake(40, 280, 300, 40)];
    _netAddress.backgroundColor = [UIColor grayColor];
    _netAddress.text = @"http://7viljd.com1.z0.glb.clouddn.com/150415苔藓微景观制作靳艳艳.mp4";
    _netAddress.hidden = YES;
    [self.view addSubview:_netAddress];
    
    _play = [UIButton buttonWithType:UIButtonTypeCustom];
    [_play setTitle:@"播放网络" forState:UIControlStateNormal];
    _play.center  =CGPointMake(self.view.center.x, self.view.center.y);
    [_play setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _play.backgroundColor = [UIColor blackColor];
    _play.bounds = CGRectMake(0, 0, 100, 50);
    [_play addTarget:self action:@selector(PlayVieo) forControlEvents:UIControlEventTouchUpInside];
    _play.hidden = YES;
    [self.view addSubview:_play];
    


    Camera = [UIButton buttonWithType:UIButtonTypeCustom];
    [Camera setTitle:@"Camera" forState:UIControlStateNormal];
    Camera.center  =CGPointMake(self.view.center.x, CGRectGetMaxY(segmen.frame)+50);
    [Camera setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    Camera.backgroundColor = [UIColor blackColor];
    Camera.bounds = CGRectMake(0, 0, 100, 50);
    [Camera addTarget:self action:@selector(TakeVieo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Camera];
    
    Library = [UIButton buttonWithType:UIButtonTypeCustom];
    [Library setTitle:@"Library" forState:UIControlStateNormal];
    Library.tag = 10001;
    Library.center  =CGPointMake(self.view.center.x, CGRectGetMaxY(Camera.frame)+50);
    [Library setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    Library.backgroundColor = [UIColor blackColor];
    Library.bounds = CGRectMake(0, 0, 100, 50);
    [Library addTarget:self action:@selector(TakeVieo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Library];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)segmentedChange:(UISegmentedControl *)segment{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            _isVedio    = YES;
            Camera.hidden = NO;
            Library.hidden = NO;
            _netAddress.hidden = YES;
            _play.hidden = YES;
        }
            break;
        case 1:{
            Camera.hidden = NO;
            Library.hidden = NO;
            _isVedio    = NO;
            _netAddress.hidden = YES;
            _play.hidden = YES;
        }
            break;
        case 2:{
            Camera.hidden = YES;
            Library.hidden = YES;
            _netAddress.hidden = NO;
            _play.hidden = NO;
        }
            break;
        default:
            break;
    }
}
- (void)TakeVieo:(UIButton *)but{
    _isCamera = (but.tag == 10001)?NO:YES;
    
    if (_imagePicker) {
        if (_isCamera) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        if (_isVedio) {
            _imagePicker.mediaTypes=@[@"public.movie"];

        }else{
            _imagePicker.mediaTypes=@[@"public.image"];

        }
    }
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}
- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        
        _imagePicker = [[UIImagePickerController alloc]init];

        if (_isCamera) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

        }else{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        if (_isVedio) {
            _imagePicker.mediaTypes=@[@"public.movie"];
            
            if (_isCamera) {
                if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                    _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                }
                _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                _imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            }
        }else{
            _imagePicker.mediaTypes=@[@"public.image"];
        }
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"info %@",info);
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    
    
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];

    AVAsset *myAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    
    for ( int i = 0; i<10; i++) {
        
       float _durationSeconds = CMTimeGetSeconds([myAsset duration]);

        CMTime time = CMTimeMakeWithSeconds(_durationSeconds*i/9.0, 100);
        
        CGImageRef ref = [generator copyCGImageAtTime:time actualTime:nil error:nil];
        
        UIImage *img = [UIImage imageWithCGImage:ref];
        
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        
    }
    
    
    NSString *path = [url path];
    
    UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSURL *url=[NSURL fileURLWithPath:videoPath];

    [self initSliderViewWithURL:url];
    
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    
    [self setAvPlayerWithItem:item];

}
- (void)SelectedUpdate:(SAVideoRangeSlider *)target WithNewThumbnail:(UIImage *)image{
    _showImageView.image = image;
    _showImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
}
- (void)PlayVieo{
    
    NSString *urlStr =[_netAddress.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:urlStr];
    
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    
    [self setAvPlayerWithItem:item];
    
}
- (void)setAvPlayerWithItem:(AVPlayerItem *)item{
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    [self.player play];
    
    [self addObserverPlayerItem:item];
    
    [self addProgressObserver];
}
-(void)setuiUI{
    
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame=self.imageview.frame;
    
    [self.imageview.layer addSublayer:playerLayer];
    
}
- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}
- (void)addProgressObserver{

    AVPlayerItem *item = self.player.currentItem;
    
    UIProgressView *progress = self.progress;
    
   [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
       
       
        current = CMTimeGetSeconds(time);
       
       float totalT = CMTimeGetSeconds(item.duration);
       
//       [self stopOrPlay];

       if (current>0.0) {
           
           [progress setProgress:current/totalT animated:YES];
       }
       
    }];

}
- (void)stopOrPlay{
   
    if ((current<= totalBuffer-5)&&(totalBuffer!= total)) {
        
        [self.player pause];
        
    }else{
        
        [self.player play];
    }
}
- (void)addObserverPlayerItem:(AVPlayerItem *)item{
    
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    AVPlayerItem *playerItem = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus staus = [[change objectForKey:@"new"]intValue];
        if (staus == AVPlayerStatusReadyToPlay) {
            
            total = CMTimeGetSeconds(playerItem.duration);
            
            NSLog(@"正在播放。。。。视频总长度：%.2fs",CMTimeGetSeconds(playerItem.duration));
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *array = playerItem.loadedTimeRanges;
        
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        
        float startSecond = CMTimeGetSeconds(timeRange.start);
        float durationSecond  =CMTimeGetSeconds(timeRange.duration);
        
         totalBuffer = startSecond + durationSecond;
        
//        [self stopOrPlay];
        
        NSLog(@"共缓冲：%.2fs",totalBuffer);
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
