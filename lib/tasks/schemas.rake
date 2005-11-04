desc "Create new db/schema files using the migrations.  Requires schema_generator."
task :schemas do
  `./script/generate schema --force`
  `sed s/InnoDB/MyISAM/ < db/schema.mysql.sql > db/schema.mysql-v3.sql`
end
