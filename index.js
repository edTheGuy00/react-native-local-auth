import { NativeModules } from "react-native";

const { LocalAuth } = NativeModules;

export default {
  getAvailableBiometrics: () => {
    return LocalAuth.getAvailableBiometrics();
  }
};
