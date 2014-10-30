'use strict';

CKEDITOR.editorConfig = function(config) {
  config.toolbar =
  [
    {
      name: 'styles',
      items : [ 'Format' ]
    },
    {
      name: 'basicstyles',
      items : [ 'Bold','Italic','Strike','-','RemoveFormat' ]
    },
    {
      name: 'paragraph',
      items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-' ]
    }
  ];
};
