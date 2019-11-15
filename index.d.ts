declare module "react-native-local-auth" {
  function getAvailableBiometrics(): Promise<string[]>;
  function authenticateWithBiometrics(
    buttonCancel: string,
    fingerprintHint: string,
    title: string,
    touchFingerSensor: string
  ): Promise<boolean>;
}
