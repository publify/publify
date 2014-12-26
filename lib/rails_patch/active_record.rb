ActiveRecord::Type::Serialized.class_eval do
  # Backport https://github.com/rails/rails/commit/5ab62475384bac7f642a1df38fbc36ea2fd598c8
  # FIXME: Remove once 4.2.1 is out.
  def changed_in_place?(raw_old_value, value)
    return false if value.nil?
    subtype.changed_in_place?(raw_old_value, type_cast_for_database(value))
  end
end
