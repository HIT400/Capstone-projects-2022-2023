const sanityClient = require('@sanity/client');
const imageUrlBuilder = require('@sanity/image-url');
const client = sanityClient({
  projectId: 'ocs5fcwk',
  dataset: 'production',
  apiVersion: '2021-03-25', // use current UTC date - see "specifying API version"!
  token: '', // or leave blank for unauthenticated usage
  useCdn: true, // `false` if you want to ensure fresh data
});

const builder = imageUrlBuilder(client);
export const urlFor = (source)=> {
  return builder.image(source)
}

export default client;
