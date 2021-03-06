/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { useState } from "react";
import {
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
  Button,
  Alert
} from "react-native";

import { Header, Colors } from "react-native/Libraries/NewAppScreen";

import LocalAuth from "react-native-local-auth";

const App: () => React$Node = () => {
  const [biometrics, setBiometric] = useState<String[]>([]);

  function getBiometrics() {
    LocalAuth.getAvailableBiometrics().then(bios => {
      setBiometric(bios);
    });
  }

  function authenticate() {
    LocalAuth.authenticateWithBiometrics(
      "cancel",
      "Scan your fingerprint",
      "Scan to Proceed"
    ).then(success => {
      console.log(success);
    }).catch((err)=>{
      console.log(err);
      Alert.alert('Error', err.message, [{ text: "OK"}]);
    })
  }
  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView>
        <ScrollView
          contentInsetAdjustmentBehavior="automatic"
          style={styles.scrollView}
        >
          <Header />
          {global.HermesInternal == null ? null : (
            <View style={styles.engine}>
              <Text style={styles.footer}>Engine: Hermes</Text>
            </View>
          )}
          <View style={styles.body}>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Get available Biometrics</Text>
              <Button
                onPress={getBiometrics}
                title={"Get Available Biometrics"}
              />
              {biometrics.map((b, _i) => {
                return (
                  <Text key={b} style={styles.highlight}>
                    {b}
                  </Text>
                );
              })}
            </View>
            <View style={styles.sectionContainer}>
              <Text style={styles.sectionTitle}>Authenticate</Text>
              <Button
                onPress={authenticate}
                title={"Authenticate with Biometrics"}
              />
            </View>
          </View>
        </ScrollView>
      </SafeAreaView>
    </>
  );
};

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.lighter
  },
  engine: {
    position: "absolute",
    right: 0
  },
  body: {
    backgroundColor: Colors.white
  },
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: "600",
    color: Colors.black
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: "400",
    color: Colors.dark
  },
  highlight: {
    fontWeight: "700"
  },
  footer: {
    color: Colors.dark,
    fontSize: 12,
    fontWeight: "600",
    padding: 4,
    paddingRight: 12,
    textAlign: "right"
  }
});

export default App;
