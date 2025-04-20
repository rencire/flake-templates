# WIP

## Support Matrix
| host os | host architecture | target platform | target platform version | target architecture |  Status        | Notes 
|---------|-------------------|-----------------|-------------------------|---------------------|----------------------------------------------------------------------------|
| darwin  | arm64-darwin      | android         | 34                      | arm64-v8a           | Able to launch | able to run the "flutter create" app on emulator.         |
| darwin  | arm64-darwin      | macos           | 15.4                    | arm64-darwin        | Able to launch | able to run the "flutter create" app on a desktop window. |

### Notes:
- Could not get Android 35 to work, some issue with AGP version, and maybe Gradle as well?
  - To be able to load app on android emulator, need to explicitly change `compleSdk` and `targetSdk` to `34` in <flutter_app>/android/app/build.gradle`.


# TODO
- [] Figure out why android build is failing with flutter setup on macos.
  - Seeing gradle fail for the assembleDebug stage?

- [] Refactor flutter config to own file
- [] Support flutter development on macos for:
  - [] android
  - [] ios
  - [] macos
- [] Support flutter development with nixos for:
  - [] android
  - [] linux
- [] Add instructions on this README 

# Notes

## Ios/macos
### Xcode
Unfortunately, Xcode can't be packaged w/ nix (Not sure of reasoning, but manual states
some licensing issues).

We could manually copy the Xcode.App to our nix store.  However, I decided to go
the route recommended in nixpkgs manual, which is to symlink to an Xcode installation
on the machine.

So in short, we'll:
- Manage xcode versions with `xcodes` program.
- Use `xcodeenv` from `nixpkgs` to symlink to our xcode version 

1) Install the version of xcode you need. Recommend to use `xcodes` tool to install.
```
xcodes install <version>
```
The program will then prompt you to enter apple user id and password to authenticate
and download Xcode.

2) reload the nix configuration.


### Old installation approach 
After loading shell for first time, if you don't have xcode intalled, you'll need
to follow instructions onscreen to download and add xcode to te nix store

Instructions for reference:
> Unfortunately, we cannot download Xcode.app automatically.
> Please go to https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_16.2/Xcode_16.2.xip
> to download it yourself, and add it to the Nix store by running the following commands.
> Note: download (~ 5GB), extraction and storing of Xcode will take a while
>
> open -W Xcode_16.2.xip
> rm -rf Xcode_16.2.xip
>
> nix-store --add-fixed --recursive sha256 Xcode.app
> rm -rf Xcode.app


#### Command line tools
I'm actually not sure how to specify this in nix.

I found I didn't need to specify this, since
I already had it on my machine, which probably came from a previous time I
installed xcode command line tools.

#### Simulators
- I think this needs to be managed manually via xcode tool.
- TODO: add some simulators


### Android

#### Simulators
Installing a virtual device w/ emulator:
```
avdmanager create avd --force --name phone --package 'system-images;android-32;google_apis;x86_64'
emulator -avd phone -skin 720x1280 --gpu host
````



# Issues
- Flutter 3.29 seems to have some issues building, seeing similar output error with gradle assembleDebug not working:
  - https://github.com/NixOS/nixpkgs/issues/395096
  - Attempt workaround by downgrading to 3.27
    - Didn't fix issue, so tried including NDK.
      - Still didn't fix issue
        - Finally resolved issue on 3.27.  Had to force android platform version to 34, by default flutter was providing 35.
          - i.e. set compileSdkVersion and targetSdk to 34. (Technically was able to build fine without targetSdk, but
            should have them at same version for consistency)
          Q: where doe sthis platform level come from?





# Resources
## Xcode
- https://discourse.nixos.org/t/nix-darwin-override-overlay-xcode-how-to-get-a-correct-working-dev-build-environment/46230/8
- https://nixos.org/manual/nixpkgs/stable/#deploying-a-proxy-component-wrapper-exposing-xcode


## Example configs
- https://manuelplavsic.ch/articles/flutter-environment-with-nix/#51-hardware-decoding
  - example config w/ rust setup also.
  - https://github.com/patmuk/flutter-UI_rust-BE-example/blob/main/flake.nix
- https://github.com/hatch01/onyx/blob/d6be71cb91fdafd7122fb75806e9bf0a3f270b75/flake.nix
  - This person had an issue with flutter 3.29

## devenv
- https://devenv.sh/integrations/android/

## Android
- https://github.com/tadfisher/android-nixpkgs
