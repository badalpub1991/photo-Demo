//
//  FrameEditViewController.m
//  PhotoFrames
//
//  Created by Badal-PUB on 02/04/16.
//  Copyright © 2016 Badal-PUB. All rights reserved.
//

#import "FrameEditViewController.h"

#define MINIMUM_SCALE 0.5
#define MAXIMUM_SCALE 0.6

@interface FrameEditViewController ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *aryTitle;
    int selectedindex;
    NSMutableArray *aryEffect;
    

    
}

@property CGPoint translation;
@end

@implementation FrameEditViewController

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft; // or Right of course
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
-(BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _vwSlider.hidden=YES;
    
    
    [self.collectionImageEffect registerNib:[UINib nibWithNibName:@"ImageEffectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageEffectCollectionViewCell"];
    
    

//    
    
    
   aryEffect=[[NSMutableArray alloc]initWithObjects:@"Original",@"Emboss",@"Posterize",@"voronoiconsumer",@"Vignette",@"Perlinoise",@"CGAcolorspace",@"SphereFerrancign",@"PolkaDot",@"KuvaharRediuse3",@"JFA",@"Kuwahara",@"Mosaic",@"Pixalet",@"PolarPixellate",@"BulgeDistortion",@"PinchDistortion",@"Swirl",@"Stretchdistorian",@"ThreshioldSketch",@"GlassPhase",@"Holftone",@"Srosshatch",@"sketch", nil];
    aryTitle=[[NSMutableArray alloc]initWithObjects:@"Camera",@"Gallery", nil];
    
     // [_collectionImageEffect registerNib:[UINib nibWithNibName:@"ImageEffectCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageEffectCollectionViewCell"];
    //_imgviewFrame.userInteractionEnabled = YES;
    
    [_imgviewFrame sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"imageurl"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
        _imgviewFrame.image = image;
            }];
    
    
   
    
    
[self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark --> Button Methods

- (IBAction)btnSelectfromGalleryorCamera:(UIButton *)sender {
    
    if (sender.tag==1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select category" message:@"" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Ok", nil];
        //Declare pickerview
        UIPickerView * pickerView = [[UIPickerView alloc] init];
        [pickerView setDataSource: self];
        [pickerView setDelegate: self];
        pickerView.tag=1; //If Required
        [pickerView setFrame: CGRectMake(alert.frame.origin.x, alert.frame.origin.y, alert.frame.size.width, alert.frame.size.height)];
        pickerView.showsSelectionIndicator = YES;
        [pickerView selectRow:2 inComponent:0 animated:YES];
        [alert addSubview:pickerView];
        [alert setValue:pickerView forKey:@"accessoryView"];
        [alert show];
        
    }
    else if (sender.tag==2)
    {
        _vwControlview.hidden=YES;
    }
    else if (sender.tag==3)
    {
        _vwControlview.hidden=YES;
        _collectionImageEffect.hidden=YES;
        _vwSlider.hidden=NO;
        [self.view bringSubviewToFront:_vwSlider];
    }
    
}
#pragma mark Filter adjustments

- (IBAction)updateFilterFromSlider:(id)sender
{
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
//            self.filterSettingsSlider.hidden = NO;
//            
//            [self.filterSettingsSlider setValue:0.05];
//            [self.filterSettingsSlider setMinimumValue:0.0];
//            [self.filterSettingsSlider setMaximumValue:0.3];
//            
            filter = [[GPUImagePixellateFilter alloc] init];

    sourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Filterimageset"] smoothlyScaleOutput:YES];
    [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];


    [sourcePicture addTarget:filter];
    [filter addTarget:self.vwGPUImagview];
    [sourcePicture processImage];


}

#pragma mark ---> Gesture Methods pan // pinch // Rotate
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    // Comment for panning
    // Uncomment for tickling
    //return;
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.imgviewFrame.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.imgviewFrame.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
        
    }
    
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




