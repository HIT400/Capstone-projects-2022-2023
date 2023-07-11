// const Home = () => {
//   return (
//     <View
//       style={{
//         flex: 1,
//         justifyContent: 'center',
//         alignItems: 'center',
//         backgroundColor: COLORS.bgColor,
//       }}>
//       <Text>Home!</Text>
//     </View>
//   );
// };

// export default Home;

// const styles = StyleSheet.create({});

import React, { useState } from 'react'
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Image,
  Alert,
  FlatList,
  Dimensions,
} from 'react-native'
import { COLORS } from '../../constants'
import Maps from '../Maps';

const BusTrackingSystem = () => {
  return (
    <View>
      <View style={{height: Dimensions.get('window').height - 100}}>
         <Maps/>
    </View>
    <View>
      {/* <View style={{height: Dimensions.get('window').height -20}}>
        <Image source={require('../../assets/drawer-cover.jpeg')} />
      </View> */}
    </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f2f2f2',
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    margin: 20,
  },
  button: {
    backgroundColor: '#4CAF50',
    padding: 10,
    margin: 10,
    borderRadius: 5,
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default BusTrackingSystem;