import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  Button,
  View,
  TextInput,
  SafeAreaView,
  TouchableOpacity,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import {COLORS, ROUTES} from '../../constants';
import axios from 'axios';
import Logo from '../../assets/icons/LOGO.svg';
import {useNavigation} from '@react-navigation/native';



const Login = props => {

  // const {navigation} = props;

  // const {navigation} = props;
  const navigation = useNavigation();
    // export default ReportAccidents = () => {
      
      const [email, setEmail] = useState('');
     
      const [password, setPassword] = useState('');
  
      const submitForm =()=>{
        const FormData = {
          email,
          password
        };
      }
const API_URL = 'http://192.168.22.7:8080/user/login/'+email+'/'+password;

   const login = ()=>{
        axios.get(API_URL,FormData)
        .then(response =>{
          console.log('success:',response.data);
          if(response.data.email === email ){
              if(response.data.password === password){
                navigation.navigate(ROUTES.HOME)
              }
          }
          //handle success
        })
        
        .catch(error=>{
          console.error('Error:',error);
          //handle error
        })
      }
  return (
    <SafeAreaView style={styles.main}>
      <View style={styles.container}>
        <View style={styles.wFull}>
          <View style={styles.row}>
            <Logo width={55} height={55} style={styles.mr7} />
            <Text style={styles.brandName}></Text>
          </View>

          <Text style={styles.loginContinueTxt}>Login in to continue</Text>
          <TextInput  value={email}
              onChangeText={setEmail}  style={styles.input} placeholder="Email" />
                            {/* <TextInput style={styles.input} placeholder='Email'/> */}


              {/* <TextInput style={styles.input} placeholder='Password'/> */}


<TextInput  value={password}
              onChangeText={setPassword}  style={styles.input} placeholder="Password" />

          <View style={styles.loginBtnWrapper}>
            <LinearGradient
              colors={[COLORS.gradientForm, COLORS.primary]}
              style={styles.linearGradient}
              start={{y: 0.0, x: 0.0}}
              end={{y: 1.0, x: 0.0}}>
              {/******************** LOGIN BUTTON *********************/}
              {/* <Button
           title='Login'
           onPress={submitForm}/> */}
              <TouchableOpacity
                onPress={login}
                activeOpacity={0.7}
                style={styles.loginBtn}>
                <Text style={styles.loginText}>Log In</Text>
              </TouchableOpacity>
            </LinearGradient>
          </View>

          {/***************** FORGOT PASSWORD BUTTON *****************/}
          {/* <TouchableOpacity
            onPress={() =>
              navigation.navigate(ROUTES.REGISTER)
              })
            }
            style={styles.forgotPassBtn}>
            <Text style={styles.forgotPassText}>Forgot Password?</Text>
          </TouchableOpacity> */}
        </View>

        <View style={styles.footer}>
          <Text style={styles.footerText}> Don't have an account? </Text>
          {/******************** REGISTER BUTTON *********************/}
          <TouchableOpacity
            onPress={() =>
              navigation.navigate(ROUTES.REGISTER)
              }>
            <Text style={styles.signupBtn}>Sign Up</Text>
          </TouchableOpacity>
        </View>
      </View>
    </SafeAreaView>
  );
};

export default Login;

const styles = StyleSheet.create({
  main: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 16,
  },
  container: {
    padding: 15,
    width: '100%',
    position: 'relative',
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  brandName: {
    fontSize: 42,
    textAlign: 'center',
    fontWeight: 'bold',
    color: COLORS.primary,
    opacity: 0.9,
  },
  loginContinueTxt: {
    fontSize: 21,
    textAlign: 'center',
    color: COLORS.gray,
    marginBottom: 16,
    fontWeight: 'bold',
  },
  input: {
    borderWidth: 1,
    borderColor: COLORS.grayLight,
    padding: 15,
    marginVertical: 10,
    borderRadius: 5,
    height: 55,
    paddingVertical: 0,
  },
  // Login Btn Styles
  loginBtnWrapper: {
    height: 55,
    marginTop: 12,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.4,
    shadowRadius: 3,
    elevation: 5,
  },
  linearGradient: {
    width: '100%',
    borderRadius: 50,
  },
  loginBtn: {
    textAlign: 'center',
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
    height: 55,
  },
  loginText: {
    color: COLORS.white,
    fontSize: 16,
    fontWeight: '400',
  },
  forgotPassText: {
    color: COLORS.primary,
    textAlign: 'center',
    fontWeight: 'bold',
    marginTop: 15,
  },
  // footer
  footer: {
    position: 'absolute',
    bottom: 20,
    textAlign: 'center',
    flexDirection: 'row',
  },
  footerText: {
    color: COLORS.gray,
    fontWeight: 'bold',
  },
  signupBtn: {
    color: COLORS.primary,
    fontWeight: 'bold',
  },
  // utils
  wFull: {
    width: '100%',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 20,
  },
  mr7: {
    marginRight: 7,
  },
});
