module ConfDb


class CreateDb < ActiveRecord::Migration

  def up

create_table :props do |t|
  t.string :key,   null: false
  t.string :value, null: false
  t.string :kind     # e.g. version|user|sys(tem)|db etc. # note: can NOT use type - already used by ActiveRecord
  t.timestamps
end

  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end  # class CreateDb

end  # module ConfDb
