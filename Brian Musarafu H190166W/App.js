import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import Tabs from './navigation/Tabs';
import HomeScreen from './screens/HomeScreen';
import ArtifactDetails from './screens/ArtifactDetails';

const Stack = createNativeStackNavigator();

const App = () => {
  return (
    <NavigationContainer>
      <Stack.Navigator
        screenOptions={{
          headerShown: false,
          cardStyle: {backgroundColor: 'transparent'},
        }}>
        <Stack.Screen
          name="Tabs"
          component={Tabs}
          options={{
            headerShown: false,
          }}
        />

        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="ArtifactDetails" component={ArtifactDetails} />
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default App;
