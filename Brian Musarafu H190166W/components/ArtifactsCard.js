import {View, Text, TouchableOpacity, Image, StyleSheet} from 'react-native';
import React from 'react';
import {urlFor} from '../sanity';
import {useNavigation} from '@react-navigation/native';

const ArtifactsCard = ({
  id,
  imageUrl,
  title,
  ar_imgUrl,
  short_description,
  other_images,
  rating,
  category,
  location,
  location_in_building,
  floor,
}) => {
  const navigation = useNavigation();
  const toDetails = () => {
    navigation.navigate('ArtifactDetails', {
      id,
      imageUrl,
      title,
      ar_imgUrl,
      short_description,
      other_images,
      rating,
      category,
      location,
      location_in_building,
      floor,
    });
  };
  return (
    <TouchableOpacity onPress={toDetails} style={styles.opacityWrapper}>
      <Image
        source={{
          uri: urlFor(imageUrl).url(),
        }}
        style={styles.imageStyle}
      />
      <View style={styles.textWrapper}>
        <Text style={styles.titleStyle}>{title}</Text>
        <View style={styles.detailStyle}>
          <Image
            source={require('../assets/icons/star.png')}
            resizeMode="contain"
            style={{
              width: 13,
              height: 13,
              tintColor: '#9058f7',
              opacity: 0.5,
            }}
          />
          <Text style={styles.ratingOuterText}>
            <Text style={styles.ratingInnerText}>{rating}</Text> Rating
          </Text>
        </View>
        <View style={styles.locationContainer}>
          <Image
            source={require('../assets/icons/institution.png')}
            resizeMode="contain"
            style={styles.locationIconStyle}
          />
          <Text style={styles.stepsLocationTextStyle}>
            {location_in_building}
          </Text>
        </View>
      </View>
    </TouchableOpacity>
  );
};

export default ArtifactsCard;

const styles = StyleSheet.create({
  opacityWrapper: {
    backgroundColor: '#fbf8fd',
    marginRight: 8,
    marginBottom: 8,
    borderRadius: 15,
    padding: 10,
  },
  imageStyle: {
    height: 120,
    width: 160,
    borderRadius: 10,
  },
  titleStyle: {
    fontFamily: 'ExtrsBold',
    fontSize: 17,
    paddingTop: 5,
  },
  textWrapper: {
    padding: 5,
    paddingBottom: 7,
  },
  detailStyle: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
  },
  ratingOuterText: {
    fontFamily: 'Bold',
    fontSize: 12,
    color: 'gray',
    left: 10,
  },
  ratingInnerText: {
    fontFamily: 'SemiBold',
    fontSize: 11,
    color: '#9059f6',
  },
  locationContainer: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    paddingBottom: 3,
  },
  ratingIconStyle: {
    width: 20,
    height: 20,
    marginRight: 5,
  },
  locationIconStyle: {
    width: 15,
    height: 15,
    marginRight: 5,
    tintColor: '#9058f7',
    opacity: 0.5,
  },
  stepsLocationTextStyle: {
    fontFamily: 'Bold',
    fontWeight: 'bold',
    fontSize: 12,
    color: 'grey',
  },
  iconStyle: {
    width: 60,
    height: 60,
    tintColor: '#fec93d',
    position: 'absolute',
    right: 8,
    top: 60,
  },
});
