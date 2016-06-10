//
//  FrameEditViewController.h
//  PhotoFrames
//
//  Created by Badal-PUB on 02/04/16.
//  Copyright © 2016 Badal-PUB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageEffectCollectionViewCell.h"

typedef enum {
    GPUIMAGE_SATURATION,
    GPUIMAGE_CONTRAST,
    GPUIMAGE_BRIGHTNESS,
    GPUIMAGE_LEVELS,
    GPUIMAGE_EXPOSURE,
    GPUIMAGE_RGB,
    GPUIMAGE_HUE,
    GPUIMAGE_WHITEBALANCE,
    GPUIMAGE_MONOCHROME,
    GPUIMAGE_FALSECOLOR,
    GPUIMAGE_SHARPEN,
    GPUIMAGE_UNSHARPMASK,
    GPUIMAGE_TRANSFORM,
    GPUIMAGE_TRANSFORM3D,
    GPUIMAGE_CROP,
    GPUIMAGE_MASK,
    GPUIMAGE_GAMMA,
    GPUIMAGE_TONECURVE,
    GPUIMAGE_HIGHLIGHTSHADOW,
    GPUIMAGE_HAZE,
    GPUIMAGE_SEPIA,
    GPUIMAGE_AMATORKA,
    GPUIMAGE_MISSETIKATE,
    GPUIMAGE_SOFTELEGANCE,
    GPUIMAGE_COLORINVERT,
    GPUIMAGE_GRAYSCALE,
    GPUIMAGE_HISTOGRAM,
    GPUIMAGE_HISTOGRAM_EQUALIZATION,
    GPUIMAGE_AVERAGECOLOR,
    GPUIMAGE_LUMINOSITY,
    GPUIMAGE_THRESHOLD,
    GPUIMAGE_ADAPTIVETHRESHOLD,
    GPUIMAGE_AVERAGELUMINANCETHRESHOLD,
    GPUIMAGE_PIXELLATE,
    GPUIMAGE_POLARPIXELLATE,
    GPUIMAGE_PIXELLATE_POSITION,
    GPUIMAGE_POLKADOT,
    GPUIMAGE_HALFTONE,
    GPUIMAGE_CROSSHATCH,
    GPUIMAGE_SOBELEDGEDETECTION,
    GPUIMAGE_PREWITTEDGEDETECTION,
    GPUIMAGE_CANNYEDGEDETECTION,
    GPUIMAGE_THRESHOLDEDGEDETECTION,
    GPUIMAGE_XYGRADIENT,
    GPUIMAGE_HARRISCORNERDETECTION,
    GPUIMAGE_NOBLECORNERDETECTION,
    GPUIMAGE_SHITOMASIFEATUREDETECTION,
    GPUIMAGE_HOUGHTRANSFORMLINEDETECTOR,
    GPUIMAGE_BUFFER,
    GPUIMAGE_LOWPASS,
    GPUIMAGE_HIGHPASS,
    GPUIMAGE_MOTIONDETECTOR,
    GPUIMAGE_SKETCH,
    GPUIMAGE_THRESHOLDSKETCH,
    GPUIMAGE_TOON,
    GPUIMAGE_SMOOTHTOON,
    GPUIMAGE_TILTSHIFT,
    GPUIMAGE_CGA,
    GPUIMAGE_POSTERIZE,
    GPUIMAGE_CONVOLUTION,
    GPUIMAGE_EMBOSS,
    GPUIMAGE_LAPLACIAN,
    GPUIMAGE_CHROMAKEYNONBLEND,
    GPUIMAGE_KUWAHARA,
    GPUIMAGE_KUWAHARARADIUS3,
    GPUIMAGE_VIGNETTE,
    GPUIMAGE_GAUSSIAN,
    GPUIMAGE_GAUSSIAN_SELECTIVE,
    GPUIMAGE_GAUSSIAN_POSITION,
    GPUIMAGE_BOXBLUR,
    GPUIMAGE_MEDIAN,
    GPUIMAGE_BILATERAL,
    GPUIMAGE_MOTIONBLUR,
    GPUIMAGE_ZOOMBLUR,
    GPUIMAGE_IOSBLUR,
    GPUIMAGE_SWIRL,
    GPUIMAGE_BULGE,
    GPUIMAGE_PINCH,
    GPUIMAGE_SPHEREREFRACTION,
    GPUIMAGE_GLASSSPHERE,
    GPUIMAGE_STRETCH,
    GPUIMAGE_DILATION,
    GPUIMAGE_EROSION,
    GPUIMAGE_OPENING,
    GPUIMAGE_CLOSING,
    GPUIMAGE_PERLINNOISE,
    GPUIMAGE_VORONOI,
    GPUIMAGE_MOSAIC,
    GPUIMAGE_LOCALBINARYPATTERN,
    GPUIMAGE_DISSOLVE,
    GPUIMAGE_CHROMAKEY,
    GPUIMAGE_ADD,
    GPUIMAGE_DIVIDE,
    GPUIMAGE_MULTIPLY,
    GPUIMAGE_OVERLAY,
    GPUIMAGE_LIGHTEN,
    GPUIMAGE_DARKEN,
    GPUIMAGE_COLORBURN,
    GPUIMAGE_COLORDODGE,
    GPUIMAGE_LINEARBURN,
    GPUIMAGE_SCREENBLEND,
    GPUIMAGE_DIFFERENCEBLEND,
    GPUIMAGE_SUBTRACTBLEND,
    GPUIMAGE_EXCLUSIONBLEND,
    GPUIMAGE_HARDLIGHTBLEND,
    GPUIMAGE_SOFTLIGHTBLEND,
    GPUIMAGE_COLORBLEND,
    GPUIMAGE_HUEBLEND,
    GPUIMAGE_SATURATIONBLEND,
    GPUIMAGE_LUMINOSITYBLEND,
    GPUIMAGE_NORMALBLEND,
    GPUIMAGE_POISSONBLEND,
    GPUIMAGE_OPACITY,
    GPUIMAGE_CUSTOM,
    GPUIMAGE_UIELEMENT,
    GPUIMAGE_FILECONFIG,
    GPUIMAGE_FILTERGROUP,
    GPUIMAGE_FACES,
    GPUIMAGE_NUMFILTERS
} GPUImageFilterType;

@interface FrameEditViewController : UIViewController<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GPUImageVideoCameraDelegate>
{
    UIImagePickerController *picker;
    
    GPUImageVideoCamera *videoCamera;
    GPUImageOutput<GPUImageInput> *filter;
    GPUImageFilterType filterType;
    GPUImageUIElement *uiElementInput;
    GPUImageFilterPipeline *pipeline;
    GPUImagePicture *sourcePicture;


}
@property (nonatomic,strong) NSMutableArray *aryFrameload;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewFrame;
#pragma mark --> Main Buttons Methods
@property (strong, nonatomic) IBOutlet UIButton *btnSelectfromGalleryorCamera;

- (IBAction)btnSelectfromGalleryorCamera:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnApplyfilter;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionImageEffect;


- (IBAction)CaptureScreenshot:(UIButton *)sender;



#pragma mark --> Gesture Methods
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer;

#pragma mark --> GPUImageview Properties
@property (strong, nonatomic) IBOutlet GPUImageView *vwGPUImagview;

@property (strong, nonatomic) IBOutlet UIView *vwControlview;

#pragma mark ---> SliderView
- (IBAction)updateFilterFromSlider:(id)sender;
@property(readwrite, unsafe_unretained, nonatomic) IBOutlet UISlider *filterSettingsSlider;
@property (strong, nonatomic) IBOutlet UIView *vwSlider;


@end
