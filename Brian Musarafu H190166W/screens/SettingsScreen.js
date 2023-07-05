import {
  View,
  Text,
  StyleSheet,
  Image,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import React from 'react';
import {SafeAreaView} from 'react-native-safe-area-context';
import SettingsHeader from '../components/SettingsHeader';

const SettingsScreen = () => {
  return (
    <SafeAreaView style={styles.pageStyle}>
      <View style={styles.viewsMargin}>
        <Image
          source={require('../assets/icons/arrowLeft.png')}
          resizeMode="contain"
          style={{
            width: 20,
            height: 20,
            tintColor: '#9058f7',
          }}
        />
      </View>
      <View style={styles.viewsMargin}>
        <Text style={styles.pageTitle}>Settings</Text>
      </View>
      <View style={styles.profileView}>
        <SettingsHeader />
      </View>
      <ScrollView style={{marginTop: 20}}>
        {/* Menu Options */}

        {/* Button 1 */}
        <TouchableOpacity style={{marginTop: 20}}>
          <View style={styles.buttonView}>
            <View
              style={{
                backgroundColor: '#f5f5f5',
                height: 40,
                width: 40,
                borderRadius: 50,
                justifyContent: 'space-around',
                marginRight: 10,
              }}>
              <Image
                source={require('../assets/icons/envelope.png')}
                resizeMode="contain"
                style={styles.imageIconRight}
              />
            </View>
            <Text style={styles.titleStyle}> Email</Text>
            <View></View>
            <View>
              <Image
                source={require('../assets/icons/chevronRight.png')}
                resizeMode="contain"
                style={styles.imageIcon}
              />
            </View>
          </View>
        </TouchableOpacity>
        {/* Button 2 */}
        <TouchableOpacity style={{marginTop: 20}}>
          <View style={styles.buttonView}>
            <View
              style={{
                backgroundColor: '#f5f5f5',
                height: 40,
                width: 40,
                borderRadius: 50,
                justifyContent: 'space-around',
                marginRight: 10,
              }}>
              <Image
                source={require('../assets/icons/bell.png')}
                resizeMode="contain"
                style={styles.imageIconRight}
              />
            </View>
            <Text style={styles.titleStyle}> Notification</Text>
            <View></View>
            <View>
              <Image
                source={require('../assets/icons/chevronRight.png')}
                resizeMode="contain"
                style={styles.imageIcon}
              />
            </View>
          </View>
        </TouchableOpacity>
        {/* Button 3 */}
        <TouchableOpacity style={{marginTop: 20}}>
          <View style={styles.buttonView}>
            <View
              style={{
                backgroundColor: '#f5f5f5',
                height: 40,
                width: 40,
                borderRadius: 50,
                justifyContent: 'space-around',
                marginRight: 10,
              }}>
              <Image
                source={require('../assets/icons/shield.png')}
                resizeMode="contain"
                style={styles.imageIconRight}
              />
            </View>
            <Text style={styles.titleStyle}> Privacy</Text>
            <View></View>
            <View>
              <Image
                source={require('../assets/icons/chevronRight.png')}
                resizeMode="contain"
                style={styles.imageIcon}
              />
            </View>
          </View>
        </TouchableOpacity>
        {/* Button 1 */}
        <TouchableOpacity style={{marginTop: 20}}>
          <View style={styles.buttonView}>
            <View
              style={{
                backgroundColor: '#f5f5f5',
                height: 40,
                width: 40,
                borderRadius: 50,
                justifyContent: 'space-around',
                marginRight: 10,
              }}>
              <Image
                source={require('../assets/icons/chat.png')}
                resizeMode="contain"
                style={styles.imageIconRight}
              />
            </View>
            <Text style={styles.titleStyle}> Contact</Text>
            <View></View>
            <View>
              <Image
                source={require('../assets/icons/chevronRight.png')}
                resizeMode="contain"
                style={styles.imageIcon}
              />
            </View>
          </View>
        </TouchableOpacity>
        {/* Button 4 */}
        <TouchableOpacity style={{marginTop: 20}}>
          <View style={styles.buttonView}>
            <View
              style={{
                backgroundColor: '#f5f5f5',
                height: 40,
                width: 40,
                borderRadius: 50,
                justifyContent: 'space-around',
                marginRight: 10,
              }}>
              <Image
                source={require('../assets/icons/padlocked.png')}
                resizeMode="contain"
                style={styles.imageIconRight}
              />
            </View>
            <Text style={styles.titleStyle}> Security</Text>
            <View></View>
            <View>
              <Image
                source={require('../assets/icons/chevronRight.png')}
                resizeMode="contain"
                style={styles.imageIcon}
              />
            </View>
          </View>
        </TouchableOpacity>
        {/* Button 5 */}
        <TouchableOpacity style={{marginTop: 20}}>
          <View style={styles.buttonView}>
            <View
              style={{
                backgroundColor: '#f5f5f5',
                height: 40,
                width: 40,
                borderRadius: 50,
                justifyContent: 'space-around',
                marginRight: 10,
              }}>
              <Image
                source={require('../assets/icons/logout.png')}
                resizeMode="contain"
                style={styles.imageIconRight}
              />
            </View>
            <Text style={styles.titleStyle}> Logout</Text>
            <View></View>
            <View>
              <Image
                source={require('../assets/icons/chevronRight.png')}
                resizeMode="contain"
                style={styles.imageIcon}
              />
            </View>
          </View>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
};

export default SettingsScreen;

const styles = StyleSheet.create({
  pageStyle: {
    padding: 20,
    backgroundColor: '#fff',
    paddingBottom: 50,
    minHeight: '100%',
  },
  viewsMargin: {
    marginBottom: 10,
  },
  profileView: {
    marginTop: 25,
  },
  pageTitle: {
    fontFamily: 'Bold',
    fontSize: 17,
  },
  imageIconRight: {
    width: 20,
    height: 20,
    tintColor: '#9059f6',
    alignItems: 'center',
    left: 10,
  },
  imageIcon: {
    width: 10,
    height: 10,
    tintColor: '#9059f6',
    alignItems: 'center',
    left: 10,
  },
  buttonView: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginRight: 20,
  },
});
