import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Image,
} from 'react-native';
import React, {useLayoutEffect} from 'react';
import {useNavigation} from '@react-navigation/native';
import {urlFor} from '../sanity';
import FeaturedCategory from '../components/FeaturedCategory';

const ArtifactDetails = ({route}) => {
  const navigation = useNavigation();

  useLayoutEffect(() => {
    navigation.setOptions({
      headerShown: false,
    });
  }, []);

  const {
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
  } = route.params;
  return (
    <ScrollView>
      <View>
        <Image
          source={{
            uri: urlFor(imageUrl).url(),
          }}
          style={{
            width: '100%',
            height: 300,
            backgroundColor: 'grey',
            padding: 4,
          }}
        />
        {/* ----------------------------------------BACK BUTTON---------------------------------------- */}
        <TouchableOpacity
          onPress={navigation.goBack}
          style={styles.buttonStyle}>
          <View style={styles.viewsMargin}>
            <Image
              source={require('../assets/icons/arrowLeft.png')}
              resizeMode="contain"
              style={{
                width: 20,
                height: 20,
                tintColor: '#9058f7',
                marginRight: 4,
              }}
            />
            <View style={styles.innerView}>
              <Text style={styles.innerViewText}>BACK</Text>
            </View>
          </View>
        </TouchableOpacity>
      </View>

      <View style={{backgroundColor: '#fff', minHeight: '100%'}}>
        <View style={{padding: 10, paddingTop: 10}}>
          <Text
            style={{fontFamily: 'ExtraBold', fontSize: 25, letterSpacing: -1}}>
            {title}
          </Text>
          <View style={{display: 'flex', flexDirection: 'row', margin: 10}}>
            <Image
              source={require('../assets/icons/star.png')}
              resizeMode="contain"
              style={{
                width: 13,
                height: 13,
                tintColor: '#9058f7',
                marginRight: 10,
              }}
            />
            <Text style={{marginRight: 10}}>
              <Text>{rating}</Text> Rating
            </Text>

            <Image
              source={require('../assets/icons/institution.png')}
              resizeMode="contain"
              style={{
                tintColor: '#9058f7',
                width: 15,
                height: 15,
                marginRight: 10,
              }}
            />
            <Text style={styles.stepsLocationTextStyle}>
              {location_in_building}
            </Text>
          </View>
        </View>

        <View style={{padding: 12, paddingTop: 10, justifyContent: 'center'}}>
          <Text style={{fontFamily: 'Regular', fontSize: 14}}>
            {short_description}
          </Text>
        </View>

        <View style={{padding: 12, paddingTop: 10, justifyContent: 'center'}}>
          <FeaturedCategory
            id={123}
            title="Fun Facts"
            description={'Fun facts that you did not know about ' + title}
          />
          {/* -------------------------------------------- Fun Fact 1---------------------------------------------------------- */}

          {/* -------------------------------------------- Fun Fact 2---------------------------------------------------------- */}
          {/* -------------------------------------------- Fun Fact 3---------------------------------------------------------- */}
          {/* -------------------------------------------- Fun Fact 4---------------------------------------------------------- */}
        </View>
      </View>
    </ScrollView>
  );
};

export default ArtifactDetails;

const styles = StyleSheet.create({
  pageStyle: {
    padding: 20,
    backgroundColor: '#fdfdfd',
    paddingBottom: 150,
    minHeight: '100%',
  },
  buttonStyle: {
    position: 'absolute',
    top: 50,
    left: 5,
  },
  viewsMargin: {
    margin: 10,
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
  },
  innerView: {
    backgroundColor: '#9059f6',

    paddingLeft: 8,
    paddingRight: 8,
    paddingTop: 4,
    paddingBottom: 4,
    borderRadius: 40,
  },
  innerViewText: {
    color: '#fff',
  },
});
