import {StyleSheet, Text, View} from 'react-native';
import React, {useEffect, useState} from 'react';
import {
  ViroARScene,
  ViroARSceneNavigator,
  ViroAmbientLight,
  Viro3DObject,
  ViroARTrackingTargets,
  ViroARImageMarker,
  ViroText,
  ViroVideo,
  ViroNode,
} from '@viro-community/react-viro';
import client, {urlFor} from '../sanity';

const LiveStream = () => {
  const [objects, setObjects] = useState([]);

  useEffect(() => {
    const query = `
      *[_type == "artifacts" && rating >= 4] {
        title,
        short_description,
        imgUrl,
        ar_imgUrl,
        other_images,
        category->,
        location,
        location_in_building,
        floor,
        rating
      }
    `;
    client.fetch(query).then(data => setObjects(data));
  }, []);

  // Register targets
  useEffect(() => {
    if (objects.length > 0) {
      const targets = {};

      objects.forEach(object => {
        targets[object.title] = {
          source: {
            uri: urlFor(object.imgUrl).url(),
          },
          orientation: 'Up',
          physicalWidth: 0.165, // Real world width in metres
          type: 'Image',
        };
      });

      ViroARTrackingTargets.createTargets(targets);
    }
  }, [objects]);

  const anchorFound = anchor => {
    console.log('Anchor/Image Detected:', anchor);
  };

  const trackingUpdated = (state, reason) => {
    console.log(`AR Tracking Updated: ${state} - ${reason}`);
  };

  return (
    <ViroARScene onTrackingUpdated={trackingUpdated}>
      {objects.map(object => (
        <ViroARImageMarker
          key={object._id}
          target={object.title}
          onAnchorFound={anchorFound}>
          <ViroAmbientLight color="#FFFFFF" />
          <ViroNode>
            <Viro3DObject
              source={{
                uri: urlFor(object.ar_imgUrl).url(),
              }}
              resources={[
                {
                  uri: '',
                  type: 'MTL',
                },
              ]}
              scale={[0.01, 0.01, 0.01]}
              rotation={[0, -170, 0]}
              type="OBJ"
            />
            <ViroText
              text={object.title}
              textAlign="left"
              textAlignVertical="top"
              textLineBreakMode="justify"
              textClipMode="clipToBounds"
              color="#FFFFFF"
              position={[0, 0, -0.1]}
              style={{fontSize: 24}}
            />
          </ViroNode>
        </ViroARImageMarker>
      ))}
    </ViroARScene>
  );
};

export default () => {
  return (
    <ViroARSceneNavigator autofocus={true} initialScene={{scene: LiveStream}} />
  );
};
