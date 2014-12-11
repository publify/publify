CKEDITOR.editorConfig = function (config) {
  config.filebrowserImageBrowseLinkUrl = '/admin/ckeditor/pictures';
  config.filebrowserImageBrowseUrl = '/admin/ckeditor/pictures';
  config.filebrowserImageUploadUrl = '/admin/ckeditor/pictures';
  config.filebrowserBrowseUrl = 'admin/ckeditor/attachment_files';
  config.filebrowserUploadUrl = 'admin/ckeditor/attachment_files';
  config.extraPlugins = 'sourcedialog';
  config.protectedSource.push(/<a data-ck[^>]+>[\s\S]+?<\/a>/g);
  config.allowedContent = true;
  config.contentsCss = '/ckeditor/editor.css';
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
      items: ['Image', 'Sourcedialog']
    }
  ];
};
