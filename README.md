# DJBrowser
A simple image browser


![](https://github.com/zsading/DJBrowser/blob/master/DJBrowser/DJBrowser/Source/DJBrowser.gif)


#How to use
```
DJBrowserCtrl browCtrl = [[DJBrowserCtrl alloc] init];
browCtrl.imageArray = self.YourImageUrlArray;
[self presentViewController:self.browCtrl animated:YES completion:nil];
```

Attention！
Don't put UIimage Object to YourImageUrlArray directly!

#Delete block
```
browCtrl.deleteCallBack = ^(NSInteger index){
      //Code  
    };
```