#pragma mark --> UIPickeriew Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1; //Component in pickerview
}
// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
        return [aryTitle count];
   
}
// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [aryTitle objectAtIndex:row];
}
// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    picker = [[UIImagePickerController alloc] init];
    picker.delegate=self;

    if (row==0) {
        
        selectedindex=0;
               //[self presentedViewController:picker animated:YES];

       // _txtCategory.text=[categoryArray objectAtIndex:row];
        
    }
    else
    {
        selectedindex=1;

    }
}
#pragma mark --> UIAlertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        

    }else if (buttonIndex==1)
    {
        if (selectedindex==0) {
            picker.delegate=self;
            picker.editing=YES;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                
            {
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }
            else
            {
                NSLog(@"No camera Available");
            }
            
        }
        else
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}
#pragma mark --> UIImagepicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    filter=[[GPUImageGrayscaleFilter alloc]init];


    sourcePicture = [[GPUImagePicture alloc] initWithImage:chosenImage smoothlyScaleOutput:YES];
    [sourcePicture addTarget:filter];
    [filter addTarget:self.vwGPUImagview];
    [sourcePicture processImage];

   
    //Working Code
//    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
//    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    
//    filter=[[GPUImageGrayscaleFilter alloc]init];
//    
//    
//    sourcePicture = [[GPUImagePicture alloc] initWithImage:chosenImage smoothlyScaleOutput:YES];
//    [sourcePicture addTarget:filter];
//    [filter addTarget:self.vwGPUImagview];
//    [sourcePicture processImage];
    
      [self dismissViewControllerAnimated:YES completion:^(){
        //if (isFiltersTableViewVisible == NO) {
        // [self toggleFiltersButtonPressed:nil];
        //  }
    }];
    
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark --> UICollectionview Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 36;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *identifier = @"ImageEffectCollectionViewCell";
//    ImageEffectCollectionViewCell *cell = (ImageEffectCollectionViewCell *)[_collectionImageEffect dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    
//    if (cell == nil)
//    {
//        NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"ImageEffectCollectionViewCell" owner:self options:nil];
//        cell = [xib objectAtIndex:0];
//    }
    
    
    ImageEffectCollectionViewCell *cell = [self.collectionImageEffect dequeueReusableCellWithReuseIdentifier:@"ImageEffectCollectionViewCell" forIndexPath:indexPath];
    
    
    
    
   


    
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

    //sourcePicture=;
    sourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Filterimageset"] smoothlyScaleOutput:YES];

    
    
    if (indexPath.row==0) {
        NSLog(@"Normal Filter");
        filter = [[GPUImageSepiaFilter alloc] init];

    }
    else if (indexPath.row==1)
    {
        filter = [[GPUImageSepiaFilter alloc] init];
        
    }
    else if (indexPath.row==2)
    {
        filter = [[GPUImagePixellateFilter alloc] init];
        
    }
    else if (indexPath.row==3)
    {
        filter = [[GPUImagePixellatePositionFilter alloc] init];
        
    }
    else if (indexPath.row==4)
    {
        filter = [[GPUImagePolkaDotFilter alloc] init];
        
    }
    else if (indexPath.row==5)
    {
        filter = [[GPUImageHalftoneFilter alloc] init];
        
    }
    else if (indexPath.row==6)
    {
        filter = [[GPUImageCrosshatchFilter alloc] init];
        
    }
    else if (indexPath.row==7)
    {
        filter = [[GPUImageColorInvertFilter alloc] init];
        
    }
    else if (indexPath.row==8)
    {
        filter = [[GPUImageGrayscaleFilter alloc] init];
        
    }
    else if (indexPath.row==9)
    {
        filter = [[GPUImageMonochromeFilter alloc] init];
        [(GPUImageMonochromeFilter *)filter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.f}];
    }
    else if (indexPath.row==10)
    {
        filter = [[GPUImageFalseColorFilter alloc] init];
        
    }
    else if (indexPath.row==11)
    {
        filter = [[GPUImageSoftEleganceFilter alloc] init];
        
    }
    else if (indexPath.row==12)
    {
        filter = [[GPUImageMissEtikateFilter alloc] init];
        
    }
    else if (indexPath.row==13)
    {
        filter = [[GPUImageAmatorkaFilter alloc] init];
        
    }
    else if (indexPath.row==14)
    {
        filter = [[GPUImageSaturationFilter alloc] init];
        
    }
    else if (indexPath.row==15)
    {
        filter = [[GPUImageContrastFilter alloc] init];
        
    }
    else if (indexPath.row==16)
    {
        filter = [[GPUImageBrightnessFilter alloc] init];
        
    }
    else if (indexPath.row==17)
    {
        filter = [[GPUImageLevelsFilter alloc] init];
        
    }
    else if (indexPath.row==18)
    {
        filter = [[GPUImageRGBFilter alloc] init];
        
    }
    else if (indexPath.row==19)
    {
        filter = [[GPUImageHueFilter alloc] init];
        
    }
    else if (indexPath.row==20)
    {
        filter = [[GPUImageWhiteBalanceFilter alloc] init];
        
    }
    else if (indexPath.row==21)
    {
        filter = [[GPUImageExposureFilter alloc] init];
        
    }
    else if (indexPath.row==22)
    {
        filter = [[GPUImageSharpenFilter alloc] init];
        
    }
    else if (indexPath.row==23)
    {
        filter = [[GPUImageUnsharpMaskFilter alloc] init];
        
    }
    else if (indexPath.row==24)
    {
        filter = [[GPUImageGammaFilter alloc] init];
        
    }
    else if (indexPath.row==25)
    {
        filter = [[GPUImageToneCurveFilter alloc] init];
        [(GPUImageToneCurveFilter *)filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
    }
    else if (indexPath.row==26)
    {
        filter = [[GPUImageHighlightShadowFilter alloc] init];

    }
    else if (indexPath.row==27)
    {
        filter = [[GPUImageHazeFilter alloc] init];

    }
    else if (indexPath.row==28)
    {
        filter = [[GPUImageAverageColor alloc] init];

    }
    else if (indexPath.row==29)
    {
        filter = [[GPUImageLuminosity alloc] init];

    }
    else if (indexPath.row==30)
    {
        filter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRGB];

    }
    else if (indexPath.row==31)
    {
        filter = [[GPUImageLuminanceThresholdFilter alloc] init];

    }
    else if (indexPath.row==32)
    {
        filter = [[GPUImageAdaptiveThresholdFilter alloc] init];

    }
    else if (indexPath.row==33)
    {
        filter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];

    }
    else if (indexPath.row==34)
    {
        filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0, 0.25)];
    }
    
    [sourcePicture addTarget:filter];
    [filter addTarget:cell.vwCellGPUImg];
    [sourcePicture processImage];
    
    
    cell.lblImageEffect.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    
