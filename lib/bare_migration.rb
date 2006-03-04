# bare_migration.rb
# Scott Bronson
# 26 Jan 2006
#
# This module provides bare ActiveRecord::Base objects for migration
# scripts.
#
# Most migration scripts use model classes to move data.  This is
# fine when the schema you're migrating from is compatible with your
# current models.  It's disastrous when your models have changed
# significantly.
#
# This class allows you to use bare ActiveRecord classes in your migrate
# scripts instead of your models so there is no chance of compatibility
# problems.
#
# TODO: Make associations work (has_a, etc.) without requiring legacy calls
# TODO: If a class already exists when defining it then Ruby just adds to
#       the existing class.  This is why migration objects need to be
#       named "BareArticle12" instead of just "BareArticle".  This stinks
#       and should be fixed.  It won't be an easy fix though.
# TODO: I know that STI (inheritance) won't work, but it should be
#       simple enough to change instantiate_without_callbacks to make
#       it work.
# TODO: Create a test framework.


# To use:
#
# - Create bare classes instead of models in your migration script.
#   For instance, this would declare a bare object that matches an
#   Aritcle model:           12_migration.rb
#
#   class Bare12Article < ActiveRecord::Base
#     include BareMigration
#   end
#
#   Don't forget to add the "12" to ensure this class is unique to this
#   migration script.  When migration scripts share objects, they can
#   interact in very unpredictable ways.
#
#   Use set_table_name if the object doesn't calculate its table name
#   properly.
#
# - Then, use the bare objects to migrate the data:
#
#   Bare12Article.find(:all).each do |a|
#     a.published = 1
#   end
#
# - Now your Artcile module can change all it wants and your migration
#   script will still work.


module BareMigration
  def self.append_features(base)
    base.extend(ClassMethods)

	# Set the table name by eradicating "Bare" from the calculated table name.
	# You can still use set_table_name if this is wrong.
	base.set_table_name(base.table_name.sub(/bare\d*_?/, ''))
  end

  module ClassMethods
    # The problem with STI is that it causes AR to instantiate and
    # return classes DIFFERENT from the class that called find()
    # (classes that come from your app/models dir, a no-no when
    # migrating).  For now, this routine overrides that behavior
    # so that you will ONLY get the same class as the one that called
    # find.  (todo: make STI work again)
    def instantiate_without_callbacks(record)
      object = allocate
      object.instance_variable_set("@attributes", record)
      object
    end
  end
end

