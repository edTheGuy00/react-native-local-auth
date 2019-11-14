import { NativeModules } from "react-native";

const { LocalAuth } = NativeModules;

export default {
  getAvailableBiometrics: () => {
    return LocalAuth.getAvailableBiometrics();
  },
  authenticateWithBiometrics: (
    buttonCancel: string,
    fingerprintHint: string,
    title: string
  ) => {
    return LocalAuth.authenticateWithBiometrics(
      buttonCancel,
      fingerprintHint,
      title
    );
  }
};