//    switch ([indexPath row]) {
//        case 0: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 1: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileAmaro" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 2: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileRise" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 3: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHudson" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 4: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileXpro2" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 5: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSierra" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 6: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLomoFi" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 7: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileEarlybird" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 8: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSutro" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 9: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileToaster" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 10: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileBrannan" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 11: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileInkwell" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 12: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileWalden" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 13: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHefe" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 14: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileValencia" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 15: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNashville" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 16: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTile1977" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//        case 17: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLordKelvin" ofType:@"png"]] forState:UIControlStateNormal];
//            break;
//        }
//            
//        default: {
//            [cell.btnImageEffectCell setBackgroundImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]] forState:UIControlStateNormal];
//            
//            break;
//        }
//    }


    
//    int i=1;
//    cell.btnImageEffectCell.tag=indexPath.row;
//    UIImage *imgEffect=[UIImage imageNamed:@"Filterimageset"];
//    if (cell.btnImageEffectCell.tag==i) {
//        imgEffect=[EmbossFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[PosterizeFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[VoronoiConsumerFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[PerlinNoiseFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[CGAColorspaceFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[SphereRefractionFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[PolkaDotFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[KuwaharaRadius3Filter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[JFAVoronoiFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[KuwaharaFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[MosaicFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[PixellateFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[PolarPixellateFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[BulgeDistortionFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[PinchDistortionFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[StretchDistortionFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[ThresholdSketchFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[GlassSphereFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[HalftoneFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[CrosshatchFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
//    
//    if (cell.btnImageEffectCell.tag==i+1) {
//        imgEffect=[SketchFilter imageByFilteringImage:[UIImage imageNamed:@"Filterimageset"]];
//    }
   
    
   // [cell.btnImageEffectCell setBackgroundImage::imgEffect forState:UIControlStateNormal];
   // cell.lblImageEffect.text=[aryEffect objectAtIndex:indexPath.row];
    
    
    return cell;
}

