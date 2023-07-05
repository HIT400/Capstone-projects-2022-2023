import {View, Text, StyleSheet, Image, ScrollView} from 'react-native';
import React, {useEffect, useState} from 'react';
import client from '../sanity';

const FeaturedCategory = ({title, description}) => {
  return (
    <View>
      <View style={styles.wrapper}>
        <Text style={styles.title}>{title}</Text>
        <Image
          source={require('../assets/icons/chevronDown.png')}
          resizeMode="contain"
          style={{
            width: 10,
            height: 10,
            tintColor: '#9058f7',
          }}
        />
      </View>
      <Text style={styles.descriptionStyle}>{description}</Text>
    </View>
  );
};

export default FeaturedCategory;

const styles = StyleSheet.create({
  title: {
    fontFamily: 'Bold',
    fontSize: 18,
    letterSpacing: -1,
  },
  wrapper: {
    marginTop: 5,
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 5,
  },
  descriptionStyle: {
    fontSize: 12,
    color: 'gray',
    padding: 5,
  },
});
