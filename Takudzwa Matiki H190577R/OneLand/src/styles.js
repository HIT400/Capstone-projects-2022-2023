import { hover } from '@testing-library/user-event/dist/hover';
import { StyleSheet } from 'react-native';

export const styles = StyleSheet.create({
  searchbar: {
    padding: 25,
    minWidth: '40%',
    position: 'absolute',
    backgroundColor: '#fff',
    top: '35%',
    left: '50%',
    transform: [{ translateX: '-50%' }, { translateY: '-50%' }],
    opacity: 0.75,
    fontWeight: 'bold',
    
  },
   Hover : {
    opacity: 1,
    color: 'blue',
    backgroundColor: 'red',

   },
  resetButton:{
    position: 'absolute',
    top: '35%',
    left: '70%',
    transform: [{ translateX: '-50%' }, { translateY: '-50%' }],
    color: '#000',
    backgroundColor: 'red',
  }
});