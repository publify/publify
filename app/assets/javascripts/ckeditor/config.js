CKEDITOR.editorConfig = function (config) {
  config.filebrowserImageBrowseLinkUrl = '/admin/ckeditor/pictures';
  config.filebrowserImageBrowseUrl = '/admin/ckeditor/pictures';
  config.filebrowserImageUploadUrl = '/admin/ckeditor/pictures';
  config.filebrowserBrowseUrl = 'admin/ckeditor/attachment_files';
  config.filebrowserUploadUrl = 'admin/ckeditor/attachment_files';
  config.toolbar =
  [
    {
      name: 'styles',
      items: ['Format']
    },
    {
      name: 'basicstyles',
      items: ['Bold', 'Italic', 'Underline', '-', 'RemoveFormat']
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
