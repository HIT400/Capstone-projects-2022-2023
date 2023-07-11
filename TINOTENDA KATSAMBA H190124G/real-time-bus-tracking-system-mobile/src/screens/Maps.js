// Integration of Google map in React Native using react-native-maps
// https://aboutreact.com/react-native-map-example/
// Import React
import React, { useEffect, useState } from 'react';
// Import required components
import {SafeAreaView, StyleSheet, View,Dimensions} from 'react-native';
// Import Map and Marker
import MapView, {Marker} from 'react-native-maps';
import axios from 'axios';
const Maps = () => {
   
  const [lattitude, setLattitude] = useState(-67.842929840088);
  const [longitude,setLongitude] = useState( 31.010303497314);
  const [date,setDate] =useState(null)

  useEffect(() => {
      axios.get('http://192.168.22.7:8080/coordinate/all-coordinates')
      .then(response => {
        // console.log(response.data)
        let a = response.data
        console.log(a[a.length -1])
        let b = a[a.length -1]
         ;
       setLattitude(parseFloat(b.lattitude));
       setLongitude(parseFloat(b.longitude));
       setDate(b.date)
       console.log(lattitude)

      })
      .catch(error => {
        console.log(response.data)
      });
  }, []);

  return (
    <SafeAreaView style={{flex: 1}}>
      <View style={ {height: Dimensions.get('window').height - 100}}>
        <MapView
          style={styles.mapStyle}
          initialRegion={{
            latitude: -17.842929840088,
            longitude: 31.010303497314,
            latitudeDelta: 0.0922,
            longitudeDelta: 0.0421,
          }}
          customMapStyle={mapStyle}>
          <Marker
            draggable
            coordinate={{
              latitude: lattitude,
              longitude: longitude,
            }}
            onDragEnd={e => alert(JSON.stringify(e.nativeEvent.coordinate))}
            title={'Bus 1 Position in time'}
            description={date}
          />
        </MapView>
      </View>
    </SafeAreaView>
  );
};
export default Maps;
const mapStyle = [
  {elementType: 'geometry', stylers: [{color: '#242f3e'}]},
  {elementType: 'labels.text.fill', stylers: [{color: '#746855'}]},
  {elementType: 'labels.text.stroke', stylers: [{color: '#242f3e'}]},
  {
    featureType: 'administrative.locality',
    elementType: 'labels.text.fill',
    stylers: [{color: '#d59563'}],
  },
  {
    featureType: 'poi',
    elementType: 'labels.text.fill',
    stylers: [{color: '#d59563'}],
  },
  {
    featureType: 'poi.park',
    elementType: 'geometry',
    stylers: [{color: '#263c3f'}],
  },
  {
    featureType: 'poi.park',
    elementType: 'labels.text.fill',
    stylers: [{color: '#6b9a76'}],
  },
  {
    featureType: 'road',
    elementType: 'geometry',
    stylers: [{color: '#38414e'}],
  },
  {
    featureType: 'road',
    elementType: 'geometry.stroke',
    stylers: [{color: '#212a37'}],
  },
  {
    featureType: 'road',
    elementType: 'labels.text.fill',
    stylers: [{color: '#9ca5b3'}],
  },
  {
    featureType: 'road.highway',
    elementType: 'geometry',
    stylers: [{color: '#746855'}],
  },
  {
    featureType: 'road.highway',
    elementType: 'geometry.stroke',
    stylers: [{color: '#1f2835'}],
  },
  {
    featureType: 'road.highway',
    elementType: 'labels.text.fill',
    stylers: [{color: '#f3d19c'}],
  },
  {
    featureType: 'transit',
    elementType: 'geometry',
    stylers: [{color: '#2f3948'}],
  },
  {
    featureType: 'transit.station',
    elementType: 'labels.text.fill',
    stylers: [{color: '#d59563'}],
  },
  {
    featureType: 'water',
    elementType: 'geometry',
    stylers: [{color: '#17263c'}],
  },
  {
    featureType: 'water',
    elementType: 'labels.text.fill',
    stylers: [{color: '#515c6d'}],
  },
  {
    featureType: 'water',
    elementType: 'labels.text.stroke',
    stylers: [{color: '#17263c'}],
  },
];
const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
    justifyContent: 'flex-end',
  },
  mapStyle: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
});
