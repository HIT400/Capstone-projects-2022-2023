import React from 'react';
import {createDrawerNavigator} from '@react-navigation/drawer';
import {COLORS, ROUTES} from '../constants';
import {Wallet, Notifications, Home} from '../screens';
import BottomTabNavigator from './BottomTabNavigator';
import Icon from 'react-native-vector-icons/Ionicons';
import CustomDrawer from '../components/CustomDrawer';
import ReportAccidents from '../screens/ReportAccidents';
import Addbuses from '../screens/AddBuses';
import MapView from 'react-native-maps/lib/MapView';
import Maps from '../screens/Maps';
import Profile from '../screens/home/Profile';
import SearchBus from '../screens/SearchBusNumber';
import ViewDrivers from '../admin/ViewDrivers';

const Drawer = createDrawerNavigator();

function DrawerNavigator() {
  return (
    <Drawer.Navigator
      drawerContent={props => <CustomDrawer {...props} />}
      screenOptions={{
        headerShown: false,
        drawerActiveBackgroundColor: COLORS.primary,
        drawerActiveTintColor: COLORS.white,
        drawerLabelStyle: {
          marginLeft: -20,
        },
      }}>
      <Drawer.Screen
        name={ROUTES.HOME_DRAWER}
        component={Home}
        options={{
          title: 'Home',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="home-sharp" size={18} color={color} />
          ),
        }}
      />
      {/* <Drawer.Screen
        name={ROUTES.DRIVERS_DRAWER}
        component={ViewDrivers}
        options={{
          title: 'View Drivers',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="home-sharp" size={18} color={color} />
          ),
        }}
      /> */}



      {/* <Drawer.Screen
        name={ROUTES.WALLET_DRAWER}
        component={Wallet}
        options={{
          title: 'Wallet',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="wallet" size={18} color={color} />
          ),
        }}
      /> */}




<Drawer.Screen
        name={ROUTES.SEARCHBUS_DRAWER}
        component={SearchBus}
        options={{
          title: 'View Bus Numbers',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="list" size={18} color={color} />
          ),
        }}
      />

<Drawer.Screen
        name={ROUTES.MAPS_DRAWER}
        component={Maps}
        options={{
          title: 'Track Bus',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="globe" size={18} color={color} />
          ),
        }}
      />

<Drawer.Screen
        name={ROUTES.REPORTACCIDENTS_DRAWER}
        component={ReportAccidents}
        options={{
          title: 'Report Issue',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="document-text-outline" size={18} color={color} />
          ),
        }}
      />

<Drawer.Screen
        name={ROUTES.PROFILE_DRAWER}
        component={Profile}
        options={{
          title: 'Profile',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="person-circle-outline" size={18} color={color} />
          ),
        }}
      />

{/* <Drawer.Screen
        name={ROUTES.ADDBUSES_DRAWER}
        component={Addbuses}
        options={{
          title: 'Add Busses',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="home-sharp" size={18} color={color} />
          ),
        }}
      /> */}

{/* 
      <Drawer.Screen
        name={ROUTES.NOTIFICATIONS_DRAWER}
        component={Notifications}
        options={{
          title: 'Notifications',
          drawerIcon: ({focused, color, size}) => (
            <Icon name="notifications" size={18} color={color} />
          ),
        }}
      /> */}
    </Drawer.Navigator>
  );
}

export default DrawerNavigator;
