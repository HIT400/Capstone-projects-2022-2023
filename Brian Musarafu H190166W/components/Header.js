import {View, Text, StyleSheet, Image, TouchableOpacity} from 'react-native';
import React from 'react';

const Header = () => {
  const toRegister = () => {
    navigation.navigate('Register');
  };
  return (
    <View style={styles.headerWrapper}>
      {/* Header */}
      <View style={styles.profileComponent}>
        <View>
          <Image
            style={styles.accountProfile}
            source={{
              uri: 'https://scontent.fhre1-1.fna.fbcdn.net/v/t39.30808-6/330977130_729593605180766_3061050376887023796_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=n3913e8oXZ0AX_kAN51&_nc_oc=AQkKB04i3LUrMNgEKxW9d2ahUa-G6q86llCbXoMBPeLPM98y-6_oBNo163n7yWkjI88cC6xS9v6wtLezOofCWFHI&_nc_ht=scontent.fhre1-1.fna&oh=00_AfAC1NDdnskdqCZEHL26xkUWe-8XEZTmLHe3ANpXFaTFRQ&oe=642DA797',
            }}
          />
        </View>
        <View>
          <View
            style={{
              display: 'flex',
              flexDirection: 'row',
              alignItems: 'center',
              paddingBottom: 3,
            }}>
            <Text style={styles.accountName}>Brian Musarafu</Text>
          </View>
          <View>
            <Text style={styles.accountLocation}>Profile</Text>
          </View>
        </View>
      </View>
      <View>
        <TouchableOpacity>
          <Image
            source={require('../assets/icons/menu.png')}
            resizeMode="contain"
            style={{
              width: 30,
              height: 20,
              tintColor: '#9058f7',
              left: 200,
            }}
          />
        </TouchableOpacity>
      </View>
    </View>
  );
};

export default Header;
const styles = StyleSheet.create({
  appName: {
    fontFamily: 'ExtraBold',
    fontSize: 25,
    letterSpacing: -1,
  },
  headerWrapper: {
    display: 'flex',
    flexDirection: 'row',
    alignContent: 'space-between',
    alignItems: 'center',
  },
  profileComponent: {
    display: 'flex',
    flexDirection: 'row',
    paddingBottom: 10,
    alignItems: 'center',
  },
  accountName: {
    marginRight: 5,
    marginLeft: 10,
    fontFamily: 'Regular',
  },
  accountProfile: {
    width: 40,
    height: 40,
    borderRadius: 50,
  },
  accountLocation: {
    marginTop: -5,
    marginLeft: 10,
    fontFamily: 'Bold',
    fontSize: 15,
  },
});
