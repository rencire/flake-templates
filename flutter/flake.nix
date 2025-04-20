{
  description = "Flutter development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flakelight.url = "github:accelbread/flakelight";

  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. {
      inherit inputs;
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      nixpkgs.config = {
        android_sdk.accept_license = true;
        allowUnfree = true;
      };
      devShell =
        pkgs:
        let
          androidComposition = pkgs.androidenv.composeAndroidPackages {
            platformToolsVersion = "34.0.4";
            buildToolsVersions = [
              "33.0.1"
              "33.0.2"
              "34.0.0"
            ];
            platformVersions = [
              "33"
              "34"
            ];
            abiVersions = [
              "armeabi-v7a"
              "arm64-v8a"
            ]; # emulator related: on an ARM machine, replace "x86_64" with
            # either "armeabi-v7a" or "arm64-v8a", depending on the architecture of your workstation.
            includeNDK = false;
            includeSystemImages = true; # emulator related: system images are needed for the emulator.
            systemImageTypes = [
              "google_apis"
              "google_apis_playstore"
            ];
            includeEmulator = true; # emulator related: if it should be enabled or not
            useGoogleAPIs = true;
            # googleTVAddOns.enabler = true;
            extraLicenses = [
              "android-googletv-license"
              "android-sdk-arm-dbt-license"
              "android-sdk-preview-license"
              "google-gdk-license"
              "intel-android-extra-license"
              "intel-android-sysimage-license"
              "mips-android-sysimage-license"
            ];
          };
          androidSdk = androidComposition.androidsdk;
          xcodeenv = import (inputs.nixpkgs + "/pkgs/development/mobile/xcodeenv") {
            inherit (pkgs) callPackage;
          };
          ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
        in
        {
          packages = with pkgs; [
            flutter327
            androidSdk
            # qemu_kvm # Not sure if we need this now?
            gradle
            jdk17
            # For macos/ios
            (xcodeenv.composeXcodeWrapper { versions = [ "16.3" ]; })
            cocoapods
            google-chrome
          ];

          # Environment variables
          env = with pkgs; {
            ANDROID_HOME = ANDROID_HOME;
            ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
            JAVA_HOME = "${jdk17.home}";
            FLUTTER_ROOT = "${flutter327}";
            DART_ROOT = "${flutter327}/bin/cache/dart-sdk";
            # TODO make this use same version referenced earlier
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/33.0.1/aapt2";
            # Can't use chromium unfortunately on darwin
            CHROME_EXECUTABLE = lib.getExe pkgs.google-chrome;
            # emulator related: vulkan-loader and libGL shared libs are necessary for hardware decoding
            LD_LIBRARY_PATH = "${lib.makeLibraryPath [
              vulkan-loader
              libGL
            ]}";

          };

          shellHook = ''
            export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
            # export ANDROID_AVD_HOME = $PWD/.android/avd;

            # Need to unset below variables so that they aren't bound to outdated SDKs.
            # Found I needed to do this in order to properly read the system xcode app.
            unset DEVELOPER_DIR
            unset SDKROOT
          '';
        };
    };
}
