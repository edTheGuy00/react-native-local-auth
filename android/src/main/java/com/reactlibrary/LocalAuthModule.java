package com.reactlibrary;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.os.Build;

import androidx.fragment.app.FragmentActivity;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableArray;

import java.util.concurrent.atomic.AtomicBoolean;

public class LocalAuthModule extends ReactContextBaseJavaModule {

    private final AtomicBoolean authInProgress = new AtomicBoolean(false);

    private final ReactApplicationContext reactContext;

    public LocalAuthModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "LocalAuth";
    }

    @ReactMethod
    public void sampleMethod(String stringArgument, int numberArgument, Callback callback) {

        callback.invoke("Received numberArgument: " + numberArgument + " stringArgument: " + stringArgument);
    }

    @ReactMethod
    public void getAvailableBiometrics(Promise promise) {
        try {
            Activity activity = reactContext.getCurrentActivity();
            if (activity == null || activity.isFinishing()) {
                promise.reject("no_activity", "local_auth plugin requires a foreground activity");
                return;
            }
            WritableArray biometrics = Arguments.createArray();
            PackageManager packageManager = activity.getPackageManager();
            if (Build.VERSION.SDK_INT >= 23) {
                if (packageManager.hasSystemFeature(PackageManager.FEATURE_FINGERPRINT)) {
                    biometrics.pushString("fingerprint");
                }
            }
            if (Build.VERSION.SDK_INT >= 29) {
                if (packageManager.hasSystemFeature(PackageManager.FEATURE_FACE)) {
                    biometrics.pushString("face");
                }
                if (packageManager.hasSystemFeature(PackageManager.FEATURE_IRIS)) {
                    biometrics.pushString("iris");
                }
            }
            promise.resolve(biometrics);
        } catch (Exception e) {
            promise.reject("no_biometrics_available", e.getMessage());
        }
    }

    @ReactMethod
    public void authenticateWithBiometrics(final Promise promise) {
        if (!authInProgress.compareAndSet(false, true)) {
            promise.reject("auth_in_progress", "Authentication in progress");
            return;
        }

        Activity activity = reactContext.getCurrentActivity();
        if (activity == null || activity.isFinishing()) {
            promise.reject("no_activity", "local_auth plugin requires a foreground activity");
            return;
        }

        if (!(activity instanceof FragmentActivity)) {
            promise.reject(
                    "no_fragment_activity",
                    "local_auth plugin requires activity to be a FragmentActivity.");
            return;
        }
        AuthenticationHelper authenticationHelper =
                new AuthenticationHelper(
                        (FragmentActivity) activity,
                        true,
                        true,
                        "Cancel",
                        "Scan FingerPrint",
                        "Scan To Redeem",
                        "Reason",
                        "GO to Settings",
                        true,
                        new AuthenticationHelper.AuthCompletionHandler() {
                            @Override
                            public void onSuccess() {
                                if (authInProgress.compareAndSet(true, false)) {
                                    promise.resolve(true);
                                }
                            }

                            @Override
                            public void onFailure() {
                                if (authInProgress.compareAndSet(true, false)) {
                                    promise.resolve(false);
                                }
                            }

                            @Override
                            public void onError(String code, String error) {
                                if (authInProgress.compareAndSet(true, false)) {
                                    promise.reject(code, error);
                                }
                            }
                        });
        authenticationHelper.authenticate();

    }
}

