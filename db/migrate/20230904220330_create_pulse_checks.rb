class CreatePulseChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :pulse_checks do |t|
      t.text :summary
      t.jsonb :core_value_scores, default: [], null: false

      t.timestamps
    end
  end
end
