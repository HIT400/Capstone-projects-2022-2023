import {View, Text, StyleSheet, Image} from 'react-native';
import React from 'react';

const SettingsHeader = () => {
  return (
    <View style={styles.wrapper}>
      {/* Header */}
      <View style={styles.headerWrapper}>
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
            <Text style={styles.accountLocation}>_User_name</Text>
          </View>
        </View>
      </View>
    </View>
  );
};

export default SettingsHeader;
const styles = StyleSheet.create({
  pagestyle: {
    maxHeight: '100%',
  },
  wrapper: {
    padding: 40,
  },
  headerWrapper: {
    display: 'flex',
    flexDirection: 'row',
    paddingBottom: 10,
    alignItems: 'center',
  },
  accountName: {
    marginRight: 5,
    marginLeft: 10,

    fontFamily: 'Bold',
    fontSize: 22,
  },
  accountProfile: {
    width: 80,
    height: 80,
    borderRadius: 50,
  },
  accountLocation: {
    marginTop: -5,
    marginLeft: 10,
    fontFamily: 'Regular',
    fontSize: 18,
  },
});
