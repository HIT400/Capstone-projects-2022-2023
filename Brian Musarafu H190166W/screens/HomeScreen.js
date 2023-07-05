import {
  View,
  Text,
  Image,
  StyleSheet,
  TextInput,
  ScrollView,
  StatusBar,
} from 'react-native';
import React, {useEffect, useLayoutEffect, useState} from 'react';
import {useNavigation} from '@react-navigation/native';
import {SafeAreaView} from 'react-native-safe-area-context';
import Categories from '../components/Categories';

import Header from '../components/Header';
import FeaturedCategory from '../components/FeaturedCategory';
import client from '../sanity';
import ArtifactsCard from '../components/ArtifactsCard';

const HomeScreen = () => {
  const navigation = useNavigation();
  const [mostRated, setMostRated] = useState([]);
  const [firstFloor, setfirstFloor] = useState([]);

  useLayoutEffect(() => {
    navigation.setOptions({
      headerShown: false,
    });
  }, []);

  useEffect(() => {
    const query = `
    *[_type == "artifacts" && rating >= 4] {
      title,
      short_description,
      imgUrl,
      ar_imgUrl,
      other_images,
      category->,
      location,
      location_in_building,
      floor,
      rating
    }

    `;
    const controller = new AbortController();
    const signal = controller.signal;
    client
      .fetch(query, {signal})
      .then(data => setMostRated(data))
      .catch(error => console.log(error));

    return () => controller.abort();
  }, []);

  useEffect(() => {
    const query = `
    *[_type == "artifacts" && floor == 1] {
      title,
      short_description,
      imgUrl,
      ar_imgUrl,
      other_images,
      category->,
      location,
      location_in_building,
      floor,
      rating
    }
    `;
    const controller = new AbortController();
    const signal = controller.signal;
    client
      .fetch(query, {signal})
      .then(data => setfirstFloor(data))
      .catch(error => console.log(error));

    return () => controller.abort();
  }, []);

  return (
    <SafeAreaView style={styles.pageStyle}>
      <StatusBar translucent backgroundColor="#000000" />
      {/* Header component */}
      <Header />
      {/* Home Design */}
      <ScrollView>
        <View style={styles.welcomeViewArea}>
          <View>
            <View
              style={{
                display: 'flex',
                flexDirection: 'row',
                alignItems: 'center',
                paddingBottom: 3,
              }}>
              <Text style={styles.welcomeAreaText}>Welcome </Text>
              <Image
                source={require('../assets/icons/handWave.png')}
                resizeMode="contain"
                style={{
                  width: 20,
                  height: 20,
                }}
              />
            </View>
          </View>
          <Text style={styles.welcomeTextMuseumName}>
            Bulawayo National Museum
          </Text>
        </View>
        {/* Search area */}
        <View style={styles.searchAreaWrapper}>
          <View style={styles.searchInputArea}>
            {/* Icon */}
            <Image
              source={require('../assets/icons/searchIcon.png')}
              resizeMode="contain"
              style={{
                width: 20,
                height: 20,
                tintColor: '#9059f6',
              }}
            />
            <TextInput
              style={styles.searchInputText}
              keyboardType="default"
              placeholder="Search for artifacts...."
              placeholderTextColor="grey"
            />
          </View>

          {/* ----------------------------------------Categories---------------------------------------- */}
          <FeaturedCategory
            id={123}
            title="Categories"
            description="All of the categories that we have in the museum."
          />
          <View style={styles.categoriesView}>
            <View style={{marginBottom: 20}}>
              <Categories />
            </View>
          </View>

          {/* ----------------------------------------Most Rated---------------------------------------- */}
          <FeaturedCategory
            id={1}
            title="Most Rated"
            description="Most rated and viewed artifacts in the whole museum."
          />

          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={{
              paddingHorizontal: 15,
              paddingTop: 10,
            }}>
            
            {mostRated?.map(artifact => (
              <ArtifactsCard
                key={artifact._id}
                id={artifact._id}
                title={artifact.title}
                imageUrl={artifact.imgUrl}
                ar_imgUrl={artifact.ar_imgUrl}
                short_description={artifact.short_description}
                other_images={artifact.other_images}
                rating={artifact.rating}
                category={artifact.category}
                location={artifact.location}
                location_in_building={artifact.location_in_building}
                floor={artifact.floor}
              />
            ))}
          </ScrollView>
          {/* ----------------------------------------End Most Viewed---------------------------------------- */}

          {/* ----------------------------------------First Floor---------------------------------------- */}
          <FeaturedCategory
            id={2}
            title="First Floor"
            description="Artifacts from the first floor."
          />

          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={{
              paddingHorizontal: 15,
              paddingTop: 10,
            }}>
            {firstFloor?.map(artifact => (
              <ArtifactsCard
                key={artifact._id}
                id={artifact._id}
                title={artifact.title}
                imageUrl={artifact.imgUrl}
                ar_imgUrl={artifact.ar_imgUrl}
                short_description={artifact.short_description}
                other_images={artifact.other_images}
                rating={artifact.rating}
                category={artifact.category}
                location={artifact.location}
                location_in_building={artifact.location_in_building}
                floor={artifact.floor}
              />
            ))}
          </ScrollView>
          {/* ----------------------------------------End First Floor---------------------------------------- */}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default HomeScreen;

const styles = StyleSheet.create({
  pageStyle: {
    padding: 20,
    backgroundColor: '#fdfdfd',
    paddingBottom: 150,
    minHeight: '100%',
  },
  headerWrapper: {
    display: 'flex',
    flexDirection: 'row',
    paddingBottom: 10,
  },
  accountName: {
    marginRight: 5,
    marginLeft: 10,
    fontFamily: 'Bold',
  },
  accountProfile: {
    width: 40,
    height: 40,
    borderRadius: 50,
  },
  welcomeViewArea: {
    marginTop: 40,
    marginBottom: 20,
  },
  welcomeAreaText: {
    fontFamily: 'SemiBold',
    fontSize: 15,
    color: 'grey',
    marginRight: 5,
  },
  welcomeTextMuseumName: {
    fontFamily: 'Bold',
    fontSize: 22,
    letterSpacing: -0.5,
  },
  searchAreaWrapper: {
    marginTop: 15,
    marginBottom: 20,
  },
  searchInputArea: {
    borderRadius: 15,
    paddingTop: 4,
    paddingBottom: 4,
    paddingLeft: 10,
    paddingRight: 10,
    backgroundColor: '#fbf8fd',
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    paddingBottom: 3,
  },
  searchInputText: {
    color: 'grey',
    fontSize: 15,
    fontFamily: 'SemiBold',
    width: '100%',
    marginLeft: 5,
  },
  categoriesView: {
    marginBottom: 30,
  },
  mostViewedTitle: {
    fontFamily: 'Bold',
    fontSize: 15,
    marginTop: 10,
    marginBottom: 10,
    marginRight: 5,
  },
});
