import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import axios from 'axios';

const Card = () => {
  const [bus, setBus] = useState({});

  useEffect(() => {
    const a = () =>{
      axios.get('http://192.168.22.7:8080/busses/all-busses')
      .then(response => {
        const t = response.data
        t.forEach(t => {
        setBus(prev => ({
          ...prev,
          [t.bus_id]: t
        }));
      })
      })
      .catch(error => {
        // console.log(error);
      });
    }
    a();
  }, []);
  console.log(bus)

  const Item = () => (
    <View style={styles.card} key={index}>
        <>
          <Text style={styles.routeName}>Route Name:{item.bus_route_name}</Text>
          <Text style={styles.busNumber}>Bus Number:{item.bus_number}</Text>
          <Text style={styles.busNumber}>Bus fair:{item.fair}</Text>
        </>
     
    </View>
  );
  

  return (
    <>
    {Object.keys(bus).length !== 0 ? (
      Object.values(bus).map((item, index) => (

     
    <View style={styles.card} key={index}>
        <>
          <Text style={styles.routeName}>Route Name:{item.bus_route_name}</Text>
          <Text style={styles.busNumber}>Bus Number:{item.bus_number}</Text>
          <Text style={styles.busNumber}>Bus fair:{item.fair}$0.50</Text>
        </>
     
    </View> ))
    ): <Text>No buses</Text>
  
  }
    </>
  );
};

const styles = StyleSheet.create({
  card: {
    backgroundColor: 'white',
    borderRadius: 10,
    padding: 20,
    margin: 10,
    alignItems: 'center',
    justifyContent: 'center',
  },
  routeName: {
    fontSize: 24,
    fontWeight: 'bold',
    margin: 5,
  },
  busNumber: {
    fontSize: 16,
    margin: 5,
  },
});

export default Card;
// import React, { useState } from 'react';
// import { View, Text, TextInput, Button, StyleSheet, FlatList } from 'react-native';
// import axios from 'axios';

// const API_URL = 'https://example.com/api/customers';

// const CustomerSearch = () => {
//   const [searchText, setSearchText] = useState('');
//   const [searchResults, setSearchResults] = useState([]);

//   const handleSearch = () => {
//     axios.get(API_URL, {
//       params: {
//         name: searchText
//       }
//     })
//       .then(response => setSearchResults(response.data))
//       .catch(error => console.error(error));
//   };

//   const renderItem = ({ item }) => (
//     <View style={styles.item}>
//       <Text style={styles.label}>Name: {item.name}</Text>
//       <Text style={styles.label}>Email: {item.email}</Text>
//       <Text style={styles.label}>Phone: {item.phone}</Text>
//     </View>
//   );

//   return (
//     <View style={styles.container}>
//       <Text style={styles.label}>Search: </Text>
//       <TextInput
//         style={styles.input}
//         onChangeText={setSearchText}
//         value={searchText}
//       />
//       <Button
//         title="Search"
//         onPress={handleSearch}
//       />
//       <FlatList
//         style={styles.list}
//         data={searchResults}
//         renderItem={renderItem}
//         keyExtractor={item => item.id.toString()}
//       />
//     </View>
//   );
// };

// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     justifyContent: 'center',
//     alignItems: 'center',
//   },
//   label: {
//     fontSize: 18,
//   },
//   input: {
//     borderWidth: 1,
//     borderColor: 'gray',
//     padding: 8,
//     margin: 10,
//     width: '90%',
//   },
//   list: {
//     marginTop: 20,
//     width: '90%',
//   },
//   item: {
//     backgroundColor: '#f9c2ff',
//     padding: 10,
//     marginVertical: 8,
//     marginHorizontal: 16,
//   },
// });

// export default CustomerSearch;