# react-native-local-auth

## Getting started

`$ npm install react-native-local-auth --save`

### Mostly automatic installation

`$ react-native link react-native-local-auth`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-local-auth` and add `LocalAuth.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libLocalAuth.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.reactlibrary.LocalAuthPackage;` to the imports at the top of the file
  - Add `new LocalAuthPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-local-auth'
  	project(':react-native-local-auth').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-local-auth/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-local-auth')
  	```


## Usage
```javascript
import LocalAuth from 'react-native-local-auth';

// TODO: What to do with the module?
LocalAuth;
```
