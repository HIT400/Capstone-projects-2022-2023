
import {Button, DatePickerIOSBase, StyleSheet, Text,TextInput,TouchableOpacity, View} from 'react-native';
import { useState } from 'react';
import React from 'react';
import axios from 'axios';
import { COLORS } from '../constants';

const API_URL = 'http://192.168.43.128:8080/complaints/save';

const ReportAccidents = () => {
  // export default ReportAccidents = () => {
    // const [date, setDate] = useState('');
    const [complaint, setComplaint] = useState('');
    const [bus_number, setBusNumber] = useState('');

    const submitForm =()=>{
      const FormData = {
        
        complaint,
        bus_number
      };

      axios.post(API_URL,FormData)
      .then(response =>{
        console.log('success:',response.data);
        //handle success
      })
      .catch(error=>{
        console.error('Error:',error);
        //handle error
      })
    }
  
  return (
    
    <View style={styles.container}>

        {/* <View style={styles.logoContainer}> */}
        
      {/* </View> */}
      <View style={styles.formContainer}>
        <Text style={styles.title}>Get In Touch</Text>
        <View style={styles.card}>
          {/* <View style={styles.inputContainer}>
            <Text style={styles.label}>Date</Text>
            <TextInput
              style={styles.input}
              value={date}
              onChangeText={setDate}
              placeholder="Name"
              placeholderTextColor="#999"
            />
          </View> */}

          <View style={styles.inputContainer}>
            <Text style={styles.label}>Bus NUmber</Text>
            <TextInput
              style={styles.input}
              value={bus_number}
              onChangeText={setBusNumber}
              placeholder="Name"
              placeholderTextColor="#999"
            />
          </View>

        
          <View style={styles.inputContainer}>
            <Text>Incident Report</Text>
            <TextInput
          multiline
          numberOfLines={4}
          value={complaint}
          onChangeText={setComplaint}
          placeholder='Please write your reviews here'
          style={styles.textArea}
          />
          </View>
          <Button
           title='Submit'
           onPress={submitForm}/>
           
          {/* <TouchableOpacity style={styles.button}>
            <Text style={styles.buttonText}>Submit</Text>
          </TouchableOpacity> */}
        </View>
      </View>
    </View>
  );
};

const styles = {
  container: {
    flex: 1,
  },
  background: {
    width: '100%',
    height: '100%',
    position: 'absolute',
  },
  logoContainer: {
    alignItems: 'center',
    marginTop: 120,
  },
  logo: {
    width: 120,
    height: 120,
    borderRadius:60,
    resizeMode: 'contain',
  },

    formContainer: {
      justifyContent: 'center',
      alignItems: 'center',
    },
    title: {
      fontSize: 24,
      color: '#fff',
      marginBottom: 20,
      marginTop: 20,
    },
    card: {
      width: '80%',
      backgroundColor: '#fff',
      borderRadius: 4,
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.2,
      shadowRadius: 2,
      padding: 20,
      marginBottom: 20,
    },
    inputContainer: {
      marginBottom: 20,
    },
    label: {
      fontSize: 16,
      color: '#333',
    },
    input: {
      height: 40,
      borderRadius:6,
      borderWidth: 1,
      borderColor: '#ddd',
      color: '#333',
      paddingLeft:10,
    },
    button: {
      width: '100%',
      height: 40,
      backgroundColor: '#333',
      alignItems: 'center',
      justifyContent: 'center',
      borderRadius: 4,
    },
    textArea:{
      borderColor:'#ccc',
      borderWidth:1,
      borderRadius:5,
      padding:10,
      height:150,
      textAlignVertical:'top',

    },
    buttonText: {
      color: '#fff',
      fontSize: 16,
    },
  };

    

export default ReportAccidents;



// const styles = StyleSheet.create({});

