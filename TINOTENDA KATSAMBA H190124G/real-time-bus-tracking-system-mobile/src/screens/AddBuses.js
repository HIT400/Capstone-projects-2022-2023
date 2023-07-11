import {
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import {useState} from 'react';
import React from 'react';
import {COLORS} from '../constants';
import BusService from '../service/BusService';

const Addbuses = () => {
  // export default ReportAccidents = () => {

  const [bus, setBus] = useState({
    busnumber: '',
    roote: '',
    driver: '',
  });
  const handleChange = e => {
    const value = e.target.value;
    setBus({...bus, [e.target.name]: value});
  };

  const saveBus = e => {
    e.preventDefault();
    BusService.saveBus(bus)
      .then(response => {
        console.log(response);
      })
      .catch(error => {
        console.log(error);
      });
  };
  return (
    <View style={styles.container}>
      <View style={styles.logoContainer}>
        {/* <Image
          source={{uri: 'https://www.bootdey.com/img/Content/avatar/avatar6.png'}}
          style={styles.logo}
        /> */}
      </View>
      <View style={styles.formContainer}>
        <View style={styles.card}>
          <View style={styles.inputContainer}>
            <Text style={styles.label}>Bus Number</Text>
            <TextInput
              style={styles.input}
              value={bus.busnumber}
              onChangeText={e => handleChange(e)}
              placeholder="Bus Number"
              placeholderTextColor="#999"
            />
          </View>
          <View style={styles.inputContainer}>
            <Text style={styles.label}>Route</Text>
            <TextInput
              style={styles.input}
              value={bus.roote}
              onChangeText={e => handleChange(e)}
              placeholder="Route"
              placeholderTextColor="#999"
            />
          </View>
          <View style={styles.inputContainer}>
            <Text style={styles.label}>Bus Driver</Text>
            <TextInput
              style={styles.input}
              value={bus.driver}
              onChangeText={e => handleChange(e)}
              placeholder="Bus Driver"
              placeholderTextColor="#999"
            />
          </View>
          <TouchableOpacity style={styles.button} onClick={saveBus}>
            <Text style={styles.buttonText}>Add</Text>
          </TouchableOpacity>
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
    borderRadius: 60,
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
    shadowOffset: {width: 0, height: 2},
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
    borderRadius: 6,
    borderWidth: 1,
    borderColor: '#ddd',
    color: '#333',
    paddingLeft: 10,
  },
  button: {
    width: '100%',
    height: 40,
    backgroundColor: '#333',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 4,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
  },
};

export default Addbuses;

// const styles = StyleSheet.create({});
