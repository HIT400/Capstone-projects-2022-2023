export default {
  name: 'category',
  title: 'Category',
  type: 'document',
  fields: [
    {
      name: 'name',
      title: 'Category name',
      type: 'string',
      validation: Rule => Rule.required(),
    },
    {
      name: 'image',
      title: 'Image of Category',
      type: 'image',
    },
    {
      name: 'short_description',
      type: 'string',
      title: 'Description',
      validation: Rule => Rule.max(500),
    },
    {
      name: 'artifacts',
      title: 'Artifacts',
      type: 'array',
      of: [{type: 'reference', to: [{type: 'artifacts'}]}],
      readOnly: false,
    },
  ],
};
