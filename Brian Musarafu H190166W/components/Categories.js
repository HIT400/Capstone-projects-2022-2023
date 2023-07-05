import {ScrollView, StyleSheet} from 'react-native';
import React, {useEffect, useState} from 'react';
import CategoryCard from './CategoryCard';
import client from '../sanity';


const Categories = () => {
  const [categories, setCategories] = useState([]);

  useEffect(() => {
    const query = `
    *[_type=="category"] {
      ...,
    }[]
    `;
    client.fetch(query).then(data => setCategories(data));
  }, []);


  return (
    <ScrollView
      horizontal
      showsHorizontalScrollIndicator={false}
      contentContainerStyle={{
        paddingHorizontal: 15,
        paddingTop: 10,
      }}>
      {categories?.map(category => (
        <CategoryCard
          key={category._id}
          id={category._id}
          imgUrl={category.image}
          title={category.name}
        />
      ))}
  
    </ScrollView>
  );
};

export default Categories;

const styles = StyleSheet.create({});
