CKEDITOR.editorConfig = function (config) {
  config.filebrowserImageBrowseLinkUrl = '/ckeditor/pictures';
  config.filebrowserImageBrowseUrl = '/ckeditor/pictures';
  config.filebrowserImageUploadUrl = '/ckeditor/pictures';
  config.toolbar =
  [
    {
      name: 'styles',
      items: ['Format']
    },
    {
      name: 'basicstyles',
      items: ['Bold', 'Italic', 'Strike', '-', 'RemoveFormat']
    },
    {
      name: 'paragraph',
      items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-']
    },
    {
      name: 'links',
      items: ['Link', 'Unlink']
    },
    {
      name: 'insert',
      items: ['Image']
    }
  ];
};