#pragma mark ---> Collectionview Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
       [filter removeAllTargets];
    
    if (indexPath.row==0) {
        NSLog(@"Normal Filter");
    }
    else if (indexPath.row==1)
    {
        filter = [[GPUImageSepiaFilter alloc] init];

    }
    else if (indexPath.row==2)
    {
        filter = [[GPUImagePixellateFilter alloc] init];

    }
    else if (indexPath.row==3)
    {
        filter = [[GPUImagePixellatePositionFilter alloc] init];

    }
    else if (indexPath.row==4)
    {
        filter = [[GPUImagePolkaDotFilter alloc] init];

    }
    else if (indexPath.row==5)
    {
        filter = [[GPUImageHalftoneFilter alloc] init];

    }
    else if (indexPath.row==6)
    {
        filter = [[GPUImageCrosshatchFilter alloc] init];

    }
    else if (indexPath.row==7)
    {
        filter = [[GPUImageColorInvertFilter alloc] init];

    }
    else if (indexPath.row==8)
    {
        filter = [[GPUImageGrayscaleFilter alloc] init];

    }
    else if (indexPath.row==9)
    {
        filter = [[GPUImageMonochromeFilter alloc] init];
        [(GPUImageMonochromeFilter *)filter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.f}];
    }
    else if (indexPath.row==10)
    {
        filter = [[GPUImageFalseColorFilter alloc] init];

    }
    else if (indexPath.row==11)
    {
        filter = [[GPUImageSoftEleganceFilter alloc] init];

    }
    else if (indexPath.row==12)
    {
        filter = [[GPUImageMissEtikateFilter alloc] init];

    }
    else if (indexPath.row==13)
    {
        filter = [[GPUImageAmatorkaFilter alloc] init];

    }
    else if (indexPath.row==14)
    {
        filter = [[GPUImageSaturationFilter alloc] init];
       [(GPUImageSaturationFilter *)filter setSaturation:2.0];
    }
    else if (indexPath.row==15)
    {
        filter = [[GPUImageContrastFilter alloc] init];
        [(GPUImageContrastFilter *)filter setContrast:1.5];


    }
    else if (indexPath.row==16)
    {
        filter = [[GPUImageBrightnessFilter alloc] init];
        [(GPUImageBrightnessFilter *)filter setBrightness:0.6];


    }
    else if (indexPath.row==17)
    {
        filter = [[GPUImageLevelsFilter alloc] init];

    }
    else if (indexPath.row==18)
    {
        filter = [[GPUImageRGBFilter alloc] init];

    }
    else if (indexPath.row==19)
    {
        filter = [[GPUImageHueFilter alloc] init];

    }
    else if (indexPath.row==20)
    {
        filter = [[GPUImageWhiteBalanceFilter alloc] init];

    }
    else if (indexPath.row==21)
    {
        filter = [[GPUImageExposureFilter alloc] init];

    }
    else if (indexPath.row==22)
    {
        filter = [[GPUImageSharpenFilter alloc] init];

    }
    else if (indexPath.row==23)
    {
        filter = [[GPUImageUnsharpMaskFilter alloc] init];

    }
    else if (indexPath.row==24)
    {
        filter = [[GPUImageGammaFilter alloc] init];

    }
    else if (indexPath.row==25)
    {
        filter = [[GPUImageToneCurveFilter alloc] init];
        [(GPUImageToneCurveFilter *)filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
    }
    else if (indexPath.row==26)
    {
        filter = [[GPUImageHighlightShadowFilter alloc] init];
        
    }
    else if (indexPath.row==27)
    {
        filter = [[GPUImageHazeFilter alloc] init];
        
    }
    else if (indexPath.row==28)
    {
        filter = [[GPUImageAverageColor alloc] init];
        
    }
    else if (indexPath.row==29)
    {
        filter = [[GPUImageLuminosity alloc] init];
        
    }
    else if (indexPath.row==30)
    {
        filter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRGB];
        
    }
    else if (indexPath.row==31)
    {
        filter = [[GPUImageLuminanceThresholdFilter alloc] init];
        
    }
    else if (indexPath.row==32)
    {
        filter = [[GPUImageAdaptiveThresholdFilter alloc] init];
        
    }
    else if (indexPath.row==33)
    {
        filter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
        
    }
    else if (indexPath.row==34)
    {
        filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0, 0.25)];
    }

    
    [sourcePicture addTarget:filter];
    [filter addTarget:self.vwGPUImagview];
    [sourcePicture processImage];


}



//#pragma mark ---> Filter button
//- (IBAction)ApplyFilterEmboss:(UIButton *)sender {
//    
//    GPUImageEmbossFilter *selectedFilter =
//    [[GPUImageEmbossFilter alloc] init];
////UIImage *filteredImage = [selectedFilter imageByFilteringImage:[[_imgviewFrame.image ]];
//                              
//   // [_imgFilter setImage:filteredImage];
//}


- (IBAction)CaptureScreenshot:(UIButton *)sender {
}
@end
