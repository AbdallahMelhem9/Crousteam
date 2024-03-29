import React, {useState} from 'react';
import { Text, Button, View, StyleSheet, TouchableOpacity } from 'react-native';
import colors from './Colors.react';

const buttonStyles = StyleSheet.create({
  buttonContainer: {
    width:'50%',
    heigt:'8%',
    backgroundColor: colors.background,
    borderRadius: 10,
    padding: 20,
    justifyContent:'center',
    alignItems:'center',
    margin: 10,
    elevation: 3, // for Android
    shadowColor: colors.secondaryText, 
    shadowOffset: { width: 0, height: 7 }, 
  },
  buttonText: {
    color: colors.primaryText,
    fontSize: 24,
    fontFamily:'Arista-Pro-Alternate-Bold-trial',
  },
  center:{
    justifyContent:'center',
    alignItems:'center',
  }
});