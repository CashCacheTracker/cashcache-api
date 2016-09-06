# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160906033044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "postgis"

  create_table "account_snapshots", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.float    "value"
    t.string   "note"
    t.date     "month"
    t.uuid     "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_snapshots_on_account_id", using: :btree
  end

  create_table "accounts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.integer  "balance_type"
    t.boolean  "tax_advantaged", default: false
    t.string   "ticker"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "ar_internal_metadata", primary_key: "key", id: :string, force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, force: :cascade do |t|
    t.string  "auth_name", limit: 256
    t.integer "auth_srid"
    t.string  "srtext",    limit: 2048
    t.string  "proj4text", limit: 2048
  end

  create_table "transactions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.float    "value"
    t.string   "note"
    t.date     "date"
    t.string   "description"
    t.string   "location"
    t.boolean  "is_split",    default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end


  create_view :net_worth_snapshots,  sql_definition: <<-SQL
      SELECT account_snapshots.month,
      sum(account_snapshots.value) AS total
     FROM account_snapshots
    GROUP BY account_snapshots.month;
  SQL

  create_view :geography_columns,  sql_definition: <<-SQL
      SELECT current_database() AS f_table_catalog,
      n.nspname AS f_table_schema,
      c.relname AS f_table_name,
      a.attname AS f_geography_column,
      postgis_typmod_dims(a.atttypmod) AS coord_dimension,
      postgis_typmod_srid(a.atttypmod) AS srid,
      postgis_typmod_type(a.atttypmod) AS type
     FROM pg_class c,
      pg_attribute a,
      pg_type t,
      pg_namespace n
    WHERE ((t.typname = 'geography'::name) AND (a.attisdropped = false) AND (a.atttypid = t.oid) AND (a.attrelid = c.oid) AND (c.relnamespace = n.oid) AND (NOT pg_is_other_temp_schema(c.relnamespace)) AND has_table_privilege(c.oid, 'SELECT'::text));
  SQL

  create_view :geometry_columns,  sql_definition: <<-SQL
      SELECT (current_database())::character varying(256) AS f_table_catalog,
      n.nspname AS f_table_schema,
      c.relname AS f_table_name,
      a.attname AS f_geometry_column,
      COALESCE(postgis_typmod_dims(a.atttypmod), sn.ndims, 2) AS coord_dimension,
      COALESCE(NULLIF(postgis_typmod_srid(a.atttypmod), 0), sr.srid, 0) AS srid,
      (replace(replace(COALESCE(NULLIF(upper(postgis_typmod_type(a.atttypmod)), 'GEOMETRY'::text), st.type, 'GEOMETRY'::text), 'ZM'::text, ''::text), 'Z'::text, ''::text))::character varying(30) AS type
     FROM ((((((pg_class c
       JOIN pg_attribute a ON (((a.attrelid = c.oid) AND (NOT a.attisdropped))))
       JOIN pg_namespace n ON ((c.relnamespace = n.oid)))
       JOIN pg_type t ON ((a.atttypid = t.oid)))
       LEFT JOIN ( SELECT s.connamespace,
              s.conrelid,
              s.conkey,
              replace(split_part(s.consrc, ''''::text, 2), ')'::text, ''::text) AS type
             FROM pg_constraint s
            WHERE (s.consrc ~~* '%geometrytype(% = %'::text)) st ON (((st.connamespace = n.oid) AND (st.conrelid = c.oid) AND (a.attnum = ANY (st.conkey)))))
       LEFT JOIN ( SELECT s.connamespace,
              s.conrelid,
              s.conkey,
              (replace(split_part(s.consrc, ' = '::text, 2), ')'::text, ''::text))::integer AS ndims
             FROM pg_constraint s
            WHERE (s.consrc ~~* '%ndims(% = %'::text)) sn ON (((sn.connamespace = n.oid) AND (sn.conrelid = c.oid) AND (a.attnum = ANY (sn.conkey)))))
       LEFT JOIN ( SELECT s.connamespace,
              s.conrelid,
              s.conkey,
              (replace(replace(split_part(s.consrc, ' = '::text, 2), ')'::text, ''::text), '('::text, ''::text))::integer AS srid
             FROM pg_constraint s
            WHERE (s.consrc ~~* '%srid(% = %'::text)) sr ON (((sr.connamespace = n.oid) AND (sr.conrelid = c.oid) AND (a.attnum = ANY (sr.conkey)))))
    WHERE ((c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'm'::"char", 'f'::"char"])) AND (NOT (c.relname = 'raster_columns'::name)) AND (t.typname = 'geometry'::name) AND (NOT pg_is_other_temp_schema(c.relnamespace)) AND has_table_privilege(c.oid, 'SELECT'::text));
  SQL

  create_view :raster_columns,  sql_definition: <<-SQL
      SELECT current_database() AS r_table_catalog,
      n.nspname AS r_table_schema,
      c.relname AS r_table_name,
      a.attname AS r_raster_column,
      COALESCE(_raster_constraint_info_srid(n.nspname, c.relname, a.attname), ( SELECT st_srid('010100000000000000000000000000000000000000'::geometry) AS st_srid)) AS srid,
      _raster_constraint_info_scale(n.nspname, c.relname, a.attname, 'x'::bpchar) AS scale_x,
      _raster_constraint_info_scale(n.nspname, c.relname, a.attname, 'y'::bpchar) AS scale_y,
      _raster_constraint_info_blocksize(n.nspname, c.relname, a.attname, 'width'::text) AS blocksize_x,
      _raster_constraint_info_blocksize(n.nspname, c.relname, a.attname, 'height'::text) AS blocksize_y,
      COALESCE(_raster_constraint_info_alignment(n.nspname, c.relname, a.attname), false) AS same_alignment,
      COALESCE(_raster_constraint_info_regular_blocking(n.nspname, c.relname, a.attname), false) AS regular_blocking,
      _raster_constraint_info_num_bands(n.nspname, c.relname, a.attname) AS num_bands,
      _raster_constraint_info_pixel_types(n.nspname, c.relname, a.attname) AS pixel_types,
      _raster_constraint_info_nodata_values(n.nspname, c.relname, a.attname) AS nodata_values,
      _raster_constraint_info_out_db(n.nspname, c.relname, a.attname) AS out_db,
      _raster_constraint_info_extent(n.nspname, c.relname, a.attname) AS extent,
      COALESCE(_raster_constraint_info_index(n.nspname, c.relname, a.attname), false) AS spatial_index
     FROM pg_class c,
      pg_attribute a,
      pg_type t,
      pg_namespace n
    WHERE ((t.typname = 'raster'::name) AND (a.attisdropped = false) AND (a.atttypid = t.oid) AND (a.attrelid = c.oid) AND (c.relnamespace = n.oid) AND ((c.relkind)::text = ANY ((ARRAY['r'::character(1), 'v'::character(1), 'm'::character(1), 'f'::character(1)])::text[])) AND (NOT pg_is_other_temp_schema(c.relnamespace)) AND has_table_privilege(c.oid, 'SELECT'::text));
  SQL

  create_view :raster_overviews,  sql_definition: <<-SQL
      SELECT current_database() AS o_table_catalog,
      n.nspname AS o_table_schema,
      c.relname AS o_table_name,
      a.attname AS o_raster_column,
      current_database() AS r_table_catalog,
      (split_part(split_part(s.consrc, '''::name'::text, 1), ''''::text, 2))::name AS r_table_schema,
      (split_part(split_part(s.consrc, '''::name'::text, 2), ''''::text, 2))::name AS r_table_name,
      (split_part(split_part(s.consrc, '''::name'::text, 3), ''''::text, 2))::name AS r_raster_column,
      (btrim(split_part(s.consrc, ','::text, 2)))::integer AS overview_factor
     FROM pg_class c,
      pg_attribute a,
      pg_type t,
      pg_namespace n,
      pg_constraint s
    WHERE ((t.typname = 'raster'::name) AND (a.attisdropped = false) AND (a.atttypid = t.oid) AND (a.attrelid = c.oid) AND (c.relnamespace = n.oid) AND ((c.relkind)::text = ANY ((ARRAY['r'::character(1), 'v'::character(1), 'm'::character(1), 'f'::character(1)])::text[])) AND (s.connamespace = n.oid) AND (s.conrelid = c.oid) AND (s.consrc ~~ '%_overview_constraint(%'::text) AND (NOT pg_is_other_temp_schema(c.relnamespace)) AND has_table_privilege(c.oid, 'SELECT'::text));
  SQL

end
