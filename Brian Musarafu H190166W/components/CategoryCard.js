import {View, Text, TouchableOpacity, Image, StyleSheet} from 'react-native';
import React from 'react';
import { urlFor } from '../sanity';

const CategoryCard = ({imgUrl, title}) => {
  return (
    <TouchableOpacity style={styles.containerStyle}>
      <Image
        source={{
          uri: urlFor(imgUrl).url(),
        }}
        style={styles.imageStyle}
      />
      <Text style={styles.titleStyle}>{title}</Text>
    </TouchableOpacity>
  );
};

export default CategoryCard;

const styles = StyleSheet.create({
  containerStyle: {
    marginRight: 8,
    position: 'relative',
  },
  imageStyle: {
    height: 120,
    width: 150,
    borderRadius: 10,
  },
  titleStyle: {
    position: 'absolute',
    bottom: 20,
    left: 10,
    color: '#ffffff',
    fontFamily: 'Bold',
  },
});
