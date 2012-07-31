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
# - Create bare inner classes instead of models in your migration script.
#   For instance, this would declare a bare object that matches an Article
#   model:
#
#   class Migration < ActiveRecord::Migration
#     class BareArticle
#       include BareMigration
#     end
#     ...
#   end
#
#   Don't forget to nest the declaration of the bare model in order to ensure
#   that the class name is unique. Another option is to declare it outside
#   the scope of the migration with a number based on the migration
#   number, say Bare3Article
#
#   Use table_name= if the object doesn't calculate its table name
#   properly.
#
# - Then, use the bare objects to migrate the data:
#
#   BareArticle.find(:all).each do |a|
#     a.published = 1
#   end
#
# - Now your Article module can change all it wants and your migration
#   script will still work.


module BareMigration
  def self.append_features(base)
    base.extend(ClassMethods)

    # Set the table name by eradicating "Bare" from the calculated table name.
    # You can still use table_name= if this is wrong.
    base.table_name = base.table_name.sub(/.*?bare\d*_?/, '')

    # Default to ignoring the inheritance column
    base.inheritance_column = :ignore_inheritance_column
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

    def find_and_update(find_type=:all, *rest, &update_block)
      self.transaction do
        self.find(find_type, *rest).each do |item|
          update_block[item]
          item.save!
        end
      end
    end
  end
end

class ActiveRecord::Migration
  def self.opposite_of(method)
    method = method.to_s
    method.sub!(/^add_/, 'remove_') || method.sub!(/^remove_/, 'add_') ||
      method.sub!(/^create/, 'drop') || method.sub!(/^drop/, 'create') ||
        method.sub!(/^rename_column/, 'reverse_columns')
  end

  def self.modify_schema(method, *args)
    case method.to_s
    when 'create_table'
      block = args.last.is_a?(Proc) ? args.pop : Proc.new {|t| nil}
      create_table *args, &block
    when 'remove_column'
      remove_column args[0], args[1]
    when 'reverse_columns'
      (table, to_col, from_col) = args
      rename_column table, from_col, to_col
    else
      send(method, *args)
    end
  end

  def self.modify_tables_and_update(*colspecs, &block)
    unless colspecs.first.is_a?(Array)
      colspecs = [colspecs]
    end
    begin
      updated_classes = []
      colspecs.each do |spec|
        if spec[1].is_a?(Class)
          updated_classes << spec[1]
          spec[1] = spec[1].table_name.to_sym
        end
      end
      colspecs.each {|spec| modify_schema(*spec) }
      updated_classes.uniq!
      if updated_classes.size == 1 && block && block.arity == 1
        say "About to call find_and_update"
        updated_classes.first.find_and_update(:all, &block)
      else
        block.call if block
      end
    rescue Exception => e
      colspecs.reverse.each do |(method, table, column, *rest)|
        modify_schema(opposite_of(method), table, column, *rest) rescue nil
      end
      raise e
    end
  end
end
