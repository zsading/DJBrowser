# DJBrowser
A simple PictureView

#Screenshots

![](https://github.com/zsading/DJBrowser/blob/master/DJBrowser/DJBrowser/Source/DJBrowser.gif)


#Basic usage
```
DJImageEntity *di_image1 = [[DJImageEntity alloc] initWithImageURL:url1];
DJImageEntity *di_image2 = [[DJImageEntity alloc] initWithImageURL:url2];
DJImageEntity *di_image3 = [[DJImageEntity alloc] initWithImageURL:url3];
DJImageEntity *di_image4 = [[DJImageEntity alloc] initWithImageURL:url4];
    
DJImageSourceEntity *imageSource = [[DJImageSourceEntity alloc] initWithImages:@[di_image1,di_image2,di_image3,di_image4]];
DJBrowserCtrl dj_Browser = [[DJBrowserCtrl alloc] initWithImageSource:self.myImageSource];
dj_Browser.deleteCallBack = ^(NSInteger index){
        
	//Delete callback        
};
```
