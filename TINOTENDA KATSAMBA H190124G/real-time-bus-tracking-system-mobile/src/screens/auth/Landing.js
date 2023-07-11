import React from 'react';
import { StyleSheet, View, Image, TouchableOpacity, Text } from 'react-native';


const WelcomeScreen = () => {

  return (
    <View style={styles.container}>
        <View style={styles.content}>
            <Text style={styles.title}>Welcome to Awesome App!</Text>
            <Image source={{uri:'https://bootdey.com/img/Content/avatar/avatar3.png'}} style={styles.image} />
            <Text style={styles.desc}>{'Please log in to continue\n to the awesommess'}</Text>
        </View>
        <View style={styles.buttonsContainer}>
            <TouchableOpacity style={[styles.button, styles.facebook]}>
                <Text style={styles.buttonText}>Login with facebook</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.button, styles.google]}>
                <Text style={styles.buttonText}>Login with Google</Text>
            </TouchableOpacity>
        </View>
    </View>
  );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    content :{
        flex:8,
        justifyContent:'center',
        alignItems:'center',
    },
    title:{
        fontSize:24,
        color:'#8A2BE2',
        fontWeight:'bold',
    },
    image:{
        width:120,
        height:120,
        borderRadius:60,
        marginTop:39,
    },
    desc:{
        fontSize:18,
        textAlign:'center',
        marginTop:30,
        color:'#808080'
    },
    buttonsContainer:{
        flex:2,
        flexDirection:'row',
        marginHorizontal:30,
        justifyContent:'space-around'
    },
    button:{
        width: '48%',
        height:50,
        borderRadius:10,
        alignItems:'center',
        justifyContent:'center',
    },
    buttonText:{
        color:'#fff',
        fontWeight:'bold',
    },
    facebook:{
        backgroundColor:'#4267B2'
    },
    google:{
        backgroundColor:'#DB4437'
    }
});

export default WelcomeScreen;