import {
  View,
  Text,
  SafeAreaView,
  StyleSheet,
  ScrollView,
  Image,
  TextInput,
  FlatList,
  TouchableOpacity,
} from 'react-native';
import React, {useEffect, useState} from 'react';
import Categories from '../components/Categories';
import FeaturedCategory from '../components/FeaturedCategory';
import {useNavigation} from '@react-navigation/native';
import ArtifactsCard from '../components/ArtifactsCard';
import client from '../sanity';

const ArtifactsScreen = () => {
  const [artifacts, setArtifacts] = useState([]);

  const navigation = useNavigation();

  useEffect(() => {
    const query = `
    *[_type == "artifacts"] {
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
    client.fetch(query).then(data => setArtifacts(data));
  }, []);

  return (
    <SafeAreaView style={styles.pageStyle}>
      <TouchableOpacity onPress={navigation.goBack}>
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

      {/* Search Component */}

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
      </View>
      <ScrollView>
        {/* ----------------------------------------Categories---------------------------------------- */}
        <FeaturedCategory
          id={11}
          title="Categories"
          description="All of the categories that we have in the museum."
        />
        <View style={styles.categoriesView}>
          <View style={{marginBottom: 20}}>
            <Categories />
          </View>
        </View>
        {/* ----------------------------------------End Categories---------------------------------------- */}
        {/* ----------------------------------------Categories---------------------------------------- */}
        <FeaturedCategory
          id={22}
          title="All Artifacts"
          description="All of the artifacts that we have in the museum."
        />

        <View style={{paddingTop: 20}}>
          <FlatList
            data={artifacts}
            horizontal={false}
            numColumns={2}
            keyExtractor={(artifact, index) => artifact._id}
            renderItem={({item: artifact}) => (
              <ArtifactsCard
                key={artifact._id}
                id={artifact._id}
                title={artifact.title}
                imgUrl={artifact.imgUrl}
                ar_imgUrl={artifact.ar_imgUrl}
                short_description={artifact.short_description}
                other_images={artifact.other_images}
                rating={artifact.rating}
                category={artifact.category}
                location={artifact.location}
                location_in_building={artifact.location_in_building}
                floor={artifact.floor}
              />
            )}
          />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

export default ArtifactsScreen;

const styles = StyleSheet.create({
  pageStyle: {
    padding: 20,
    paddingBottom: 250,
    paddingTop: 50,
    // backgroundColor: '#fdfdfd',
    minHeight: '100%',
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
    marginTop: 20,
  },
});
