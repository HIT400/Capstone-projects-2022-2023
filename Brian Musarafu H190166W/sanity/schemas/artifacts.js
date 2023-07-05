export default {
  name: 'artifacts',
  title: 'Artifacts',
  type: 'document',
  fields: [
    {
      name: 'title',
      type: 'string',
      title: 'Artifact name',
      validation: Rule => Rule.required(),
    },
    {
      name: 'short_description',
      type: 'string',
      title: 'Description',
      validation: Rule => Rule.max(1000),
    },
    {
      name: 'imgUrl',
      type: 'image',
      title: 'Display Image',
    },
    {
      name: 'ar_imgUrl',
      type: 'file',
      title: '3D AR Image',
    },
    {
      name: 'ar_texture',
      type: 'file',
      title: '3D Texture',
    },
    {
      name: 'ar_material',
      type: 'file',
      title: '3D Material',
    },
    {
      name: 'other_images',
      type: 'array',
      title: 'Images of Artifact',
      of: [{type: 'image'}],
    },
    {
      name: 'category',
      type: 'reference',
      title: 'Category',
      validation: Rule => Rule.required(),
      to: [{type: 'category'}],
    },
    {
      name: 'location',
      type: 'geopoint',
      title: 'Location',
    },
    {
      name: 'location_in_building',
      type: 'string',
      title: 'Location in Building',
      validation: Rule => Rule.required(),
    },
    {
      name: 'floor',
      type: 'number',
      title: 'Floor in Building',
      validation: Rule => Rule.required(),
    },
    {
      name: 'rating',
      type: 'number',
      title: 'Enter a Rating from (1-5 Stars)',
      validation: Rule =>
        Rule.required()
          .min(1)
          .max(5)
          .error('Please enter a vale between 1 and 5'),
    },
  ],
};
