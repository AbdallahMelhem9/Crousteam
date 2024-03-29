import React from 'react';
import { TextInput, View, Text, StyleSheet } from 'react-native';
import colors from './Colors.react';

const styles = StyleSheet.create({
  inputContainer: {
    paddingBottom: 16,
    color: colors.background,
    width:'100%',
  },
  input: {
    color: 'black',
    backgroundColor: colors.background,
    borderRadius: 4,
    fontFamily:'Arista-Pro-Alternate-Bold-trial',
    elevation: 3, // for Android
    shadowColor: colors.secondaryText, 
    shadowOffset: { width: 0, height: 7 }, 
  },
  inputLabel: {
    fontSize: 16,
    alignSelf: 'center',
    justifyContent: 'center',
    color:colors.secondaryText,
    fontFamily:'Arista-Pro-Alternate-Bold-trial'
  },
});

export default function CrousteamTextInput({ label, value, onChangeText, ...props }) {
  return (<View style={styles.inputContainer}>
    <Text
      style={styles.inputLabel}>
      {label}
    </Text>
    <TextInput
      style={styles.input}
      onChangeText={onChangeText}
      value={value}
      {...props} />
  </View>);
}
