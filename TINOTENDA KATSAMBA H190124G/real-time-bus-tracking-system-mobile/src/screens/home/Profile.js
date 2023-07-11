import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';

const UserProfile = ({ userId }) => {
  const [user, setUser] = useState(null);

  useEffect(() => {
    fetch(`http://192.168.137.225:8080/user/get-by-id/c10694f9-7b7b-4a6a-817d-670cbe9591a8`)
      .then(response => response.json())
      .then(data => setUser(data))
      .catch(error => console.log(error));
  }, [userId]);

  if (!user) {
    return <Text>Loading...</Text>;
  }

  return (
    <View style={styles.container}>
    {/* <Image
      source={{ uri: 'https://www.bootdey.com/image/900x400/FF7F50/000000' }}
      style={styles.coverImage}
    /> */}
    <View style={styles.avatarContainer}>
      {/* <Image
        source={{ uri: 'https://www.bootdey.com/img/Content/avatar/avatar1.png' }}
        style={styles.avatar}
      /> */}
      <Text style={[styles.name, styles.textWithShadow]}>Jane Doe</Text>
    </View>
    <View style={styles.content}>
      <View style={styles.infoContainer}>
        <Text style={styles.infoLabel}>Name:</Text>
        <Text style={styles.infoValue}>{user.name}</Text>
      </View>
      <View style={styles.infoContainer}>
        <Text style={styles.infoLabel}>Name:</Text>
        <Text style={styles.infoValue}>{user.surname}</Text>
      </View>
      <View style={styles.infoContainer}>
        <Text style={styles.infoLabel}>Email:</Text>
        <Text style={styles.infoValue}>{user.email}</Text>
      </View>
      <View style={styles.infoContainer}>
        <Text style={styles.infoLabel}>Email:</Text>
        <Text style={styles.infoValue}>{user.email}</Text>
      </View>
    </View>
  </View>
  );
};

export default UserProfile;
// import React from 'react';
// import {StyleSheet, Text,View, SafeAreaView} from 'react-native';

// const Profile = () => {
//   return (
    // <View style={styles.container}>
    //   {/* <Image
    //     source={{ uri: 'https://www.bootdey.com/image/900x400/FF7F50/000000' }}
    //     style={styles.coverImage}
    //   /> */}
    //   <View style={styles.avatarContainer}>
    //     {/* <Image
    //       source={{ uri: 'https://www.bootdey.com/img/Content/avatar/avatar1.png' }}
    //       style={styles.avatar}
    //     /> */}
    //     <Text style={[styles.name, styles.textWithShadow]}>Jane Doe</Text>
    //   </View>
    //   <View style={styles.content}>
    //     <View style={styles.infoContainer}>
    //       <Text style={styles.infoLabel}>Email:</Text>
    //       <Text style={styles.infoValue}>jane.doe@example.com</Text>
    //     </View>
    //     <View style={styles.infoContainer}>
    //       <Text style={styles.infoLabel}>Location:</Text>
    //       <Text style={styles.infoValue}>San Francisco, CA</Text>
    //     </View>
    //     <View style={styles.infoContainer}>
    //       <Text style={styles.infoLabel}>Bio:</Text>
    //       <Text style={styles.infoValue}>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ornare magna eros, eu pellentesque tortor vestibulum ut. Maecenas non massa sem. Etiam finibus odio quis feugiat facilisis.</Text>
    //     </View>
    //   </View>
    // </View>
//   );
// };


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    padding: 20,
  },
  coverImage: {
    height: 200,
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
  },
  avatarContainer: {
    alignItems: 'center',
    marginTop: 20,
  },
  avatar: {
    width: 120,
    height: 120,
    borderRadius: 60,
  },
  name: {
    fontSize: 20,
    fontWeight: 'bold',
    marginTop: 10,
    color:'white'
  },
  content: {
    marginTop: 20,
  },
  infoContainer: {
    marginTop: 20,
  },
  infoLabel: {
    fontWeight: 'bold',
  },
  infoValue: {
    marginTop: 5,
  },
});

// export default Profile;

// const styles = StyleSheet.create({});
