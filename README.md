# photo-Demo
Photo Editor Demo for GPUImageView



- (IBAction)pangesture:(UIPanGestureRecognizer *)gesture {
       if (gesture.state == UIGestureRecognizerStateEnded){
         NSLog(@"StateEnded");
        
    }
  else  if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint transition = [gesture translationInView:_vw];
        self.twoButton.center = CGPointMake(self.twoButton.center.x + transition.x, self.twoButton.center.y + transition.y);
        CGPoint touchPoint = [gesture locationInView:_vw];
        //Same for the other button
        if (CGRectContainsPoint(self.firstButton.frame, touchPoint)) {
            self.twoButton.alpha = 0.2;
            NSLog(@"onebutton touched");
            [self popUpZoomIn];
            [gesture setTranslation:CGPointZero inView:_vw];
        }
        else {
            self.firstButton.alpha = 1;
            NSLog(@"onebutton not touched");
            [gesture setTranslation:CGPointZero inView:_vw];
        }
        
    }

}
- (void)popZoomOut{
    [UIView animateWithDuration:0.55
                     animations:^{
                         _twoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                     } completion:^(BOOL finished) {
                         _twoButton.hidden = TRUE;
                     }];
}
- (void)popUpZoomIn{
    _twoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.55
                     animations:^{
                         _twoButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 3.0, 3.0);
                     } completion:^(BOOL finished) {
                         [self popZoomOut];
                     }];
}

