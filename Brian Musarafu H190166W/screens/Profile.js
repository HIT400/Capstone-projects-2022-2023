import {View, Text, StyleSheet, Image, TouchableOpacity} from 'react-native';
import React from 'react';
import {SafeAreaView} from 'react-native-safe-area-context';
import SettingsHeader from '../components/SettingsHeader';
import {useNavigation} from '@react-navigation/native';

const Profile = () => {
  const navigation = useNavigation();
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
      <SettingsHeader />
    </SafeAreaView>
  );
};

export default Profile;

const styles = StyleSheet.create({
  pageStyle: {
    padding: 20,
    paddingBottom: 150,
    backgroundColor: '#fdfdfd',
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
});
